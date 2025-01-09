import numpy as np
import matplotlib.pyplot as plt


# Constants
k_B = 8.617e-5  
mu = 1  


# Initialize a random lattice of +1 and -1 spins
def initialize_lattice(L):  
    total_spins = L * L
    spins = [-1] * (total_spins // 2) + [1] * (total_spins // 2)
    np.random.shuffle(spins)
    return np.array(spins).reshape(L, L)


# calculate the change in energy ΔE for a given spin flip
def delta_E(lattice, i, j, J):
    L = len(lattice)
    s = lattice[i, j]
    # Sum interaction with 4 nearest neighbors
    neighbors = lattice[(i-1) % L, j] + lattice[(i+1) % L, j] + lattice[i, (j-1) % L] + lattice[i, (j+1) % L]
    return 2 * J * s * neighbors  


# compute total energy 
def total_energy(lattice, J):
    energy = 0
    L = len(lattice)
    for i in range(L):
        for j in range(L):
            s = lattice[i, j]
            neighbors = lattice[(i-1) % L, j] + lattice[(i+1) % L, j] + lattice[i, (j-1) % L] + lattice[i, (j+1) % L]
            energy += -J * s * neighbors
    return energy / 2  


# compute magnetization
def magnetization(lattice, mu):
    return mu * np.sum(lattice)


# Metropolis Algorithm 
def metropolis_production(lattice, J, beta, num_steps, equilibration_steps):
    L = len(lattice)
    energy = total_energy(lattice, J)
    mag = magnetization(lattice, mu)
    
    energies = []
    magnetizations = []
    avg_energies = []
    avg_magnetizations = []
    
    total_energy_sum = 0
    total_mag_sum = 0
    
    for step in range(num_steps):
        # Randomly pick spin 
        i, j = np.random.randint(0, L), np.random.randint(0, L)
        
        # energy change if spin is flipped
        dE = delta_E(lattice, i, j, J)
        
        # If ΔE < 0 flip || use K_b
        if dE < 0 or np.random.rand() < np.exp(-beta * dE):
            lattice[i, j] *= -1  
            energy += dE  
            mag += 2 * lattice[i, j] * mu  


       
        if step >= equilibration_steps:
            energies.append(energy)
            magnetizations.append(mag)
            
            # Calculate running averages
            total_energy_sum += energy
            total_mag_sum += mag
            avg_energy = total_energy_sum / len(energies)
            avg_mag = total_mag_sum / len(magnetizations)
            
            avg_energies.append(avg_energy)
            avg_magnetizations.append(avg_mag)


    return energies, magnetizations, avg_energies, avg_magnetizations, lattice


# plot spin configuration
def plot_spin_configuration(spin_lattice, title):
    plt.imshow(spin_lattice, cmap='bwr', interpolation='nearest')
    plt.title(title)
    plt.colorbar(label='Spin')
    plt.show()


# simulations for both ferro and antiferro
def run_simulation(L, J_values, temperatures, production_steps, equilibration_steps):
    for J, interaction_type in J_values.items():
        print(f"Running simulation for {interaction_type} with J = {J:.3e} eV")
        
        avg_energies_vs_temp = []
        avg_magnetizations_vs_temp = []
        
        lattice = initialize_lattice(L)  
        
        for T in temperatures:
            beta = 1 / (k_B * T)  
            energies, magnetizations, avg_energies, avg_magnetizations, _ = metropolis_production(
                lattice, J, beta, production_steps, equilibration_steps
            )
            
            
            avg_energies_vs_temp.append(np.mean(avg_energies))
            avg_magnetizations_vs_temp.append(np.mean(avg_magnetizations))
        
        # Plot results 
        plt.figure(figsize=(12, 5))
        
        # Energy 
        plt.subplot(1, 2, 1)
        plt.plot(temperatures, avg_energies_vs_temp, marker='o')
        plt.title(f'Average Energy vs Temperature ({interaction_type})')
        plt.xlabel('Temperature (K)')
        plt.ylabel('Average Energy (eV)')
        
        # Magnetization
        plt.subplot(1, 2, 2)
        plt.plot(temperatures, avg_magnetizations_vs_temp, marker='o', color='r')
        plt.title(f'Average Magnetization vs Temperature ({interaction_type})')
        plt.xlabel('Temperature (K)')
        plt.ylabel('Average Magnetization')
        
        plt.tight_layout()
        plt.show()


        # Spin config for 5,50 & 200k 
        for temp in [5, 50, 200]:
            beta = 1 / (k_B * temp)
            
            lattice_initial = initialize_lattice(L)
            plot_spin_configuration(lattice_initial, f"{interaction_type} Initial Spin Configuration at T={temp}K")
            
            #run metropolis
            _, _, _, _, lattice_final = metropolis_production(lattice_initial, J, beta, production_steps, equilibration_steps)
            plot_spin_configuration(lattice_final, f"{interaction_type} Final Spin Configuration at T={temp}K")


# Simulation parameters
L = 20  
J_values = {5e-3: 'Ferromagnet', -5e-3: 'Antiferromagnet'}  
temperatures = np.linspace(5, 200, num=10) 
production_steps = 10000  
equilibration_steps = 4000  


# Run the simulation 
run_simulation(L, J_values, temperatures, production_steps, equilibration_steps)