% figure 3

function [mask_ev, mask_odd] = NSP_create_mask_a1 (initial_v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function computes the geometric subdivision masks for            %
% a given initial value of v.                                           %
%                                                                       %
% Input:                                                                %
%   initial_v - the initial value of v (chosen according to equation ?) %
%                                                                       %
% Outputs:                                                              %
%   mask_ev   - a 6x1 cell array, each cell contains an even mask       %
%   mask_odd  - a 6x1 cell array, each cell contains a corresponding    %
%               odd mask                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  mask_ev=cell(6,1);
  mask_odd=cell(6,1);

  % compute v^(k)
  v=zeros(6,1);
  v(1)=sqrt((1+initial_v)/2);  %v^(0)
  for k=2:6
    v(k)=sqrt((1+v(k-1))/2);  %v^(1),...,v^(5)
  end

  % compute a^(k) for k=0,...,5
  a=zeros(6,1);
  for k=1:6
    a(k)=((2+sqrt(2*(v(k)+1)))*(2-v(k)*sqrt(2*(v(k)+1))))...
                /(8*v(k)*(v(k)-1)*sqrt(2*(v(k)+1))*(v(k)+3+2*sqrt(2*(v(k)+1))));
  end

  % compute b^(k) for k=0,...,5
  b=zeros(6,1);
  for k=1:6
    b(k)=((v(k)+1)*(v(k)-2)-2*sqrt(2*(v(k)+1)))...
                /(2*v(k)*sqrt(2*(v(k)+1))*(v(k)+3+2*sqrt(2*(v(k)+1))));
  end

  % computing the masks (S_alpha1^(0),...,S_alpha1^(5))

  % construct the even masks
  for k=1:6
    mask_ev{k}=[a(k)/(4*v(k)+4);...
               (1+2*v(k)*b(k)+4*v(k)*a(k))/(4*v(k)+4);...
               (4*v(k)*(1-b(k)-2*a(k))-2*a(k)+2)/(4*v(k)+4);...
               (1+2*v(k)*b(k)+4*v(k)*a(k))/(4*v(k)+4);...
               a(k)/(4*v(k)+4)];
  end

  % construct the odd masks
  for k=1:6
    mask_odd{k}=[a(k)/2+b(k)/(4*v(k)+4);...
                ((2-2*a(k))*(v(k)+1)-b(k))/((4*v(k)+4));...
                ((2-2*a(k))*(v(k)+1)-b(k))/((4*v(k)+4));...
                a(k)/2+b(k)/(4*v(k)+4)];
  end
end
