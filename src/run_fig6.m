%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RUN_FIG6                                                             %
%                                                                      %
% This script analyzes the detail coefficients obtained from the       %
% multiscale decomposition of three distorted versions of the sampled  %
% unit circle, as shown in Figure 6.                                   %
%                                                                      %
% The examples differ in the type and amplitude of the oscillatory     %
% distortion. The detail coefficients are quantified using their L1    %
% norms and the mean detail norm nu_l at each decomposition level.     %
%                                                                      %
% Steps:                                                               %
%   1. Three sets of N = 256 equidistant sample points are generated   %
%      from the unit circle with different types and amplitudes of     %
%      oscillatory distortion.                                         %
%   2. Four levels of multiscale decomposition are performed on each   %
%      data set.                                                       %
%   3. The Euclidean norm of each detail coefficient is computed at    %
%      every decomposition level, and its mean value nu_l is recorded. %
%   4. The L1 norm of the detail coefficients is computed at each      %
%      decomposition level.                                            %
%   5. The L1 norms and the mean detail norms nu_l are plotted on      %
%      logarithmic scales for comparison.                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% generate the sampled data

% wavy distortion with amplitude sigma = 0.3
f_samples_semicircle=NSP_2D_get_samples (256,0.3,'wavy');      

% mild periodic oscillation with amplitude sigma = 0.1
f_samples_lessnoisycircle=NSP_2D_get_samples (256,0.1,'base'); 

% stronger periodic oscillation with amplitude sigma = 0.3
f_samples_noisycircle=NSP_2D_get_samples (256,0.3,'base');    

%% perform multiscale decomposition
% Compute four levels of detail coefficients for each data set
[details1] = NSP_2D_padded_decomposition3 (f_samples_semicircle, 4, 'fig5', 0);
[details2] = NSP_2D_padded_decomposition3 (f_samples_lessnoisycircle, 4, 'fig5', 0);
[details3] = NSP_2D_padded_decomposition3 (f_samples_noisycircle, 4, 'fig5', 0);

%% Compute norms of the detail coefficients

% wavy circle

details_norms1=cell(1,4);
nu1=zeros(1,4);
L1_norm_1=cell(1,4);
L1_norms_val_1=zeros(1,4);

for k=1:4
  % Euclidean norm of each 2D detail coefficient
  details_norms1{k}=sqrt(sum(details1{k}.^2,2)); 
  % mean Euclidean norm at the current level
  nu1(k)=mean(details_norms1{k});
  % compute the L1 norm of the detail coefficients for each coordinate
  L1_norm_1{k}=sum(abs(details1{k}));    
  % compute a scalar L1-based quantity using the Euclidean norm
  L1_norms_val_1(k)=sqrt(sum(L1_norm_1{k}.^2,2));
end


% less noisy circle

details_norms2=cell(1,4);
nu2=zeros(1,4);
L1_norm_2=cell(1,4);
L1_norms_val_2=zeros(1,4);

for k=1:4
  % Euclidean norm of each 2D detail coefficient
  details_norms2{k}=sqrt(sum(details2{k}.^2,2));
  % mean Euclidean norm at the current level
  nu2(k)=mean(details_norms2{k});
  % compute the L1 norm of the detail coefficients for each coordinate
  L1_norm_2{k}=sum(abs(details2{k}));   
  % compute a scalar L1-based quantity using the Euclidean norm
  L1_norms_val_2(k)=sqrt(sum(L1_norm_2{k}.^2,2));
end

% more noisy circle

details_norms3=cell(1,4);
nu3=zeros(1,4);
L1_norm_3=cell(1,4);
L1_norms_val_3=zeros(1,4);

for k=1:4
  % Euclidean norm of each 2D detail coefficient
  details_norms3{k}=sqrt(sum(details3{k}.^2,2));
  % mean Euclidean norm at the current level
  nu3(k)=mean(details_norms3{k});
  % compute the L1 norm of the detail coefficients for each coordinate
  L1_norm_3{k}=sum(abs(details3{k}));   
  % compute a scalar L1-based quantity using the Euclidean norm
  L1_norms_val_3(k)=sqrt(sum(L1_norm_3{k}.^2,2));
end

%% plot the L1 norms of the detail coefficients on a logarithmic scale
figure
x=1:4;
semilogy(x,L1_norms_val_1)    % wavy circle
hold on
semilogy(x,L1_norms_val_2)    % mildly oscillatory circle
hold on
semilogy(x,L1_norms_val_3)    % more strongly oscillatory circle
grid on

xlabel('$\ell$', 'interpreter', 'latex','FontSize',20)
xticks([1 2 3 4])
ylabel('$\|d^{(\ell)}\|_1$','interpreter', 'latex','FontSize',20) 
ylim ([10^(-5), 10^(0)])

legend('wavy circle', 'oscillating circle','more oscillating circle',...
     'FontSize',14,'interpreter', 'latex')


%% plot the mean detail norms nu_l on a logarithmic scale
figure
x=1:4;
semilogy(x,nu1)    % wavy circle
hold on
semilogy(x,nu2)    % mildly oscillatory circle
hold on
semilogy(x,nu3)    % more strongly oscillatory circle
grid on

xlabel('$\ell$', 'interpreter', 'latex','FontSize',23)
xticks([1 2 3 4])
ylabel('$\nu_{\ell}$','interpreter', 'latex','FontSize',23) 
ylim ([10^(-7), 10^(-1)])

legend('wavy circle', 'oscillating circle','more oscillating circle',...
     'FontSize',18,'interpreter', 'latex')