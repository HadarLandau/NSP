% figure 8

%getting the samples
f_samples_circle=NSP_2D_get_samples2 (256,0,0);
f_samples_semicircle=NSP_2D_get_samples2 (256,0.3,'wavy');
f_samples_lessnoisycircle=NSP_2D_get_samples2 (256,0.1,0);
f_samples_noisycircle=NSP_2D_get_samples2 (256,0.3,0);


%finding the details of each samples
[c_0, details1,refined_c_l, padded_c_0, padded_details] = NSP_2D_padded_decomposition3 (f_samples_circle, 4);
[c_0, details2,refined_c_l, padded_c_0, padded_details] = NSP_2D_padded_decomposition3 (f_samples_semicircle, 4);
[c_0, details3,refined_c_l, padded_c_0, padded_details] = NSP_2D_padded_decomposition3 (f_samples_lessnoisycircle, 4);
[c_0, details4,refined_c_l, padded_c_0, padded_details] = NSP_2D_padded_decomposition3 (f_samples_noisycircle, 4);


%Measuring the norms
  details_norms1=cell(1,4);
  mean_norms1=zeros(1,4);
  var_norms1=zeros(1,4);
  for k=1:4
    details_norms1{k}=sqrt(sum(details1{k}.^2,2)); %%%%%
    mean_norms1(k)=mean(details_norms1{k});
    var_norms1(k)=var(details_norms1{k});
  end

  details_norms2=cell(1,4);
  mean_norms2=zeros(1,4);
  var_norms2=zeros(1,4);
  for k=1:4
    details_norms2{k}=sqrt(sum(details2{k}.^2,2)); %%%%%
    mean_norms2(k)=mean(details_norms2{k});
    var_norms2(k)=var(details_norms2{k});
  end

  details_norms3=cell(1,4);
  mean_norms3=zeros(1,4);
  var_norms3=zeros(1,4);
  for k=1:4
    details_norms3{k}=sqrt(sum(details3{k}.^2,2)); %%%%%
    mean_norms3(k)=mean(details_norms3{k});
    var_norms3(k)=var(details_norms3{k});
  end

  details_norms4=cell(1,4);
  mean_norms4=zeros(1,4);
  var_norms4=zeros(1,4);
  for k=1:4
    details_norms4{k}=sqrt(sum(details4{k}.^2,2)); %%%%%
    mean_norms4(k)=mean(details_norms4{k});
    var_norms4(k)=var(details_norms4{k});
  end
%}

%
  figure
  x=1:4;
  semilogy(x,mean_norms2)
  hold on
  semilogy(x,mean_norms3)
  hold on
  semilogy(x,mean_norms4)
  grid on
  xlabel('$\ell$', 'interpreter', 'latex','FontSize',20)
  xticks([1 2 3 4])
  ylabel('mean($d^{(\ell)}$)','interpreter', 'latex','FontSize',20)
  ylim ([10^(-7), 10^(-1)])
  legend('wavy circle', 'oscillating circle','more oscillating circle','FontSize',14,'interpreter', 'latex')
  %set('gca','interpreter','latex')
%

%figure with filled var graph
%{
  figure
  x=1:4;
  inBetween = [mean_norms4+var_norms4, fliplr(mean_norms4-var_norms4)];
  fill([x,fliplr(x)], inBetween, 'g');
  plot(x,mean_norms4)
  grid on
%}
%{
  errorbar(x,mean_norms4,var_norms4)
%}
