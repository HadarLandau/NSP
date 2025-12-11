% train_circle_predictor.m
% Train a neural network to predict unit circle points around a center

clear; clc; close all;

%% Parameters
num_centers = 3500;       % Number of training examples
num_points = 128;          % Number of equidistant points on the circle
hidden_layer_sizes = [32, 32, 16];  % Hidden layers

%% Generate training data

% Generate angles for unit circle samples
angles = linspace(0, 2*pi, num_points + 1);
angles(end) = [];  % Remove the last point (2pi == 0)

% Random centers in [0, 10] × [0, 10]
centers = rand(2, num_centers) * 10;  % size: 2 x num_centers

% Preallocate targets: (2*num_points) x num_centers
targets = zeros(2 * num_points, num_centers);

for i = 1:num_centers
    x = centers(1, i);
    y = centers(2, i);

    % Generate unit circle points
    circle = [cos(angles); sin(angles)];  % size: 2 x num_points

    % Shift by center
    shifted = circle + [x; y];  % size: 2 x num_points

    % Store as column vector: [x1; y1; x2; y2; ...]
    targets(:, i) = reshape(shifted, [], 1);
end

%% Create and train neural network

% Define feedforward network
net = feedforwardnet(hidden_layer_sizes);

% Training settings
net.trainParam.epochs = 500;
net.trainParam.goal = 1e-4;
net.performParam.regularization = 0.001;
net.trainParam.showWindow = true;  % GUI training window

% Train
net = train(net, centers, targets);

%% Test the trained network

% Choose a new test center
test_center = [4; 6];

% Predict circle points
predicted = net(test_center);  % 2*num_points x 1
pred_xy = reshape(predicted, 2, []);  % size: 2 x num_points

% True (expected) circle for comparison
true_circle = [cos(angles); sin(angles)] + test_center;

%% Plot the result
fprintf('The deviation of the predicted points from a perfect circle: \n')
dev = sqrt(sum((pred_xy-test_center).^2,1))-1;
dev
fprintf('The average deviation: %.5f \n', mean(dev) )

x_closed = [pred_xy(1,:), pred_xy(1,1)];
y_closed = [pred_xy(2,:), pred_xy(2,1)];

% Plot the closed circle
figure;
plot(x_closed, y_closed, 'bo-', 'LineWidth', 1);
hold on;
plot([true_circle(1,:), true_circle(1,1)], [true_circle(2,:),true_circle(2,1)], 'k--','LineWidth', 1);
plot(test_center(1), test_center(2), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
legend('Predicted Circle', 'True Circle', 'Center');
axis equal;
title('Unit Circle Prediction by Neural Network');
xlabel('X'); ylabel('Y');
grid on;
