
% Task 2: Plot Electric Field Due to Three Charges
% Define charge values and positions
Q1 = 20e-6; % Coulombs
Q2 = 20e-6; % Coulombs
Q3 = -20e-6; % Coulombs
r1 = -0.005; % m
r2 = 0; % m
r3 = 0.005; % m
k = 8.988e9; % Coulomb's constant (N m^2/C^2)


% Define the range for electric field calculation
x = linspace(-0.01, 0.01, 1000); % Range of positions in meters

% Initialize electric field vectors for each charge
E1 = zeros(size(x));
E2 = zeros(size(x));
E3 = zeros(size(x));

% Calculate the electric field due to each charge at each position
for i = 1:numel(x)
    r = x(i);
    E1(i) = k * Q1 / (r - r1)^2; % Electric field due to Q1
    E2(i) = k * Q2 / (r - r2)^2; % Electric field due to Q2
    E3(i) = k * Q3 / (r - r3)^2; % Electric field due to Q3
end

% Calculate the total electric field by summing up the contributions from all charges
E_total = E1 + E2 + E3;

% Plot the electric field
figure;
plot(x, E_total);
xlabel('Position (m)');
ylabel('Electric Field (V/m)');
title('Total Electric Field Due to Three Charges');
grid on;
