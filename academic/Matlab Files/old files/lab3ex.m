% Load the image
image = imread('image11.jpg'); % Replace 'your_image.jpg' with the image file name

% Flip the image 90 degrees
image = imrotate(image, 90);

% Display the flipped image
imshow(image);
title('Flipped Image');
xlabel('Select a Region of Interest (ROI) for Analysis');
axis on;

% Allow the user to select a region for analysis
roi = imrect; % This allows the user to draw a rectangle on the image

% Get the position of the selected ROI
roiPosition = wait(roi);

% Extract the selected region for analysis
x1 = round(roiPosition(1));
y1 = round(roiPosition(2));
width = round(roiPosition(3));
height = round(roiPosition(4));
roiImage = image(y1:y1+height-1, x1:x1+width-1, :);

% Calculate the resolution using Gaussian distributions and peak detection
grayROI = rgb2gray(roiImage);
[~, threshold] = edge(grayROI, 'sobel');
fudgeFactor = 0.5;
BW = edge(grayROI, 'sobel', threshold * fudgeFactor);

% Create a Gaussian filter
sigma = 2;
gaussianFilter = fspecial('gaussian', [5 5], sigma);

% Apply Gaussian filter to the ROI
smoothedROI = imfilter(double(BW), gaussianFilter, 'replicate');

% Find peaks in the smoothed ROI
[pks, locs] = findpeaks(smoothedROI, 'MinPeakHeight', max(smoothedROI(:)) * 0.5);

% Calculate the resolution
resolution = 1 / mean(diff(locs));

% Display the analysis results
figure;
subplot(2, 1, 1);
imshow(roiImage);
title('Selected ROI');
axis on;

subplot(2, 1, 2);
plot(smoothedROI);
hold on;
plot(locs, pks, 'ro');
title('Edge Detection and Peak Detection');
xlabel('Pixel Position');
ylabel('Intensity');
legend('Smoothed ROI', 'Detected Peaks');
grid on;

fprintf('Resolution of the image: %.2f pixels per unit\n', resolution);

findpeaks()
