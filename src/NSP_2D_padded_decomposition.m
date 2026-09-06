function [details] = NSP_2D_padded_decomposition (data, J, fig, plot_flag)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs J levels of multiscale decomposition of 2D data   %
% using the non-stationary geometric subdivision scheme.                   %
%                                                                          %
% At each level, the coarse data is obtained by applying the corresponding %
% decimation operator, and the detail coefficients are computed as the     %
% difference between the original data and its reconstruction from the     %
% coarser level.                                                           %
%                                                                          %
% Inputs:                                                                  %
%   data      - an N×2 matrix of 2D sample points; N must be even          %
%   J         - number of decomposition levels, in the range [1,6]         %
%   fig       - figure identifier specifying the amount of padding to      %
%               remove when extracting the detail coefficients             %
%   plot_flag - logical flag; if true, the detail coefficients and the     %
%               coarsest data are plotted                                  %
%                                                                          %
% Output:                                                                  %
%   details   - cell array of length J containing the detail coefficients  %
%               at each decomposition level                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % initialize storage for the detail coefficients
  details=cell(J,1);

  % concatenating the data with itself to reduce boundary effects during
  % the convolution and decimation operations.
  padded_details=cell(J,1);
  padded_data=[data;data;data;data;data];

  % initialize the current level with the padded data C^(J)
  c_l=padded_data;  
  length_data=length(data);
 
  %% perform the multiscale decomposition
  % the decomposition proceeds from the finest level J down to level 1
  for l=J:-1:1

    % current number of data points at level l
    L=size(c_l,1);

    % construct the level-dependent geometric subdivision masks, the parameter
    % v is determined by the number of points at the corresponding scale
    [alpha_ev, alpha_odd]=NSP_create_mask_a1_vec(cos(2*pi/(length_data/2^(J-l+1))));

    % compute the decimation mask gamma^(l)
    gamma=NSP_find_gamma_vec(alpha_ev, 15);


    % compute the coarse data C^(l-1) = D_gamma^(l) * C^(l)

    % downsample C^(l) by retaining every second point
    downsampled_c_l=zeros(L/2,2);
    for i=1:length(downsampled_c_l)
      downsampled_c_l(i,:)=c_l(2*i-1,:);
    end

    % apply the decimation mask by convolution
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

    % apply the even subdivision rule
    le=length(alpha_ev);
    refined_c_l_ev=zeros(length(prev_c_l),2);

    for i=1:length(refined_c_l_ev)
       for j=-ceil(le/2)+1:floor(le/2)
           if i+j>0  &&  i+j<=length(prev_c_l)
              refined_c_l_ev(i,:)=refined_c_l_ev(i,:)+prev_c_l(i+j,:).*alpha_ev(j+ceil(le/2));
           end
       end
    end

    % apply the odd subdivision rule
    lo=length(alpha_odd);
    refined_c_l_odd=zeros(length(prev_c_l),2);

    for i=1:length(refined_c_l_odd)
       for j=-ceil(lo/2)+1:floor(lo/2)
           if i+j>0  &&  i+j<=length(prev_c_l)
              refined_c_l_odd(i,:)=refined_c_l_odd(i,:)+prev_c_l(i+j,:)*alpha_odd(j+ceil(lo/2));
           end
       end
    end

    % merge the even and odd refinements
    refined_c_l_x=[refined_c_l_ev(:,1)';refined_c_l_odd(:,1)'];
    refined_c_l_x=refined_c_l_x(:);

    refined_c_l_y=[refined_c_l_ev(:,2)';refined_c_l_odd(:,2)'];
    refined_c_l_y=refined_c_l_y(:);

    refined_c_l=[refined_c_l_x,refined_c_l_y];

    % compute the detail coefficients d^(l) 
    padded_details{l}=c_l-refined_c_l;

    % prepare for the next iteration
    c_l=prev_c_l;
  end

  % remove padding from the detail coefficients
  for l=1:J
    padded_details_l=padded_details{l};

    % determine the amount of padding to remove at the current level
    pad_length=2*length_data/(2^(J-l));

    if strcmp(fig, 'fig7')==1
        % Extract the relevant detail coefficients for Figure 7
        % after removing the padded boundary regions 
        details{l}=padded_details_l(pad_length+1:end-pad_length,:); 
      
    elseif strcmp(fig, 'fig10')==1
        % extract the relevant detail coefficients for Figure 10
        % after removing the padded boundary regions and boundary artifacts
        details{l}=padded_details_l(pad_length+4:end-pad_length-3,:);

    else % fig=='fig4','fig5','fig8'
        % Extract the relevant detail coefficients for Figures 4,5 and 8
        % after removing the padded boundary regions and boundary artifacts
        details{l}=padded_details_l(pad_length+12:end-pad_length-11,:); 
    end
  end

  % extract the coarsest approximation C^(0)
  pad_length=2*length_data/(2^J);
  c_0=prev_c_l(pad_length+1:end-pad_length,:);

  % optional visualization
  if plot_flag

    % plot the Euclidean norms of the detail coefficients at each level
    NSP_plot_details (details)

    figure

    % Define the reference curve (unit circle)
    f1=@(t) cos(t); f2=@(t) sin(t);   
    t_for_f=-pi:2^(-10):pi;
    plot(f1(t_for_f),f2(t_for_f),'LineWidth',2)
    hold on

    % plot the sampled data points
    plot(data(:,1),data(:,2), '.','MarkerSize',10,'Color','r','LineStyle','none')
    hold on

    % plot the coarsest approximation C^(0)
    plot(c_0(:,1),c_0(:,2),'s','MarkerSize',10,'Color','k','MarkerFaceColor','k','LineStyle','none')
    
    % format the figure
    axis off
    axis equal
    xlim ([-1.5, 1.5])
    ylim ([-1.5, 1.5])

    legend('original curve','data', '$c^{(0)}$','FontSize',20,'Interpreter','latex');
  end
end



