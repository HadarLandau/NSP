% plotting the difference between the samples and a perfect circle

% generate the samples
f_samples_semicircle=NSP_2D_get_samples2 (128,0.7,'wavy');      % wavy distortion
f_samples_noisycircle=NSP_2D_get_samples2 (128,0.3,'none');     % more oscillation
shifted_ai_samples=pred_xy-[4;6];                               % NN circle
shifted_ai_samples=shifted_ai_samples';

% measure the difference from a perfect circle
diff_wavy=sum(f_samples_semicircle.^2,2)-1;
diff_noisy=sum(f_samples_noisycircle.^2,2)-1;
diff_ai=sum(shifted_ai_samples.^2,2)-1;

%{
% plotting the differences along with the samples in the same figure
figure

%% wavy circle
subplot(3,2,1)
% plot a cicrle
f1=@(t) cos(t); f2=@(t) sin(t);   %circle
t_for_f=-pi:2^(-10):pi;
plot(f1(t_for_f),f2(t_for_f),'LineWidth',2)
hold on
% plot the sampled data points
plot(f_samples_semicircle(:,1),f_samples_semicircle(:,2), '.','MarkerSize',10,'Color','r','LineStyle','none')
axis equal

subplot(3,2,2)
plot(diff_wavy)

%% noisy circle
subplot(3,2,3)
% plot a cicrle
f1=@(t) cos(t); f2=@(t) sin(t);   %circle
t_for_f=-pi:2^(-10):pi;
plot(f1(t_for_f),f2(t_for_f),'LineWidth',2)
hold on
% plot the sampled data points
plot(f_samples_noisycircle(:,1),f_samples_noisycircle(:,2), '.','MarkerSize',10,'Color','r','LineStyle','none')
axis equal

subplot(3,2,4)
plot(diff_noisy)

%% NN cicrle
subplot(3,2,5)
% plot a cicrle
f1=@(t) cos(t); f2=@(t) sin(t);   %circle
t_for_f=-pi:2^(-10):pi;
plot(f1(t_for_f),f2(t_for_f),'LineWidth',2)
hold on
% plot the sampled data points
plot(shifted_ai_samples(:,1),shifted_ai_samples(:,2), '.','MarkerSize',10,'Color','r','LineStyle','none')
axis equal

subplot(3,2,6)
plot(diff_ai)
%}

% plotting the differences along with the samples in different figures

%% wavy circle
figure
% plot a cicrle
f1=@(t) cos(t); f2=@(t) sin(t);   %circle
t_for_f=-pi:2^(-10):pi;
plot(f1(t_for_f),f2(t_for_f),'LineWidth',2)
hold on
% plot the sampled data points
plot(f_samples_semicircle(:,1),f_samples_semicircle(:,2), '.','MarkerSize',10,'Color','r','LineStyle','none')
axis equal
axis off

figure
plot(diff_wavy)
xlim([0, 128])
set(gca,'fontsize',24);

%% noisy circle
figure
% plot a cicrle
f1=@(t) cos(t); f2=@(t) sin(t);   %circle
t_for_f=-pi:2^(-10):pi;
plot(f1(t_for_f),f2(t_for_f),'LineWidth',2)
hold on
% plot the sampled data points
plot(f_samples_noisycircle(:,1),f_samples_noisycircle(:,2), '.','MarkerSize',10,'Color','r','LineStyle','none')
axis equal
axis off

figure
plot(diff_noisy)
xlim([0, 128])
set(gca,'fontsize',24);

%% NN cicrle
figure
% plot a cicrle
f1=@(t) cos(t); f2=@(t) sin(t);   %circle
t_for_f=-pi:2^(-10):pi;
plot(f1(t_for_f),f2(t_for_f),'LineWidth',2)
hold on
% plot the sampled data points
plot(shifted_ai_samples(:,1),shifted_ai_samples(:,2), '.','MarkerSize',10,'Color','r','LineStyle','none')
axis equal
axis off

figure
plot(diff_ai)
xlim([0, 128])
ylim([-0.0015, 0.0013])
set(gca,'fontsize',24);
