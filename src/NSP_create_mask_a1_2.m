% figures 4-9

function [mask_ev, mask_odd] = NSP_create_mask_a1_2 (initial_v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function computes the geometric subdivision mask corresponding   % 
% to the first refinement level, based on a given initial value of v.   %
%                                                                       %
% Input:                                                                %
%   initial_v - the initial value of v (chosen according to equation ?) %
%                                                                       %
% Outputs:                                                              %
%   mask_ev   - a vector representing the even mask                     %
%   mask_odd  - a vector representing the corresponding odd mask        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % compute v
  v=sqrt((1+initial_v)/2);  

  % compute a
   a=((2+sqrt(2*(v+1)))*(2-v*sqrt(2*(v+1))))...
          /(8*v*(v-1)*sqrt(2*(v+1))*(v+3+2*sqrt(2*(v+1))));

  % compute b
  b=((v+1)*(v-2)-2*sqrt(2*(v+1)))...
        /(2*v*sqrt(2*(v+1))*(v+3+2*sqrt(2*(v+1))));

  % construct the even mask
  mask_ev=[a/(4*v+4);...
          (1+2*v*b+4*v*a)/(4*v+4);...
          (4*v*(1-b-2*a)-2*a+2)/(4*v+4);...
          (1+2*v*b+4*v*a)/(4*v+4);...
          a/(4*v+4)];

  % construct the odd mask
  mask_odd=[a/2+b/(4*v+4);...
           ((2-2*a)*(v+1)-b)/((4*v+4));...
           ((2-2*a)*(v+1)-b)/((4*v+4));...
           a/2+b/(4*v+4)];
end

