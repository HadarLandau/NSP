function [f_samples] = NSP_2D_get_samples (N, sigma, mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function samples a 2D parametric curve at N equidistant points and   %
% adds oscillatory noise to the second coordinate according to a specified  %
% mode.                                                                     %
%                                                                           %
% Inputs:                                                                   %
%   N     - number of equidistant sample points                             %
%   sigma - amplitude of the added oscillatory noise                        %
%   mode  - type of distortion controlling frequency and locality:          %
%           'base' - global periodic oscillation                            %
%           'wavy' - global low-frequency oscillation                       %
%           'qrtr' - localized oscillation applied to one quarter of points %
%                                                                           %
% Output:                                                                   %
%   f_samples - an Nx2 matrix whose rows represent sampled (x, y) points    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % define the curve
  f1=@(t) cos(t); f2=@(t) sin(t);   % unit circle
  
  % alternative example curves (commented out):
  %f1=@(t) 4*cos(t);           f2=@(t) 2*sin(t);           % ellipse
  %f1=@(t) t;                  f2=@(t) t.^2;               % parabola
  %f1=@(t) cosh(t);            f2=@(t) sinh(t);            % hyperbola
  %f1=@(t) 4*cos(t)+cos(4*t);  f2=@(t) 4*sin(t)-sin(4*t);  % star shape

  % initialize output matrix
  f_samples=zeros(N,2);

  % sample the curve and apply oscillatory noise
  for i=1:N

      % parameter value corresponding to the i-th sample (uniform sampling
      % over [-pi, pi], centered via index shift)
      t_i=(-ceil(N/2)+i)*2*pi/N;

      % sample x-coordinate
      f_samples(i,1)=f1(t_i);  

      % sample y-coordinate and apply noise according to the selected mode

      if strcmp(mode, 'wavy')==1
        % global low-frequency oscillation
        f_samples(i,2) = f2(t_i) + sigma*cos(i/20);  
      
      elseif strcmp(mode, 'qrtr')==1
        % localized oscillation on a quarter of the samples
        t=sin(0:pi/(N/4):pi); % smooth transition weights (sine window)
        if floor(N/4)<i && i<floor(1*N/2)
            % apply localized oscillation within the selected region
            f_samples(i,2) = f2(t_i) + t(i-floor(N/4))*sigma*cos(i/3);  
        else
            % no noise outside the selected region
            f_samples(i,2) = f2(t_i);  
        end

      else % mode=='base'
        % global oscillation
        f_samples(i,2) = f2(t_i) + sigma*cos(i/5); 
      end
  end

  % optional visualization (for debugging/inspection)
  %{
  figure

  % the signal
  t_for_f=-pi:2^(-10):pi;
  plot(f1(t_for_f),f2(t_for_f))
  hold on

  % the sampled data points
  plot(f_samples(:,1),f_samples(:,2), '.','Color','k','LineStyle',...
       'none','MarkerSize',10)
  axis equal
  %}
end
