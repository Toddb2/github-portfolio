clear;
clc
clf;



% Task 3: Gravitational Field Between Earth and Sun
% Constants
mass_sun = 1.989e30; % kg
mass_earth = 5.972e24; % kg
distance = 149.6e9 * 1000; % meters (149.6 million kilometers)

% Define the range for gravitational field calculation
r = linspace(0, distance, 1000); % Range of distances in meters

% Calculate the gravitational field using the Gfield function
G_total = Gfield(r, mass_sun) - Gfield(distance - r, mass_earth);

% Truncate gravitational field values
G_total(G_total > 20) = 20;
G_total(G_total < -20) = -20;

% Plot the gravitational field
figure;
plot(r, G_total);
xlabel('Distance from Sun (m)');
ylabel('Gravitational Field (m/s^2)');
title('Gravitational Field Between Earth and Sun');
grid on;

% Create a log-log plot for absolute gravitational field
figure;
loglog(r, abs(G_total));
xlabel('Distance from Sun (m)');
ylabel('Absolute Gravitational Field (m/s^2)');
title('Absolute Gravitational Field (Log-Log Scale)');
grid on;

