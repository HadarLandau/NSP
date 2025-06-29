%figure 3

function [f_refinemented] = NSP_2D_refinements2 (data, J, mask_ev, mask_odd)
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
      mask_odd_k=mask_odd{k};
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
  f_refinemented=f_refinements;


  % plot

  figure

  % define the curve
  f1=@(t) cos(t); f2=@(t) sin(t);   % unit circle

  % other example curves (commented out):
  %f1=@(t) 4*cos(t);  f2=@(t) 2*sin(t);   % ellipse
  %f1=@(t) t;         f2=@(t) t.^2;       % parabola
  %f1=@(t) cosh(t);   f2=@(t) sinh(t);    % hyperbola

  N=size(data,1); 

  % the original signal
  t_for_f=-pi:2^(-10):pi;
  plot(f1(t_for_f),f2(t_for_f))
  hold on

  % the given data points
  plot(data(:,1),data(:,2),'-s','MarkerSize',13,'Color','k','MarkerFaceColor','k','LineStyle','none')
  hold on
   
  % the final refined data
  f_refinement_J=f_refinements{J+1};
  plot(f_refinement_J((N-1)*2^J:end-N*2^J,1),f_refinement_J((N-1)*2^J:end-N*2^J,2),...
                                    '.','MarkerSize',15,'Color','r','LineStyle','none')
  xlim([-1.2 1.2])
  ylim([-1.2 1.2])
  legend('original curve','data', 'refinemented data','Interpreter','latex','FontSize',35)
end
