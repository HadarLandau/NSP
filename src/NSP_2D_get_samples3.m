function [f_samples] = NSP_2D_get_samples3 (N, sigma)
%sampling the shape in N equidistant points, shape with jump discontinuities

  %the curve
  %f1=@(t) cos(t); f2=@(t) sin(t);   %%circle
  %f1=@(t) 4*cos(t); f2=@(t) 2*sin(t);   %%ellipse
  %f1=@(t) t; f2=@(t) t.^2;  %%parabola
  %f1=@(t) cosh(t); f2=@(t) sinh(t);   %%hyperbola
  %f1=@(t) 4*cos(t)+cos(4*t); f2=@(t) 4*sin(t)-sin(4*t);  %%star
  f1=@(t) cos(t); f2=@(t) sin(t); f3=@(t) 1+sin(t);   %%circle with jump discontinuities

  %sampling the function over 2−JZ^2
  %jump discontinuities
%{
  f_samples=zeros(N,2);
  for i=1:N
      f_samples(i,1)=f1((-ceil(N/2)+i)*2*pi/N);   %'x'
      if floor(N/2)<i && i<floor(3*N/4)
        f_samples(i,2)=f3((-ceil(N/2)+i)*2*pi/N);   %'y'
      else
        f_samples(i,2)=f2((-ceil(N/2)+i)*2*pi/N);   %'y'
      end
  end

  %noising the samples
  f_samples=f_samples+sigma*randn(size(f_samples));
%}

  %noise in pert of the circle
%
  f_samples=zeros(N,2);
  t=sin(0:pi/(N/4):pi);
  for i=1:N
      f_samples(i,1)=f1((-ceil(N/2)+i)*2*pi/N);   %'x'
      if floor(N/4)<i && i<floor(1*N/2)
        f_samples(i,2)=f2((-ceil(N/2)+i)*2*pi/N)+t(i-N/4)*sigma*cos(i/3);   %'y'
      else
        f_samples(i,2)=f2((-ceil(N/2)+i)*2*pi/N);   %'y'
      end
  end
%


  %
  %plot
  figure
  %the signal
  t_for_f1=-pi:2^(-10):0;
  plot(f1(t_for_f1),f2(t_for_f1))
  hold on
  t_for_f1=0:2^(-10):pi/2;
  plot(f1(t_for_f1),f3(t_for_f1))
  hold on
  t_for_f2=pi/2:2^(-10):pi;
  plot(f1(t_for_f2),f2(t_for_f2))
  hold on
  %the data
  plot(f_samples(:,1),f_samples(:,2), '.','Color','k','LineStyle','none','MarkerSize',10)
  %}
