function [f_samples] = NSP_2D_get_samples (istart, N, J, noise)
  %the curve
  f1=@(t) cos(t); f2=@(t) sin(t);   %%circle
  %f1=@(t) 4*cos(t)+cos(4*t); f2=@(t) 4*sin(t)-sin(4*t);  %%star

  %sampling the function over 2−JZ^2
  f_samples=zeros(N,2);
  for i=1:N
      f_samples(i,1)=f1(istart+(i-1)*2^(-J));   %'x'
      f_samples(i,2)=f2(istart+(i-1)*2^(-J));   %'y'
  end

  %noising the samples
  f_samples=f_samples+noise*randn(size(f_samples));

  %
  %plot
  figure
  %the signal
  t_for_f=istart:2^(-10):istart+(N-1)*2^(-J);
  plot(f1(t_for_f),f2(t_for_f))
  hold on
  %the data
  plot(f_samples(:,1),f_samples(:,2), '.','Color','k','LineStyle','none')
  %}
