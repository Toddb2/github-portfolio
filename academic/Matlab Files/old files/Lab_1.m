function [] = Lab_1()
close all

filename = "image12.jpg"; %Type your file path in here
img = imread(filename); %Reads the image
img = rgb2gray(img); %Converts it to gray scale
img = im2double(img); %Converts it to a matrix

figure
imshow(img) %Shows you the image



profile = mean(img,1); %Finds the average column-wise profile

figure
plot(profile) %Plots the average column-wise profile



x_val = linspace(1,length(profile),length(profile)); %an x-coordinate vector in pixels for the derivative and curve fitting

profile_d = diff(profile)./diff(x_val); %difference between consecutive values in the profile

x_val_d = (x_val(2:end)+x_val(1:(end-1)))/2; %difference between consecutive x values

f = fit(x_val_d.',profile_d.','gauss1')% fits a single curve

figure
plot(x_val_d,profile_d) %plots the derivative
hold on
plot(f,'r--') %plot the fit



sigma = f.c1; %width of the fit

FWHM = 2*sqrt(2*log(2))*sigma%full width at half max

sig_3 = 3*sigma% 3 sigma width

over_e_squared = (sqrt(2)*FWHM)/sqrt(log(2))% 1/e squared width

resolution = FWHM * 22.1e-6 

magnification = 22.1e-6 / resolution

end

