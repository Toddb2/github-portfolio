clear;
close all;
clc;

%% Parameter Init

% Starting Point
X = 1; Y = 1; Z = 1;

% Model Parameters
Sigma = 10;
Rho = 28;
Beta = 8/3;

% Curve Animator Obj
Curve = animatedline('Color', [0, 1, 1], 'LineStyle', '-', 'Marker'...
    , 'none', 'MarkerSize', 2);

% Plot Properties
set(gcf, 'Color', 'k'); axis equal; axis off

% Time Frame
dt = 0.01;

% Output video file name
outputFileName = 'lorenz_attractor.avi';

% Create video writer object
videoWriterObj = VideoWriter(outputFileName, 'Uncompressed AVI');
open(videoWriterObj);

% Time parameters for animation
numFrames = 2000; % Adjust as needed

for frame = 1:numFrames

    dx = (Sigma * (Y-X)) * dt;
    dy = (X * (Rho-Z) - Y) * dt;
    dz = (X*Y - Beta*Z) * dt;
    X = X + dx;
    Y = Y + dy;
    Z = Z + dz;

    Curve.addpoints(X, Y, Z);
    drawnow limitrate
    
    % Write the frame to the video file
    writeVideo(videoWriterObj, getframe(gcf));
end

% Close the video writer object
close(videoWriterObj);

% Optionally, you can convert the video to a GIF using external tools
% For example, you can use a tool like FFmpeg or an online converter.
