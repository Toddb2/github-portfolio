% Clear all variables and close figures
clear all;
close all;

% Constants
c = 3e8;          % Speed of light (m/s)
e0 = 8.8541878e-12; % Permittivity of free space
mu0 = 1.256637062e-6; % Permeability of free space

% Grid and Computational Parameters
Nz = 2000;         % Domain size
dz = 10e-9;        % Grid spacing in meters
zVec = [0:(Nz-1)] .* dz; % Domain size in meters

% Adjust time step and limit the simulation to 30 seconds
total_timesteps = 100; % Increase the total number of time steps
total_time = 30; % Set the total simulation time to 30 seconds
dt = total_time / total_timesteps;
tVec = [0:(total_timesteps-1)] .* dt; % Time vector

relative_step = dt * c / dz; % Integration step relative to dz/c

% Initial Pulse Parameters
lambda = 0.8e-6;   % Wavelength (m) 800nm
el = 3e-6;         % Total pulse width (m) 3um
zc = 6e-6;         % Initial pulse center position (m)
tau = el / c;      % Total pulse duration (s)
tau_delay = tau;   % Time until the center of the pulse enters
omega = 2 * pi * c / lambda; % Carrier angular frequency

% Initial Conditions for Source on Boundary
Ey = zeros(1, Nz);
Bx = zeros(1, Nz);
Source_Ey_t = exp(-((tVec - tau_delay) / (tau / 2)).^2) .* cos(omega * (tVec - tau_delay));

% Relative Permeability Epsilon
er = ones(1, Nz);

%% FDTD Simulation with Refractive Index Jump

% Introduction of refractive index jump at z0 = 12 microns
z0_index = find(zVec >= 12e-6, 1);
er(z0_index:end) = 1.5^2; % Refractive index of glass

% Initialize figure for time-varying E-field amplitude
figure_time_varying = figure;

for n = 1:total_timesteps
    % Update Magnetic Field Bx
    Bx(1:Nz-1) = Bx(1:Nz-1) + relative_step .* (Ey(2:Nz) - Ey(1:Nz-1)) ./ (mu0 * er(1:Nz-1) .* dz);
    
    % Update Electric Field Ey
    Ey(2:Nz) = Ey(2:Nz) + relative_step .* (Bx(1:Nz-1) - Bx(2:Nz)) .* (e0 ./ er(2:Nz));
    
    % Source Term at Boundary (k=1)
    Ey(1) = Source_Ey_t(n);
    
    % Record Electric Field at all points
    EE(n, :) = Ey;
    
    % Plot time-varying E-field amplitude
    plot(zVec, abs(Ey), 'b');
    title(['Time-Varying E-field Amplitude at t = ' num2str(tVec(n)) ' seconds']);
    xlabel('Position (m)');
    ylabel('Electric Field Amplitude');
    
    % Add lines to mark the glass block and refractive index change
    hold on;
    plot([1.2e-5, 1.2e-5], ylim, 'k--', 'LineWidth', 2); % Line for the glass block
    plot([1.5e-5, 1.5e-5], ylim, 'r--', 'LineWidth', 2); % Line for the change in refractive index
    hold off;
    
    drawnow; % Force the figure to update
end

% Generate pcolor plot of absolute value of E-field with refractive index jump
figure_pcolor = figure;
[X, Y] = meshgrid(zVec, tVec);
pcolor(X, Y, abs(EE));
shading interp;
title('Absolute Value of E-field with Refractive Index Jump');
xlabel('Position (m)');
ylabel('Time (s)');
zlabel('Electric Field Magnitude');
axis([min(zVec), max(zVec), 0, max(tVec)]); % Adjust time range
