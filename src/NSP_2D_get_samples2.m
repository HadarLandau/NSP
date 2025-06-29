% figures 3-9

function [f_samples] = NSP_2D_get_samples2 (N, sigma, mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function samples a 2D parametric curve at N equidistant points and     %
% adds oscillatory noise to the second coordinate based on the selected mode. %
%                                                                             %
% Inputs:                                                                     %
%   N     - number of equidistant sample points                               %
%   sigma - amplitude of the added noise                                      %
%   mode  - selects the type of distortion which affects frequency/region     %
%           of oscillation:                                                   %
%           'none' - adds regular periodic noise across the whole curve       %
%           'wavy' - adds lower-frequency global oscillation                  %
%           'qrtr' - adds localized oscillation applied only to 1/4 of the    %
%                    points                                                   %
%                                                                             %
% Output:                                                                     %
%   f_samples - an Nx2 matrix where each row is a sampled (x, y) point        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % define the curve
  f1=@(t) cos(t); f2=@(t) sin(t);   % unit circle
  
  % other example curves (commented out):
  %f1=@(t) 4*cos(t);          f2=@(t) 2*sin(t);           % ellipse
  %f1=@(t) t;                 f2=@(t) t.^2;               % parabola
  %f1=@(t) cosh(t);           f2=@(t) sinh(t);            % hyperbola
  %f1=@(t) 4*cos(t)+cos(4*t); f2=@(t) 4*sin(t)-sin(4*t);  % star shape

  % sample the function over 2^(−J)Z^2, and apply oscillatory noise
  f_samples=zeros(N,2);
  for i=1:N

      % sample the x-coordinate
      f_samples(i,1)=f1((-ceil(N/2)+i)*2*pi/N);  

      % sample the y-coordinate
      if strcmp(mode, 'wavy')==1
        f_samples(i,2)=f2((-ceil(N/2)+i)*2*pi/N)+sigma*cos(i/20);  
      elseif strcmp(mode, 'qrtr')==1
          t=sin(0:pi/(N/4):pi);
          if floor(N/4)<i && i<floor(1*N/2)
              f_samples(i,2)=f2((-ceil(N/2)+i)*2*pi/N)+t(i-N/4)*sigma*cos(i/3);  
          else
              f_samples(i,2)=f2((-ceil(N/2)+i)*2*pi/N);  
          end
      else % mode=='none'
        f_samples(i,2)=f2((-ceil(N/2)+i)*2*pi/N)+sigma*cos(i/5); 
      end
  end

  % optional plotting for debugging:
  %{
  figure

  % the signal
  t_for_f=-pi:2^(-10):pi;
  plot(f1(t_for_f),f2(t_for_f))
  hold on

  % the sampled data points
  plot(f_samples(:,1),f_samples(:,2), '.','Color','k','LineStyle','none','MarkerSize',10)
  %}
end
