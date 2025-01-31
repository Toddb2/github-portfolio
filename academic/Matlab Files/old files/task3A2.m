% Define constants
G = 6.67430e-11;  % Gravitational constant (m^3/kg/s^2)
M = 5.972e24;     % Mass of Earth (kg)
r = 149.6e9 * 1000;  % Distance between Earth and the Sun (converted to meters)

% Create a range of distances
distances = linspace(0, r, 1000);

% Calculate gravitational field at each distance
gravitational_field = G * M ./ (distances.^2);

% Truncate the gravitational field to ±20 m/s^2
gravitational_field(gravitational_field > 20) = 20;
gravitational_field(gravitational_field < -20) = -20;

% Create a plot of the truncated gravitational field
figure(1);
plot(distances, gravitational_field);
xlabel('Distance from Earth to Sun (meters)');
ylabel('Gravitational Field (m/s^2)');
title('Total Gravitational Field vs. Distance');
grid on;

% Create a log-log plot of absolute values
figure(2);
loglog(distances, abs(gravitational_field));
xlabel('Distance from Earth to Sun (meters)');
ylabel('Absolute Gravitational Field (m/s^2)');
title('Absolute Gravitational Field (log-log)');
grid on;

% Calculate the absolute values of the gravitational field
abs_gravitational_field = abs(gravitational_field);

% Find the distance where the gravitational field goes to zero
zero_gravity_distance = min(distances(abs_gravitational_field < 1e-10));
fprintf('Distance where gravitational field goes to zero: %e meters\n', zero_gravity_distance);
