import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import torch
import torch.nn as nn
import torch.optim as optim

# Set random seeds for reproducibility
np.random.seed(42)
torch.manual_seed(42)

def lj_force(r_vec, epsilon, sigma):
    """Compute the Lennard-Jones force between two particles.

    Parameters:
    - r_vec: The vector from particle i to particle j (np.array of shape (2,))
    - epsilon, sigma: LJ parameters

    Returns:
    - force: The force vector (np.array of shape (2,)) acting on particle i due to j
    """
    r = np.linalg.norm(r_vec)
    if r < 1e-12:  # Avoid division by zero
        return np.zeros(2)

    sr = sigma / r
    sr6 = sr**6
    sr12 = sr**12
    # Force = -dV/dr * (r_vec/r)
    # dV/dr = 24*epsilon*(2*sr^12 - sr^6)/r
    factor = 24 * epsilon * (2*sr12 - sr6) / (r**2)
    force = -factor * r_vec
    return force

def simulate_lj(N=10, box_size=10.0, epsilon=1.0, sigma=1.0, steps=500, dt=0.001):
    """Simulate N particles in a 2D box interacting via Lennard-Jones potential.

    Parameters:
    - N: Number of particles
    - box_size: Size of the square box
    - epsilon, sigma: LJ parameters
    - steps: Number of simulation steps
    - dt: Time step

    Returns:
    - positions: Positions of particles after simulation (N,2)
    - velocities: Velocities of particles after simulation (N,2)
    """
    positions = np.random.rand(N, 2) * box_size
    velocities = np.random.randn(N, 2) * 0.1

    for step in range(steps):
        # Compute forces
        forces = np.zeros((N, 2))
        for i in range(N):
            for j in range(i+1, N):
                r_vec = positions[j] - positions[i]
                # Periodic boundary conditions
                r_vec -= box_size * np.round(r_vec/box_size)
                f = lj_force(r_vec, epsilon, sigma)
                forces[i] += f
                forces[j] -= f

        # Update positions
        positions_new = positions + velocities*dt + 0.5*forces*(dt**2)
        positions_new = positions_new % box_size

        # Recompute forces at new positions
        new_forces = np.zeros((N, 2))
        for i in range(N):
            for j in range(i+1, N):
                r_vec = positions_new[j] - positions_new[i]
                r_vec -= box_size * np.round(r_vec/box_size)
                f = lj_force(r_vec, epsilon, sigma)
                new_forces[i] += f
                new_forces[j] -= f

        velocities_new = velocities + 0.5*(forces + new_forces)*dt

        positions, velocities = positions_new, velocities_new

    return positions, velocities

# Generate dataset
num_samples = 2000
N = 10
box_size = 10.0

X_data = []
y_data = []

print("Generating data...")
for _ in range(num_samples):
    epsilon = np.random.uniform(0.5, 2.0)
    sigma = np.random.uniform(0.8, 1.2)
    pos, vel = simulate_lj(N=N, box_size=box_size, epsilon=epsilon, sigma=sigma, steps=500, dt=0.001)
    snapshot = np.hstack([pos, vel])  # shape: (N,4)
    X_data.append(snapshot)
    y_data.append([epsilon, sigma])

X_data = np.array(X_data)  # (num_samples, N, 4)
y_data = np.array(y_data)  # (num_samples, 2)

# Flatten particle data
X_data_reshaped = X_data.reshape(X_data.shape[0], -1)  # (num_samples, 4*N)

# Split dataset
X_train, X_test, y_train, y_test = train_test_split(X_data_reshaped, y_data, test_size=0.2, random_state=42)

# Scale inputs
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Convert to PyTorch tensors
X_train_torch = torch.tensor(X_train_scaled, dtype=torch.float32)
y_train_torch = torch.tensor(y_train, dtype=torch.float32)
X_test_torch = torch.tensor(X_test_scaled, dtype=torch.float32)
y_test_torch = torch.tensor(y_test, dtype=torch.float32)

# If CUDA is available and you want to use GPU:
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
X_train_torch = X_train_torch.to(device)
y_train_torch = y_train_torch.to(device)
X_test_torch = X_test_torch.to(device)
y_test_torch = y_test_torch.to(device)

# Define a simple feed-forward network in PyTorch
class SimpleNN(nn.Module):
    def __init__(self, input_dim=4*N, hidden=128):
        super(SimpleNN, self).__init__()
        self.fc1 = nn.Linear(input_dim, hidden)
        self.fc2 = nn.Linear(hidden, hidden)
        self.fc3 = nn.Linear(hidden, 2)
        self.relu = nn.ReLU()

    def forward(self, x):
        x = self.relu(self.fc1(x))
        x = self.relu(self.fc2(x))
        x = self.fc3(x)
        return x

model = SimpleNN(input_dim=X_train_torch.shape[1]).to(device)
criterion = nn.MSELoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

# Training loop
epochs = 20
batch_size = 32
num_batches = len(X_train_torch) // batch_size

print("Training model...")
for epoch in range(epochs):
    # Shuffle data indices
    perm = torch.randperm(X_train_torch.size(0))
    epoch_loss = 0.0
    model.train()
    for i in range(num_batches):
        idx = perm[i*batch_size:(i+1)*batch_size]
        X_batch = X_train_torch[idx]
        y_batch = y_train_torch[idx]

        optimizer.zero_grad()
        y_pred = model(X_batch)
        loss = criterion(y_pred, y_batch)
        loss.backward()
        optimizer.step()

        epoch_loss += loss.item()

    epoch_loss /= num_batches
    print(f"Epoch {epoch+1}/{epochs}, Loss: {epoch_loss:.4f}")

# Evaluation
model.eval()
with torch.no_grad():
    y_pred_test = model(X_test_torch).cpu().numpy()

y_test_np = y_test_torch.cpu().numpy()
error = np.mean(np.abs(y_pred_test - y_test_np), axis=0)
print(f"Mean absolute error in epsilon: {error[0]:.3f}")
print(f"Mean absolute error in sigma: {error[1]:.3f}")
