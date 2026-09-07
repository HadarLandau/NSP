function [pred_epoch1,pred_epoch3,pred_epoch5,pred_epoch7] = NN_circles_32pts ()

%% Parameters
num_centers=10000;                 % Number of training examples
num_points=32;                     % Number of points on the circle
hidden_layer_sizes=[32,32,16];   % Hidden layers
epoch_num=7;

%% Generate training data

% Generate angles for unit circle samples
angles=linspace(0,2*pi,num_points+1);
angles(end)=[];  % Remove the last point (2pi == 0)

% Random centers in [0,10] x [0,10]
centers=rand(2,num_centers)*10;

% Preallocate targets
targets=zeros(2*num_points,num_centers);

for i=1:num_centers

    x=centers(1,i);
    y=centers(2,i);

    % Generate unit circle points
    circle=[cos(angles);sin(angles)];

    % Shift circle to the current center
    shifted=circle+[x;y];

    % Store as:
    % [x1; y1; x2; y2; ...; x32; y32]
    targets(:,i)=reshape(shifted,[],1);

end

%% Create neural network

net=feedforwardnet(hidden_layer_sizes);

% Train one epoch at a time
net.trainParam.epochs=1;

net.trainParam.goal=1e-6;
net.performParam.regularization=0.001;
net.trainParam.mu_max=1e20;
net.trainParam.showWindow=true;

%% Test center

test_center=[4;6];

%% Train for 7 epochs

for epoch=1:epoch_num

    fprintf('\nTraining epoch %d of %d...\n',epoch,epoch_num);

    % Train the network for one epoch
    net=train(net,centers,targets);

    % Save prediction only at epochs 1, 3, 5 and 7

    if epoch==1

        predicted=net(test_center);

        pred_epoch1=reshape(predicted,[],2);

    elseif epoch==3

        predicted=net(test_center);

        pred_epoch3=reshape(predicted,[],2);

    elseif epoch==5

        predicted=net(test_center);

        pred_epoch5=reshape(predicted,[],2);

    elseif epoch==7

        predicted=net(test_center);

        pred_epoch7=reshape(predicted,[],2);

    end

end

%% True circle for comparison

true_circle=[cos(angles);sin(angles)]+test_center;

% Plot the closed circle
figure;
plot(x_closed, y_closed, 'bo-', 'LineWidth', 1);
hold on;
plot([true_circle(1,:), true_circle(1,1)], [true_circle(2,:),true_circle(2,1)], 'k--','LineWidth', 1);
plot(test_center(1), test_center(2), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
legend('Predicted Circle', 'True Circle', 'Center');
axis equal;
%title('Unit Circle Prediction by Neural Network');
xlabel('X'); ylabel('Y');
grid on;

%% Plot the four predictions

figure;

% Epoch 1

x1_closed = [pred_epoch1(:,1), pred_epoch1(1,1)];
y1_closed = [pred_epoch1(:,2), pred_epoch1(2,1)];

subplot(2,2,1);

plot(x1_closed(:,1),y1_closed(:,2),'bo-','LineWidth',1);
hold on;

plot([true_circle(1,:),true_circle(1,1)],[true_circle(2,:),true_circle(2,1)], ...
     'k--','LineWidth', 1);

plot(test_center(1),test_center(2),'rx','MarkerSize',10,'LineWidth',2);

axis equal;
xlabel('X'); ylabel('Y');
title('Epoch 1');
grid on;

% Epoch 3

x3_closed = [pred_epoch3(:,1), pred_epoch3(1,1)];
y3_closed = [pred_epoch3(:,2), pred_epoch3(2,1)];

subplot(2,2,2);

plot(x3_closed(:,1),y3_closed(:,2),'bo-','LineWidth',1);
hold on;

plot([true_circle(1,:),true_circle(1,1)],[true_circle(2,:),true_circle(2,1)], ...
     'k--','LineWidth', 1);

plot(test_center(1),test_center(2),'rx','MarkerSize',10,'LineWidth',2);

axis equal;
xlabel('X'); ylabel('Y');
title('Epoch 3');
grid on;

% Epoch 5

x5_closed = [pred_epoch5(:,1), pred_epoch5(1,1)];
y5_closed = [pred_epoch5(:,2), pred_epoch5(2,1)];

subplot(2,2,3);

plot(x5_closed(:,1),y5_closed(:,2),'bo-','LineWidth',1);
hold on;

plot([true_circle(1,:),true_circle(1,1)],[true_circle(2,:),true_circle(2,1)], ...
     'k--','LineWidth', 1);

plot(test_center(1),test_center(2),'rx','MarkerSize',10,'LineWidth',2);

axis equal;
xlabel('X'); ylabel('Y');
title('Epoch 5');
grid on;

% Epoch 7

x7_closed = [pred_epoch7(:,1), pred_epoch7(1,1)];
y7_closed = [pred_epoch7(:,2), pred_epoch7(2,1)];

subplot(2,2,4);

plot(x7_closed(:,1),y7_closed(:,2),'bo-','LineWidth',1);
hold on;

plot([true_circle(1,:),true_circle(1,1)],[true_circle(2,:),true_circle(2,1)], ...
     'k--','LineWidth', 1);

plot(test_center(1),test_center(2),'rx','MarkerSize',10,'LineWidth',2);

axis equal;
xlabel('X'); ylabel('Y');
title('Epoch 7');
grid on;