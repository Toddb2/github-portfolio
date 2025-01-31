function G = Gfield(r, M)
    % Constants
    G_grav = 6.67430e-11; % Gravitational constant (m^3/kg/s^2)
    
    % Calculate gravitational field
    r = norm(r); % Magnitude of the position vector
    G = G_grav * M / r^2;
end