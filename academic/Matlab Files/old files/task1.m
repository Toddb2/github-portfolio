% Load the data from the provided file
load('Speed_of_light_data.mat');

% Assuming that your data file contains variables 'time' and 'distance'
% If the variable names are different, please adjust them accordingly

% Fit the data to a linear model: d ≈ ct + b
fitModel = fitlm(time, distance, 'linear');

% Get the coefficients of the linear fit
coefficients = fitModel.Coefficients.Estimate;

% Extract the estimated speed of light (c̃) and offset parameter (b̃)
c_estimate = coefficients(2); % Estimated speed of light (c̃)
b_estimate = coefficients(1); % Estimated offset parameter (b̃)

% Define the true value of the speed of light (c)
c_true = 299792458; % m/s (speed of light in a vacuum)

% Calculate the standard error associated with the estimated speed of light (σc)
sigma_c = fitModel.Coefficients.SE(2); % Standard error for c̃

% Calculate the absolute difference between estimated and true speed of light
abs_diff = abs(c_estimate - c_true);

% Calculate the chi-squared value (χ²)
residuals = fitModel.Residuals.Raw;
chi_squared = sum((residuals).^2);

% Calculate the degrees of freedom (ν)
nu = fitModel.DFE; % Degrees of freedom

% Calculate χ²/ν
chi_squared_over_nu = chi_squared / nu;

% Display results
fprintf('Estimated speed of light (c̃): %.2f m/s\n', c_estimate);
fprintf('True speed of light (c): %.2f m/s\n', c_true);
fprintf('Absolute difference (|c̃ - c|): %.2f m/s\n', abs_diff);
fprintf('Standard error (σc): %.2f m/s\n', sigma_c);
fprintf('Chi-squared (χ²): %.2f\n', chi_squared);
fprintf('Degrees of freedom (ν): %d\n', nu);
fprintf('χ²/ν: %.2f\n', chi_squared_over_nu);

% Assess the error bars based on χ²/ν
if chi_squared_over_nu < 1
    fprintf('Error bars may be too large.\n');
elseif chi_squared_over_nu > 1
    fprintf('Error bars may be too small.\n');
else
    fprintf('Error bars appear to be appropriate.\n');
end
