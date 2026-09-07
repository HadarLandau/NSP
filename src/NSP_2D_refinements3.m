function [f_refined] = NSP_2D_refinements3 (data, J, mask_ev, mask_odd)
% with zoom
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs J levels of refinement on N equidistant 2D sample points %
% using a given non-stationary subdivision mask.                                  %
%                                                                                 %
% Inputs:                                                                         %
%   data     - an N×2 matrix of 2D points sampled from a shape (e.g., a circle)   %
%   J        - number of refinement levels                                        %
%   mask_ev  - cell array of length J, each cell contains an even refinement mask %
%   mask_odd - cell array of length J, each cell contains a corresponding odd     %
%              refinement mask                                                    %
%                                                                                 %
% Output:                                                                         %
%   f_refinemented - a cell array of length J+1 containing all refinement levels, %
%                    where f_refinemented{1} = original data, and                 %
%                    f_refinemented{J+1} = final refinement                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  f_refinements=cell(J+1,1);
  f_refinements{1}=data; %k=0

  % padding the data to avoid boundary issues

  % for periodic shapes like circle or ellipse, simple repetition works
  fk=[data;data;data]; 
  % for hyperbolic-like shapes:
  %fk=[flip(data);data;flip(data)]; 

  % perform J levels of refinement

  for k=1:J

      mask_ev_k=mask_ev{k};
      %mask_ev_k=[0.125 ; 0.75; 0.125]; %%%%%%%%%%%%%%%%%%%%%%%%%%
      mask_odd_k=mask_odd{k};
      %mask_odd_k=[0.5 ; 0.5]; %%%%%%%%%%%%%%%%%%%%%%%%%%
      le=length(mask_ev_k);
      lo=length(mask_odd_k);

      % even refinement
      fev_kplus1=zeros(size(fk));
      for l=1:size(fev_kplus1,1)
         for j=-ceil(le/2)+1:floor(le/2)
             if l+j>0  &&  l+j<=size(fk,1)
                fev_kplus1(l,:)=fev_kplus1(l,:)+fk(l+j,:).*mask_ev_k(j+ceil(le/2));  %N*2
             end
         end
      end

      % odd refinement
      fodd_kplus1=zeros(size(fk,1)-1,size(fk,2));
      for l=1:size(fodd_kplus1,1)
         for j=-ceil(lo/2)+1:floor(lo/2)
             if l+j>0  &&  l+j<=size(fk,1)
                fodd_kplus1(l,:)=fodd_kplus1(l,:)+fk(l+j,:).*mask_odd_k(j+ceil(lo/2));   %(N-1)*2
             end
         end
      end

      % merge even and odd refined samples
      fk_plus1_x=[fev_kplus1(:,1)';[fodd_kplus1(:,1)',0]];
      fk_plus1_x=fk_plus1_x(:);
      fk_plus1_y=[fev_kplus1(:,2)';[fodd_kplus1(:,2)',0]];
      fk_plus1_y=fk_plus1_y(:);

      % extract the refinements (remove the 0 in the end)
      fk_plus1_x=fk_plus1_x(1:end-1);
      fk_plus1_y=fk_plus1_y(1:end-1);

      % combine x and y into Nx2 matrix
      fk_plus1=[fk_plus1_x,fk_plus1_y];

      % store current refinement
      f_refinements{k+1}=fk_plus1;

      % prepare for next iteration
      fk=fk_plus1;
  end

  % return all refinements
  f_refined=f_refinements;


% =========================
% Main plot
% =========================

  % define reference curve
  f1=@(t) cos(t); f2=@(t) sin(t);   % unit circle

  N=size(data,1);

  figure

% plot continuous reference curve
t_for_f = -pi:2^(-10):pi;
plot(f1(t_for_f), f2(t_for_f))
hold on

% plot initial data points
plot(data(:,1), data(:,2), ...
    '-s', ...
    'MarkerSize', 13, ...
    'Color', 'k', ...
    'MarkerFaceColor', 'k', ...
    'LineStyle', 'none')

% plot final refined data (subset corresponding to original domain)
f_refinement_J = f_refinements{J+1};

plot(f_refinement_J((N-1)*2^J:end-N*2^J,1), ...
     f_refinement_J((N-1)*2^J:end-N*2^J,2), ...
     '-r.', ...
     'MarkerSize', 15, ...
     'Color', 'r')

% formatting
ax = gca;
ax.FontSize = 26;
axis off
axis equal
xlim([-1.2 1.2])
ylim([-1.2 1.2])

legend('original curve', 'data', 'refined data', ...
       'Interpreter', 'latex', 'FontSize', 15)


% =========================
% Zoomed-in inset
% =========================

ax_zoom = axes('Position', [0.30 0.15 0.22 0.22]);

% reference curve
plot(f1(t_for_f), f2(t_for_f))
hold on

% initial data points
plot(data(:,1), data(:,2), ...
    '-s', ...
    'MarkerSize', 13, ...
    'Color', 'k', ...
    'MarkerFaceColor', 'k', ...
    'LineStyle', 'none')

% refined data
plot(f_refinement_J((N-1)*2^J:end-N*2^J,1), ...
     f_refinement_J((N-1)*2^J:end-N*2^J,2), ...
     '-r.', ...
     'MarkerSize', 15, ...
     'Color', 'r')

% limits of the zoom (focusing on a region in the third quadrant)
x_center = -0.7071; % e.g., cos(-3*pi/4) on the unit circle
y_center = -0.7071; % e.g., sin(-3*pi/4) on the unit circle
zoom_width = 0.3;   % adjust window size (smaller = more zoomed in)

axis equal
xlim([x_center - zoom_width/2, x_center + zoom_width/2])
ylim([y_center - zoom_width/2, y_center + zoom_width/2])

daspect(ax_zoom, [1 1 1])

%axis equal
box on
set(gca, 'FontSize', 12)


end
