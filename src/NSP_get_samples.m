function [f_samples] = NSP_get_samples (istart, N, J, noise)
  %the function
  %f=@(x) sin(x/10)+(x/50).^2;
  %another examples:
  %f=@(x) cos(2*x/5)+(x/40-1).^3;
  %f=@(x) 1*x.^0;                         %constant function
  %f=@(x) sin((x-1));%*pi/(N*2^-(J+1)));     %sin
  %f=@(x) sin(4*(x-1)*pi/(N*2^-(J+1)));     %sin
  %f=@(x) abs(x-1-(N-1)/2^(J+1));         %abs
  %f=@(x) heaviside(x-1-(N-1)/2^(J+1));    %step function
  %f=@(x) heaviside(x-1-(N-1)/2^(J+1))+heaviside(x-(N-1)/2^(J+1))+heaviside(x-2-(N-1)/2^(J+1));
  %f=@(x) exp(0.25*x);
  %f=@(x) x.^5;
  f=@(x) sin((7*x))%+x.*cos(7*x);
  %f=@(x) exp(-7*x)%+exp(-7*x)%+x.*cos(7*x);


  %sampling the function over 2−JZ
  f_samples=zeros(N,1);
  for i=1:N
      f_samples(i)=f(istart+(i-1)*2^(-J));
  end
  max_sample=f_samples(end);

  %noising the samples
  f_samples=f_samples+noise*randn(size(f_samples));

  %
  %plot
  figure
  %the signal
  x_data_for_f=istart:2^(-10):istart+(N-1)*2^(-J);
  plot(x_data_for_f,f(x_data_for_f))
  hold on
  %the data
  x_data=istart:2^(-J):istart+(N-1)*2^(-J);
  plot(x_data, f_samples, '.','Color','k','LineStyle','none')
  %}
