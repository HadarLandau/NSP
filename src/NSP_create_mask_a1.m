function [mask_ev, mask_odd] = NSP_create_mask_a1 (initial_v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function computes the geometric subdivision masks associated   %
% with a given initial value of v.                                    %
%                                                                     %
% Input:                                                              %
%   initial_v - initial value of the parameter v (chosen according to %
%               equation (30))                                        %
%                                                                     %
% Outputs:                                                            %
%   mask_ev   - 6x1 cell array, each cell contains an even mask       %
%   mask_odd  - 6x1 cell array, each cell contains the corresponding  %
%               odd mask                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % initialize cell arrays for storing the masks
  mask_ev=cell(6,1);
  mask_odd=cell(6,1);

  % compute the sequence v^(k) according to v^(k) = sqrt((1 + v^(k-1))/2)
  v=zeros(6,1);
  v(1)=sqrt((1+initial_v)/2);  %v^(0)

  % compute v^(1),...,v^(5)
  for k=2:6
    v(k)=sqrt((1+v(k-1))/2);
  end

  % compute a^(k), k=0,...,5
  a=zeros(6,1);
  for k=1:6
    a(k)=((2+sqrt(2*(v(k)+1)))*(2-v(k)*sqrt(2*(v(k)+1))))...
          /(8*v(k)*(v(k)-1)*sqrt(2*(v(k)+1))*(v(k)+3+2*sqrt(2*(v(k)+1))));
  end

  % compute b^(k), k=0,...,5
  b=zeros(6,1);
  for k=1:6
    b(k)=((v(k)+1)*(v(k)-2)-2*sqrt(2*(v(k)+1)))...
          /(2*v(k)*sqrt(2*(v(k)+1))*(v(k)+3+2*sqrt(2*(v(k)+1))));
  end

  % construct subdivision masks (S_alpha1^(0),...,S_alpha1^(5))

  % even masks
  for k=1:6
    mask_ev{k}=[a(k)/(4*v(k)+4);...
               (1+2*v(k)*b(k)+4*v(k)*a(k))/(4*v(k)+4);...
               (4*v(k)*(1-b(k)-2*a(k))-2*a(k)+2)/(4*v(k)+4);...
               (1+2*v(k)*b(k)+4*v(k)*a(k))/(4*v(k)+4);...
               a(k)/(4*v(k)+4)];
  end

  % odd masks
  for k=1:6
    mask_odd{k}=[a(k)/2+b(k)/(4*v(k)+4);...
                ((2-2*a(k))*(v(k)+1)-b(k))/((4*v(k)+4));...
                ((2-2*a(k))*(v(k)+1)-b(k))/((4*v(k)+4));...
                a(k)/2+b(k)/(4*v(k)+4)];
  end
end
