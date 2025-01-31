
function E = Efield(r, Q)
    % Constants
    k_e = 8.988e9; % Coulomb's constant (N m^2/C^2)
    
    % Calculate electric field
    r = norm(r); % Magnitude of the position vector
    E = k_e * Q / r^2;
end
