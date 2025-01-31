% Task 4: Plot Electric Field Due to Three Charges in 2D Space
% Define charge values and positions
Q1 = -10e-6; % Coulombs
Q2 = 20e-6; % Coulombs
Q3 = 20e-6; % Coulombs
x1 = 0.005; % m
x2 = 0; % m
x3 = -0.005; % m
y1 = -0.005; % m
y2 = 0; % m
y3 = 0; % m

% Create a grid for x and y coordinates
[x, y] = meshgrid(linspace(-0.01, 0.01, 100), linspace(-0.01, 0.01, 100));

% Initialize electric field components
Ex = zeros(size(x));
Ey = zeros(size(y));

% Calculate electric field due to each charge and sum them up
for i = 1:numel(x)
    r1 = sqrt((x(i) - x1)^2 + (y(i) - y1)^2);
    r2 = sqrt((x(i) - x2)^2 + (y(i) - y2)^2);
    r3 = sqrt((x(i) - x3)^2 + (y(i) - y3)^2);
    
    E1 = Efield(r1, Q1);
    E2 = Efield(r2, Q2);
    E3 = Efield(r3, Q3);
    
    Ex(i) = E1 * cos(atan2(y(i) - y1, x(i) - x1)) + E2 * cos(atan2(y(i) - y2, x(i) - x2)) + E3 * cos(atan2(y(i) - y3, x(i) - x3));
    Ey(i) = E1 * sin(atan2(y(i) - y1, x(i) - x1)) + E2 * sin(atan2(y(i) - y2, x(i) - x2)) + E3 * sin(atan2(y(i) - y3, x(i) - x3));
end

% Truncate electric field values
Ex(Ex > 2e17) = 2e17;
Ex(Ex < -2e17) = -2e17;
Ey(Ey > 2e17) = 2e17;
Ey(Ey < -2e17) = -2e17;

% Plot electric field using contour3
figure;
contour3(x, y, Ex, 20);
xlabel('X Position (m)');
ylabel('Y Position (m)');
zlabel('Electric Field (V/m)');
title('Electric Field in 2D Space (Ex)');

% Plot electric field using contourf
figure;
contourf(x, y, Ex, 20);
colorbar;
xlabel('X Position (m)');
ylabel('Y Position (m)');
title('Electric Field in 2D Space (Ex - Filled Contours)');