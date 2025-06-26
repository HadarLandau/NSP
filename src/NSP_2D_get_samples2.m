function [f_samples] = NSP_2D_get_samples2 (N, sigma,type)
%sampling the shape in N equidistant points

  %the curve
  f1=@(t) cos(t); f2=@(t) sin(t);   %%circle
  %f1=@(t) 4*cos(t); f2=@(t) 2*sin(t);   %%ellipse
  %f1=@(t) t; f2=@(t) t.^2;  %%parabola
  %f1=@(t) cosh(t); f2=@(t) sinh(t);   %%hyperbola
  %f1=@(t) 4*cos(t)+cos(4*t); f2=@(t) 4*sin(t)-sin(4*t);  %%star

  %sampling the function over 2−JZ^2, and noising them
  f_samples=zeros(N,2);
  for i=1:N
      f_samples(i,1)=f1((-ceil(N/2)+i)*2*pi/N);   %'x'
      if type=='wavy'
        f_samples(i,2)=f2((-ceil(N/2)+i)*2*pi/N)+sigma*cos(i/20);   %'y'
      else
        f_samples(i,2)=f2((-ceil(N/2)+i)*2*pi/N)+sigma*cos(i/5);   %'y'
      end


  end

  %noising the samples
  %f_samples=f_samples+sigma*randn(size(f_samples));

  %
  %plot
  figure
  %the signal
  t_for_f=-pi:2^(-10):pi;
  plot(f1(t_for_f),f2(t_for_f))
  hold on
  %the data
  plot(f_samples(:,1),f_samples(:,2), '.','Color','k','LineStyle','none','MarkerSize',10)
  %}
