% Electric field calculation
distance_to_charge = 1e-9; % 1 nanometer in meters
charge = 3e-3; % 3 millicoulombs in coulombs

electric_field = Efield(distance_to_charge, charge);

% Gravitational field calculation
distance_to_sun = 695510e3; % 695,510 km in meters
mass_of_sun = 1.989e30; % Mass of the sun in kilograms
mass_of_person = 95;

gravitational_field = Gfield(distance_to_sun, mass_of_sun);

% Calculate weight on the surface of the sun
weight_on_sun = gravitational_field * mass_of_person;

% Display results
disp(['Electric Field at 1 nm from the charge: ', num2str(electric_field), ' N/C']);
disp(['Weight on the surface of the sun: ', num2str(weight_on_sun), ' N']);

