clc;
clear all;

% Define Constants
wavelength = 550e-9;  % Wavelength of green light in meters
numerical_aperture = 0.2425;  % Replace with your microscope's NA
known_object_size = 22.1e-6;  % Replace with the known size of a reference object in meters (e.g., 10 micrometers)

% Calculate Theoretical Resolution
theoretical_resolution = wavelength / (2 * numerical_aperture);

% Load Microscope Image
image = imread('image11.jpg');  % Replace with your image file path

% Convert the Image to Grayscale
gray_image = rgb2gray(image);

% Display the Grayscale Image
imshow(gray_image);
title('Grayscale Microscope Image');

% Prompt User to Select a Region of Interest (ROI)
roi = imrect;
position = wait(roi);  % Wait for the user to draw ROI and press enter

% Crop the Selected ROI from the Grayscale Image
cropped_image = imcrop(gray_image, position);

% Calculate the width of the cropped region in pixels
[height, width] = size(cropped_image);

% Display the Cropped ROI
figure;
imshow(cropped_image);
title('Cropped ROI');

% Perform Image Analysis on the Cropped ROI (e.g., measuring objects)

% Measure the Smallest Distinguishable Features (Resolution Test)
% For example, you can use edge detection and measure distances between edges.

% Measure the Size of Objects in the Cropped Image (Magnification Test)
% For example, use known reference objects to calculate the magnification.

% Calculate Theoretical Magnification based on a Known Object
theoretical_magnification = ((height/2) * 1.12e-6) / known_object_size;

% Display Results
fprintf('Theoretical Resolution: %.2f micrometers\n', theoretical_resolution * 1e6);
fprintf('Experimental Magnification: %.2fX\n', theoretical_magnification);
fprintf('Width of the Cropped Region (pixels): %d\n', height);

% Close the previous figure
close(gcf);

% Prompt User to Select a Region of Interest for Gaussian Plot
figure; % Open a new figure
imshow(gray_image);
title('Select a Region for Gaussian Plot (Original Image)');
roi = imrect;
position = wait(roi);  % Wait for the user to draw ROI and press enter

% Crop the Selected ROI for Gaussian Plot from the original image
gaussian_roi = imcrop(gray_image, position);

% Create Gaussian Profile for Bright Pixels
bright_pixels = gaussian_roi > mean(gaussian_roi(:)); % You can adjust the threshold if needed
bright_profile = sum(bright_pixels, 2); % Sum along the rows

% Create Gaussian Profile for Dark Pixels (complement of bright)
dark_pixels = ~bright_pixels;
dark_profile = sum(dark_pixels, 2); % Sum along the rows

% Fit Gaussian Curves to Bright and Dark Profiles
bright_fit = fit((1:length(bright_profile))', bright_profile, 'gauss1');
dark_fit = fit((1:length(dark_profile))', dark_profile, 'gauss1');

% Calculate Full Width at Half Maximum (FWHM) for Bright and Dark Profiles
bright_fwhm = 2 * sqrt(2 * log(2)) * bright_fit.c1;
dark_fwhm = 2 * sqrt(2 * log(2)) * dark_fit.c1;

% Calculate the Average FWHM as an estimate of resolution
resolution_estimate = (bright_fwhm + dark_fwhm) /2;

% Display the Gaussian Fits
figure;
plot(bright_fit, (1:length(bright_profile))', bright_profile);
title('Gaussian Fits for Bright and Dark Pixels');
xlabel('Pixel Position');
ylabel('Intensity');
legend('Bright Profile', 'Dark Profile');


resolution = resolution_estimate * theoretical_resolution *1e-5;
% Display Resolution Estimate
fprintf('Resolution Estimate: %.2f pixels\n', resolution_estimate);
fprintf('Resolution Estimate (meters): %.2f meters\n');
disp(resolution)