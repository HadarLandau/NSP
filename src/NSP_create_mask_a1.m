%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function computes the geometric subdivision mask, for       %
% a given initial v.                                               %
% where: initial_v is the initial value of v (using equation ?)    %
% the output is 2 cell arrays represent the even and the odd masks %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mask_ev, mask_odd] = NSP_create_mask_a1 (initial_v)

  mask_ev=cell(6,1);
  mask_odd=cell(6,1);

  % computing v(k)
  v=zeros(6,1);
  v(1)=sqrt((1+initial_v)/2);  %v(0)
  for k=2:6
    v(k)=sqrt((1+v(k-1))/2);  %v(1),...,v(5)
  end

  % defining alpha(k)
  alpha=zeros(6,1);
  for k=1:6
    alpha(k)=((2+sqrt(2*(v(k)+1)))*(2-v(k)*sqrt(2*(v(k)+1))))...
                /(8*v(k)*(v(k)-1)*sqrt(2*(v(k)+1))*(v(k)+3+2*sqrt(2*(v(k)+1))));
  end

  % defining beta(k)
  beta=zeros(6,1);
  for k=1:6
    beta(k)=((v(k)+1)*(v(k)-2)-2*sqrt(2*(v(k)+1)))...
                /(2*v(k)*sqrt(2*(v(k)+1))*(v(k)+3+2*sqrt(2*(v(k)+1))));
  end

  % computing the masks (S_a1_[0],...,S_a1_[5]) 
  % computing the even masks
  for k=1:6
    mask_ev{k}=[alpha(k)/(4*v(k)+4);...
                (1+2*v(k)*beta(k)+4*v(k)*alpha(k))/(4*v(k)+4);...
                (4*v(k)*(1-beta(k)-2*alpha(k))-2*alpha(k)+2)/(4*v(k)+4);...
                (1+2*v(k)*beta(k)+4*v(k)*alpha(k))/(4*v(k)+4);...
                alpha(k)/(4*v(k)+4)];
  end

  % computing the odd masks
  for k=1:6
    mask_odd{k}=[alpha(k)/2+beta(k)/(4*v(k)+4);...
                 ((2-2*alpha(k))*(v(k)+1)-beta(k))/((4*v(k)+4));...
                 ((2-2*alpha(k))*(v(k)+1)-beta(k))/((4*v(k)+4));...
                 alpha(k)/2+beta(k)/(4*v(k)+4)];
  end

