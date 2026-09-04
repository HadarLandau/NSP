

% generate the samples
f_samples_semicircle=NSP_2D_get_samples (256,0.3,'wavy');      % wavy distortion
f_samples_lessnoisycircle=NSP_2D_get_samples (256,0.1,'none'); % mild oscillation
f_samples_noisycircle=NSP_2D_get_samples (256,0.3,'none');     % more oscillation


% apply multiscale decomposition to get details
[details1] = NSP_2D_padded_decomposition3 (f_samples_semicircle, 4, 'fig5', 0);
[details2] = NSP_2D_padded_decomposition3 (f_samples_lessnoisycircle, 4, 'fig5', 0);
[details3] = NSP_2D_padded_decomposition3 (f_samples_noisycircle, 4, 'fig5', 0);


% compute Euclidean norms, means, and variances of the detail coefficients
% at each level

  % for wavy circle
  details_norms1=cell(1,4);
  mean_norms1=zeros(1,4);
  var_norms1=zeros(1,4);
  for k=1:4
    details_norms1{k}=sqrt(sum(details1{k}.^2,2)); % Euclidean norm per point
    mean_norms1(k)=mean(details_norms1{k});
    var_norms1(k)=var(details_norms1{k});
  end


  % for less noisy circle
  details_norms2=cell(1,4);
  mean_norms2=zeros(1,4);
  var_norms2=zeros(1,4);
  for k=1:4
    details_norms2{k}=sqrt(sum(details2{k}.^2,2));
    mean_norms2(k)=mean(details_norms2{k});
    var_norms2(k)=var(details_norms2{k});
  end

  % for more noisy circle
  details_norms3=cell(1,4);
  mean_norms3=zeros(1,4);
  var_norms3=zeros(1,4);
  for k=1:4
    details_norms3{k}=sqrt(sum(details3{k}.^2,2));
    format long
    mean_norms3(k)=mean(details_norms3{k});
    var_norms3(k)=var(details_norms3{k});
  end


  % plot mean detail norms on a log scale
  figure
  x=1:4;
  semilogy(x,mean_norms1)    % wavy
  hold on
  semilogy(x,mean_norms2)    % less noisy
  hold on
  semilogy(x,mean_norms3)    % more noisy
  grid on

  xlabel('$\ell$', 'interpreter', 'latex','FontSize',23)
  xticks([1 2 3 4])
  ylabel('$\nu_{\ell}$','interpreter', 'latex','FontSize',23) %%
  ylim ([10^(-7), 10^(-1)])

  legend('wavy circle', 'oscillating circle','more oscillating circle',...
         'FontSize',18,'interpreter', 'latex')

%{
  % optional: plot filled area for variance
  figure
  x=1:4;
  inBetween = [mean_norms4+var_norms4, fliplr(mean_norms4-var_norms4)];
  fill([x,fliplr(x)], inBetween, 'g');
  plot(x,mean_norms4)
  grid on
%}

%{
  % optional: error bars  
  errorbar(x,mean_norms4,var_norms4)
%}