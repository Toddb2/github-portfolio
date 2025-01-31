function [] = Lab_Example()
    close all

    % Provide the file path to the microscope image
    filename = 'image12.jpg'; % Replace with the actual file path
    img = imread(filename); % Reads the image

    img = rgb2gray(img); % Converts it to grayscale
    img = im2double(img); % Converts it to a matrix

    figure
    imshow(img) % Shows you the image

    profile = mean(img, 1); % Finds the average column-wise profile

    figure
    plot(profile) % Plots the average column-wise profile

    x_val = linspace(1, length(profile), length(profile)); % x-coordinate vector in pixels for the derivative and curve fitting

    profile_d = diff(profile) ./ diff(x_val); % Difference between consecutive values in the profile

    x_val_d = (x_val(2:end) + x_val(1:(end-1))) / 2; % Difference between consecutive x values

    f = fit(x_val_d.', profile_d.', 'gauss1'); % Fits a single curve

    figure
    plot(x_val_d, profile_d) % Plots the derivative
    hold on
    plot(f, 'r--') % Plot the fit

    sigma = f.c1; % Width of the fit (standard deviation)

    FWHM = 2 * sqrt(2 * log(2)) * sigma; % Full Width at Half Maximum

    sig_3 = 3 * sigma; % 3 sigma width

    over_e_squared = (sqrt(2) * FWHM) / sqrt(log(2)); % 1/e squared width

    % Microscope parameters
    wavelength = 550e-9; % Central wavelength of light used (550 nm)
    feature_spacing = 7.81e-6; % Feature spacing (7.81 micrometers)
    pixel_size = 1.12e-6; % Pixel size (1.12 micrometers)
    numerical_aperture = 0.2425;

    % Calculate resolution in meters
    resolution = 0.61 * wavelength / numerical_aperture;

    % Define the range of wavelengths (in meters)
    lambda_min = 400e-9;
    lambda_max = 700e-9;

    % Calculate resolution for the minimum and maximum wavelengths
    resolution_min = 0.61 * lambda_min / numerical_aperture;
    resolution_max = 0.61 * lambda_max / numerical_aperture;

    % Calculate the error in resolution
    resolution_error = (resolution_max - resolution_min) / 2;

    % Calculate magnification
    magnification = feature_spacing / resolution;

    % Calculate the error in magnification using error propagation
    % Error in magnification = |dm/dx| * Error in resolution
    dm_dx = 1 / resolution;
    magnification_error = dm_dx * resolution_error;

    % Display resolution and magnification with errors
    disp(['Resolution: ' num2str(resolution) ' meters ± ' num2str(resolution_error) ' meters']);
    disp(['Magnification: ' num2str(magnification) ' ± ' num2str(magnification_error)]);

end
