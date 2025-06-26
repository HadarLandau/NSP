function [mask_ev, mask_odd] = NSP_create_mask (theta)

  mask_ev=cell(6,1);
  mask_odd=cell(6,1);

  %computing v(k)
  v=zeros(6,1);
  initial_v=cos(theta);  %v(-1)
  v(1)=sqrt((1+initial_v)/2);  %v(0)
  for k=2:6
    v(k)=sqrt((1+v(k-1))/2);  %v(1),...,v(5)
  end

  %computing the mask   (S_alpha_[0],...,S_alpha_[5])
  for k=1:6
    mask_ev{k}=[1/(2*(v(k)+1)^2); (4*v(k)^2+2)/(2*(v(k)+1)^2); 1/(2*(v(k)+1)^2)];
  end
  for k=1:6
    mask_odd{k}=[2*v(k)/((v(k)+1)^2); 2*v(k)/((v(k)+1)^2)];
  end

