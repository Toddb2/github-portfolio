% Constants
k = 8.99e9;  % Coulomb's constant
Q = [-10, 20, 20];  % Charges in Coulombs
x = [0.005, 0, -0.005];  % x-coordinates of charges (meters)
y = [-0.005, 0, 0];  % y-coordinates of charges (meters)

% Define the grid for the electric field visualization
[X, Y] = meshgrid(linspace(-0.01, 0.01, 100), linspace(-0.01, 0.01, 100));

% Initialize electric field components
Ex = zeros(size(X));
Ey = zeros(size(Y));

% Calculate the electric field due to each charge and sum them
for i = 1:numel(Q)
    r = sqrt((X - x(i)).^2 + (Y - y(i)).^2);  % Distance to each charge
    r(r < 0.01) = 0.01;  % Avoid division by zero
    E = k * Q(i) ./ r.^2;
    Ex = Ex + E .* (X - x(i)) ./ r;
    Ey = Ey + E .* (Y - y(i)) ./ r;
end

% Truncate electric field to ±2e17 V/m
Ex(Ex > 2e17) = 2e17;
Ex(Ex < -2e17) = -2e17;
Ey(Ey > 2e17) = 2e17;
Ey(Ey < -2e17) = -2e17;

% Total electric field magnitude
E = sqrt(Ex.^2 + Ey.^2);

% Create the contour3 plot
figure;
contour3(X, Y, E, 50);
title('Contour3 Plot');
xlabel('x (m)');
ylabel('y (m)');

% Create the contourf plot
figure;
contourf(X, Y, E, 50);
colorbar;
title('Contourf Plot');
xlabel('x (m)');
ylabel('y (m)');

% Create the pcolor+streamslice plot
figure;
pcolor(X, Y, E);
shading interp;
colormap('jet');
colorbar;
title('Pcolor+Streamslice Plot');
xlabel('x (m)');
ylabel('y (m)');
hold on;
streamslice(X, Y, Ex, Ey, 2);

% Super title for each figure
subtitle('Electric Field due to Three Point Charges');
