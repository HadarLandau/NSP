% figure 8b

% generate the samples
f_samples_circle=NSP_2D_get_samples2 (256,0,'none');            % perfect circle
f_samples_semicircle=NSP_2D_get_samples2 (256,0.3,'wavy');      % wavy distortion
f_samples_lessnoisycircle=NSP_2D_get_samples2 (256,0.1,'none'); % mild oscillation
f_samples_noisycircle=NSP_2D_get_samples2 (256,0.3,'none');     % more oscillation


% apply multiscale decomposition to get details
[details1] = NSP_2D_padded_decomposition3 (f_samples_circle, 4);
[details2] = NSP_2D_padded_decomposition3 (f_samples_semicircle, 4);
[details3] = NSP_2D_padded_decomposition3 (f_samples_lessnoisycircle, 4);
[details4] = NSP_2D_padded_decomposition3 (f_samples_noisycircle, 4);


% compute Euclidean norms, means, and variances of the detail coefficients
% at each level

  % for clean circle
  details_norms1=cell(1,4);
  mean_norms1=zeros(1,4);
  var_norms1=zeros(1,4);
  for k=1:4
    details_norms1{k}=sum(abs(details1{k}))
    mean_norms1(k)=sqrt(sum(details_norms1{k}.^2,2))
    var_norms1(k)=var(details_norms1{k});
  end

  % for wavy circle
  details_norms2=cell(1,4);
  mean_norms2=zeros(1,4);
  var_norms2=zeros(1,4);
  for k=1:4
    details_norms2{k}=sum(abs(details2{k})); %
    mean_norms2(k)=sqrt(sum(details_norms2{k}.^2,2));
    var_norms2(k)=var(details_norms2{k});
  end

  % for less noisy circle
  details_norms3=cell(1,4);
  mean_norms3=zeros(1,4);
  var_norms3=zeros(1,4);
  for k=1:4
    details_norms3{k}=sum(abs(details3{k})); %
    mean_norms3(k)=sqrt(sum(details_norms3{k}.^2,2));
    var_norms3(k)=var(details_norms3{k});
  end

  % for more noisy circle
  details_norms4=cell(1,4);
  mean_norms4=zeros(1,4);
  var_norms4=zeros(1,4);
  for k=1:4
    details_norms4{k}=sum(abs(details4{k})); %
    mean_norms4(k)=sqrt(sum(details_norms4{k}.^2,2));
    var_norms4(k)=var(details_norms4{k});
  end

  % plot mean detail norms on a log scale
  figure
  x=1:4;
  semilogy(x,mean_norms2)    % wavy
  hold on
  semilogy(x,mean_norms3)    % less noisy
  hold on
  semilogy(x,mean_norms4)    % more noisy
  grid on

  xlabel('$\ell$', 'interpreter', 'latex','FontSize',20)
  xticks([1 2 3 4])
  ylabel('$\|d^{(\ell)}\|_1$','interpreter', 'latex','FontSize',20) %%
  ylim ([10^(-5), 10^(0)])

  legend('wavy circle', 'oscillating circle','more oscillating circle',...
         'FontSize',14,'interpreter', 'latex')