%figures 4-7

function [details] = NSP_2D_padded_decomposition3 (data, J)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function receives refined data C^(J), decomposes it through %
% a multiscale transform, and returns coarse data C^(0) along with %
% the corresponding detail coefficients.                           %
%                                                                  %
% Inputs:                                                          %
%   data - a vector of samples                                     %
%   J    - number of decomposition levels, in the range [1, 6]     %
%                                                                  %
% Output:                                                          %
%   details - A cell array containing the detail coefficients      %
%             d{1},...,d{J}                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% length(data) must be even!


  details=cell(J,1);

  % concatenating the data with itself to overcome edge anomalies
  padded_details=cell(J,1);
  padded_data=[data;data;data;data;data];

  c_l=padded_data;  %padded C_J
  length_data=length(data);


  for l=J:-1:1 % l is the level of the decomposition

    % compute the current length of C^(l)
    L=size(c_l,1);
    % compute the geometric subdivision mask alpha^(l)
    [alpha_ev, alpha_odd] = NSP_create_mask_a1_2 (cos(2*pi/(length_data/2^(J-l+1))));
    % compute the decimation operator gamma^(l)
    gamma=NSP_find_gamma2(alpha_ev, 15);


    % compute C^(l-1) = D_gamma^(l) * C^(l)

    % downsample C^(l)
    downsampled_c_l=zeros(L/2,2);
    for i=1:length(downsampled_c_l)
      downsampled_c_l(i,:)=c_l(2*i-1,:);
    end

    % convolve with gamma^(l)
    prev_c_l=zeros(size(downsampled_c_l));  %C^(l-1)
    shift=(length(gamma)+1)/2;
    for i=1:length((downsampled_c_l))
      for j=1:length((downsampled_c_l))
        if i-j+shift>0 && i-j+shift<=length(gamma)
          prev_c_l(i,:)= prev_c_l(i,:)+downsampled_c_l(j,:).*gamma(i-j+shift);
        end
      end
    end


    % compute S_alpha^(l)C^(l-1)

    % convolution with the even rule
    le=length(alpha_ev);
    refined_c_l_ev=zeros(length(prev_c_l),2);
    for i=1:length(refined_c_l_ev)
       for j=-ceil(le/2)+1:floor(le/2)
           if i+j>0  &&  i+j<=length(prev_c_l)
              refined_c_l_ev(i,:)=refined_c_l_ev(i,:)+prev_c_l(i+j,:).*alpha_ev(j+ceil(le/2));
           end
       end
    end

    % convolution with the odd rule
    lo=length(alpha_odd);
    refined_c_l_odd=zeros(length(prev_c_l),2);
    for i=1:length(refined_c_l_odd)
       for j=-ceil(lo/2)+1:floor(lo/2)
           if i+j>0  &&  i+j<=length(prev_c_l)
              refined_c_l_odd(i,:)=refined_c_l_odd(i,:)+prev_c_l(i+j,:)*alpha_odd(j+ceil(lo/2));
           end
       end
    end

    % merge even and odd refinements
    refined_c_l_x=[refined_c_l_ev(:,1)';refined_c_l_odd(:,1)'];
    refined_c_l_x=refined_c_l_x(:);
    refined_c_l_y=[refined_c_l_ev(:,2)';refined_c_l_odd(:,2)'];
    refined_c_l_y=refined_c_l_y(:);
    refined_c_l=[refined_c_l_x,refined_c_l_y];

    % compute d^(l) 
    padded_details{l}=c_l-refined_c_l;

    % prepare for next iteration
    c_l=prev_c_l;
  end

  % extract the original pyramid (without padding)
  for l=1:J
    padded_details_l=padded_details{l};
    pad_length=2*length_data/(2^(J-l));

    details{l}=padded_details_l(pad_length+12:end-pad_length-11,:);%%%%%%%%%%%
    details{l}=padded_details_l(pad_length+1:end-pad_length,:);%%%%%%%%%%%%
  end

  % extract original C^(0) (without padding)
  pad_length=2*length_data/(2^J);
  c_0=prev_c_l(pad_length+1:end-pad_length,:);

  % plot the Euclidean norms of the detail coefficients
  NSP_plot_details (details)

  % plot C^(J) and C^(0)
  figure

  % plot the original signal
  f1=@(t) cos(t); f2=@(t) sin(t);   %circle
  %f1=@(t) cos(t); f2=@(t) sin(t); f3=@(t) 1+sin(t);   %%circle with jump discontinuities
  t_for_f=-pi:2^(-10):pi;
  plot(f1(t_for_f),f2(t_for_f))
  hold on

  % plot the sampled data points
  plot(data(:,1),data(:,2), '.','MarkerSize',8,'Color','r','LineStyle','none')
  hold on

  % plot the coarsest level (C^(0))
  plot(c_0(:,1),c_0(:,2),'s','MarkerSize',10,'Color','k','LineStyle','none')
  legend('original curve','data', '$c^{(0)}$','FontSize',20,'Interpreter','latex');
end



