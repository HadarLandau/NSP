function [f_refinements] = NSP_2D_refinements (data, J, mask_ev, mask_odd)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs J levels of refinement on a set of N equidistant 2D      %
% sample points using a given non-stationary subdivision scheme.                  %
%                                                                                 %
% Inputs:                                                                         %
%   data     - an N×2 matrix of initial sample points                             %
%   J        - number of refinement levels                                        %
%   mask_ev  - cell array of length J, each cell contains an even refinement mask %
%   mask_odd - cell array of length J, each cell contains the corresponding odd   %
%              refinement mask                                                    %
%                                                                                 %
% Output:                                                                         %
%   f_refinements - cell array of length J+1 containing all refinement levels,    %
%                   where f_refined{1} is the initial data, and f_refined{J+1} is %
%                   the final refined data                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % initialize storage for all refinement levels
  f_refinements=cell(J+1,1);
  f_refinements{1}=data; %k=0

  % padding the data to avoid boundary issues

  % for periodic shapes (e.g., circle or ellipse), repetition ensures continuity
  fk=[data;data;data]; 

  % perform J refinement steps
  for k=1:J

      % extract masks for current level
      mask_ev_k=mask_ev{k};
      mask_odd_k=mask_odd{k};
      
      % mask lengths
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

      % extract the refinements (remove the trailing padding element)
      fk_plus1_x=fk_plus1_x(1:end-1);
      fk_plus1_y=fk_plus1_y(1:end-1);

      % combine coordinates into Nx2 matrix
      fk_plus1=[fk_plus1_x,fk_plus1_y];

      % store current refinement
      f_refinements{k+1}=fk_plus1;

      % prepare for next iteration
      fk=fk_plus1;
  end

  % visualization
  figure

  % define reference curve
  f1=@(t) cos(t); f2=@(t) sin(t);   % unit circle

  % alternative curves (commented out):
  %f1=@(t) 4*cos(t);  f2=@(t) 2*sin(t);   % ellipse
  %f1=@(t) t;         f2=@(t) t.^2;       % parabola
  %f1=@(t) cosh(t);   f2=@(t) sinh(t);    % hyperbola

  N=size(data,1); 

  % plot continuous reference curve
  t_for_f=-pi:2^(-10):pi;
  plot(f1(t_for_f),f2(t_for_f))
  hold on

  % plot initial data points
  plot(data(:,1),data(:,2),'-s','MarkerSize',13,'Color','k','MarkerFaceColor','k','LineStyle','none')
  hold on
   
  % plot final refined data (subset corresponding to original domain)
  f_refinement_J=f_refinements{J+1};
  plot(f_refinement_J((N-1)*2^J:end-N*2^J,1),f_refinement_J((N-1)*2^J:end-N*2^J,2),...
                                    '-r.','MarkerSize',15,'Color','r')
  
  % formatting
  ax = gca;
  ax.FontSize = 26; 
  axis off
  axis equal
  xlim([-1.2 1.2])
  ylim([-1.2 1.2])
  legend('original curve','data', 'refined data','Interpreter','latex','FontSize',15)
end