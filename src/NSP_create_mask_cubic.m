function [mask_ev, mask_odd] = NSP_create_mask_cubic (theta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function generates the even and odd masks for the non-stationary      %
% generalization of the cubic B-spline scheme                                %
% The masks depend on a parameter theta through a sequence v^(k) that is     %
% recursively defined. For each level k = 0,...,5, the function computes     %
% the corresponding refinement masks:                                        %
%       S_{alpha^(k)} = {mask_ev^(k), mask_odd^(k)}.                         %
%                                                                            %
% Input:                                                                     %
%   theta - a scalar parameter used to compute the initial value of v        %
%                                                                            %
% Outputs:                                                                   %
%   mask_ev  - a 6x1 cell array, each cell contains an even mask             %
%   mask_odd - a 6x1 cell array, each cell contains a corresponding odd mask %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % initialize cell arrays that will store the masks
  mask_ev=cell(6,1);
  mask_odd=cell(6,1);

  % compute the sequence v^(k) according to v^(k) = sqrt((1 + v^(k-1))/2),
  % starting from v^(-1) = cos(theta).
  v=zeros(6,1);
  initial_v=cos(theta);  %v^(-1)
  v(1)=sqrt((1+initial_v)/2);  %v^(0)

  % compute v^(1),...,v^(5)
  for k=2:6
    v(k)=sqrt((1+v(k-1))/2); 
  end

  % compute the even refinement masks
  for k=1:6
    mask_ev{k}=[1/(2*(v(k)+1)^2); (4*v(k)^2+2)/(2*(v(k)+1)^2); 1/(2*(v(k)+1)^2)];
  end

  % compute the odd refinement masks
  for k=1:6
    mask_odd{k}=[2*v(k)/((v(k)+1)^2); 2*v(k)/((v(k)+1)^2)];
  end
end

