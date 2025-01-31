clc;
clear;
% Load the data
load('Gaussian_data.mat');

% Define the fitting function
fitfunc = @(params, x) params(1) * exp(-((x - params(2)).^2) / (2 * params(3)^2)) + params(4);

% Initial guesses for the parameters
initialParams = [1, 0, 1, 0]; 

% Perform the fit using lsqcurvefit
fitParams = lsqcurvefit(fitfunc, initialParams, x, Amplitude);

% Calculate the fitted estimates
a_fit = fitParams(1);
x0_fit = fitParams(2);
sigma_fit = fitParams(3);
b_fit = fitParams(4);

% Calculate the Jacobian matrix using numerical differentiation
nParams = length(initialParams);
nData = length(x);
delta = 1e-6; % Small perturbation for numerical differentiation
J = zeros(nData, nParams);

for i = 1:nParams
    params1 = initialParams;
    params2 = initialParams;
    params1(i) = params1(i) - delta; % Perturb one parameter downward
    params2(i) = params2(i) + delta; % Perturb the same parameter upward
    
    % Calculate partial derivative using central difference formula
    J(:, i) = (fitfunc(params2, x) - fitfunc(params1, x)) / (2 * delta);
end

% Calculate the errors based on the Jacobian matrix
covariance = inv(J' * J); % Covariance matrix of parameter estimates
errors = sqrt(diag(covariance)); % Standard errors of parameter estimates

% Calculate the reduced chi-squared value (chi^2/nu)
residuals = Amplitude - fitfunc(fitParams, x);
nu = nData - nParams; % Degrees of freedom
chi_squared = sum(residuals.^2);
reduced_chi_squared = chi_squared / nu;

% Calculate error bars for a confidence level such as 4%
conf_level = 0.04; % Confidence level
alpha = 1 - conf_level; % Significance level
t_critical = tinv(1 - alpha / 2, nu); % Critical t-value
error_bars = t_critical * errors; % Error bars for parameter estimates

% Display the results
fprintf('Fitted Parameters:\n');
fprintf('a = %.4f +/- %.4f\n', a_fit, error_bars(1));
fprintf('x0 = %.4f +/- %.4f\n', x0_fit, error_bars(2));
fprintf('ro = %.4f +/- %.4f\n', sigma_fit, error_bars(3));
fprintf('b = %.4f +/- %.4f\n', b_fit, error_bars(4));
fprintf('Reduced Chi-Squared (χ^2/ν) = %.4f\n', reduced_chi_squared);

%I am unsure of my uncertainty values but they didn't seem to far fetched 
 