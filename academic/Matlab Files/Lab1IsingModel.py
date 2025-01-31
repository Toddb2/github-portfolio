import numpy as np
import matplotlib.pyplot as plt

# Constants
J = 5e-3  # Interaction strength in meV
kB = 8.617333262145e-5  # Boltzmann constant in eV/K
temperatures = [50, 5, 200]  # Temperatures in K
lattice_size = 20
iterations = 4000

# Initialize lattice with equal number of +1 and -1 spins
def initialize_lattice(size):
    lattice = np.random.choice([-1, 1], size=(size, size))
    return lattice

# Plotting function
def plot_lattice(lattice, title="Spin Configuration"):
    plt.imshow(lattice, cmap='coolwarm', interpolation='nearest')
    plt.title(title)
    plt.colorbar(label='Spin')
    plt.show()

# Calculate energy of the lattice
def calculate_energy(lattice, J):
    energy = 0
    size = lattice.shape[0]
    for i in range(size):
        for j in range(size):
            S = lattice[i, j]
            neighbors = lattice[(i+1)%size, j] + lattice[i, (j+1)%size] + lattice[(i-1)%size, j] + lattice[i, (j-1)%size]
            energy += -J * S * neighbors
    return energy / 2  # Each pair counted twice

# Calculate magnetization of the lattice
def calculate_magnetization(lattice):
    return np.sum(lattice)

# Metropolis algorithm step
def metropolis_step(lattice, T, J):
    size = lattice.shape[0]
    for _ in range(size**2):
        i, j = np.random.randint(0, size, 2)
        S = lattice[i, j]
        neighbors = lattice[(i+1)%size, j] + lattice[i, (j+1)%size] + lattice[(i-1)%size, j] + lattice[i, (j-1)%size]
        dE = 2 * J * S * neighbors
        if dE < 0 or np.random.rand() < np.exp(-dE / (kB * T)):
            lattice[i, j] *= -1
    return lattice

# Run simulation
def run_simulation(T, J, iterations):
    lattice = initialize_lattice(lattice_size)
    energies = []
    magnetizations = []
    
    for _ in range(iterations):
        lattice = metropolis_step(lattice, T, J)
        energy = calculate_energy(lattice, J)
        magnetization = calculate_magnetization(lattice)
        energies.append(energy)
        magnetizations.append(magnetization)
    
    return lattice, energies, magnetizations

# Main execution
for T in temperatures:
    lattice, energies, magnetizations = run_simulation(T, J, iterations)
    plot_lattice(lattice, title=f"Final Spin Configuration at T={T}K")
    
    plt.figure()
    plt.plot(energies, label='Energy')
    plt.plot(magnetizations, label='Magnetization')
    plt.title(f"Energy and Magnetization at T={T}K")
    plt.xlabel('Iteration')
    plt.ylabel('Value')
    plt.legend()
    plt.show()

# Repeat for anti-ferromagnet
J = -5e-3
for T in temperatures:
    lattice, energies, magnetizations = run_simulation(T, J, iterations)
    plot_lattice(lattice, title=f"Final Spin Configuration at T={T}K (Anti-ferromagnet)")
    
    plt.figure()
    plt.plot(energies, label='Energy')
    plt.plot(magnetizations, label='Magnetization')
    plt.title(f"Energy and Magnetization at T={T}K (Anti-ferromagnet)")
    plt.xlabel('Iteration')
    plt.ylabel('Value')
    plt.legend()
    plt.show()