function [c_0, details,refined_c_l, padded_c_0, padded_details] = NSP_2D_padded_decomposition2 (data, J)
%with the modification in the defenition of the mask

  % J is an integer number in the range of [1,6]
  details=cell(J,1);
  padded_details=cell(J,1);
  padded_data=[data(3:end,:);data;data;data;data(1:end-2,:)];
  %padded_data=[data(3:end,:);flip(data);data;flip(data);data(1:end-2,:)]; %%%%%
  c_l=padded_data;  %padded C_J
  length_data=length(data);


  for l=J:-1:1

    L=size(c_l,1); %should be odd  %for l=J: L=5*length(data)-4
    [alpha_ev, alpha_odd] = NSP_create_mask_a1_2 (cos(2*pi/(length_data/2^(J-l+1))));
    %alpha_ev=[0.125,0.75,0.125]'; alpha_odd=[0.5 0.5]';
    gamma=NSP_find_gamma2(alpha_ev, 15);


  %%%% computing C_l-1 by gamma[l-1] %%%%

    %downsampling C_l
    downsampled_c_l=zeros((L+1)/2,2);
    for i=1:length(downsampled_c_l)
      downsampled_c_l(i,:)=c_l(2*i-1,:);
    end

    %convolotion with gamma
    prev_c_l=zeros(size(downsampled_c_l));  %C_l-1
    shift=(length(gamma)+1)/2;       %%%%%%% depends in the mask. 17 for eps=15, 9 for eps=8, 6 for eps=5
                                     % for B-spline: 20 for eps=15, 11 for eps=8, 7 for eps=5
    %
    for i=1:length((downsampled_c_l))
      for j=1:length((downsampled_c_l))
        if i-j+shift>0 && i-j+shift<=length(gamma)
          prev_c_l(i,:)= prev_c_l(i,:)+downsampled_c_l(j,:).*gamma(i-j+shift);
        end
      end
    end
    %}

  %%%% computing S_alpha[l-1](C_l-1) %%%%

    %even rule
    le=length(alpha_ev);
    refined_c_l_ev=zeros(length(prev_c_l),2);
    for i=1:length(refined_c_l_ev)
       for j=-ceil(le/2)+1:floor(le/2)
           if i+j>0  &&  i+j<=length(prev_c_l)
              refined_c_l_ev(i,:)=refined_c_l_ev(i,:)+prev_c_l(i+j,:).*alpha_ev(j+ceil(le/2));
           end
       end
    end

    %odd rule
    lo=length(alpha_odd);
    refined_c_l_odd=zeros(length(prev_c_l)-1,2);
    for i=1:length(refined_c_l_odd)
       for j=-ceil(lo/2)+1:floor(lo/2)
           if i+j>0  &&  i+j<=length(prev_c_l)
              refined_c_l_odd(i,:)=refined_c_l_odd(i,:)+prev_c_l(i+j,:)*alpha_odd(j+ceil(lo/2));
           end
       end
    end


    %merging the even and the odd refinements
    refined_c_l_x=[refined_c_l_ev(:,1)';[refined_c_l_odd(:,1)',0]];
    refined_c_l_x=refined_c_l_x(:);
    refined_c_l_y=[refined_c_l_ev(:,2)';[refined_c_l_odd(:,2)',0]];
    refined_c_l_y=refined_c_l_y(:);
    %getting the current refinement (omitting the 0 in the end)
    refined_c_l_x=refined_c_l_x(1:end-1);
    refined_c_l_y=refined_c_l_y(1:end-1);
    refined_c_l=[refined_c_l_x,refined_c_l_y];

  %%%% computing d[l] %%%%

    padded_details{l}=c_l-refined_c_l;

    %for the next iteration:
    c_l=prev_c_l;

end

  padded_c_0=prev_c_l;

  %getting the original pyramid (without the padding)
  for l=1:J
    padded_details_l=padded_details{l};
    pad_length=(2*length_data-2)/(2^(J-l));
    details{l}=padded_details_l(pad_length+1:end-pad_length,:);
  end

  pad_length=(2*length_data-2)/(2^J);
  c_0=prev_c_l(pad_length+1:end-pad_length,:); %.*sqrt(1.000024141582802);%%%%%%%;

  NSP_plot_details (details)

  %
  figure

  f1=@(t) cos(t); f2=@(t) sin(t);   %%circle
  %f1=@(t) 4*cos(t); f2=@(t) 2*sin(t);   %%ellipse
  %f1=@(t) t; f2=@(t) t.^2;  %%parabola
  %f1=@(t) cosh(t); f2=@(t) sinh(t);   %%hyperbola
  %f1=@(t) cos(t); f2=@(t) sin(t); f3=@(t) 1+sin(t);   %%circle with jump discontinuities

  N=size(data,1); %N is odd
  %the original signal
  %
  t_for_f=-pi:2^(-10):pi;
  plot(f1(t_for_f),f2(t_for_f))
  hold on
  %}
  %{
  t_for_f=-pi:2^(-10):0;
  plot(f1(t_for_f),f2(t_for_f))
  hold on
  t_for_f=0:2^(-10):pi/2;
  plot(f1(t_for_f),f3(t_for_f))
  hold on
  t_for_f=pi/2:2^(-10):pi;
  plot(f1(t_for_f),f2(t_for_f))
  hold on
  %}
  %the data
  plot(data(:,1),data(:,2), '.','MarkerSize',8,'Color','r','LineStyle','none')
  hold on
  %S_alpha[l-1](C_l-1)
  %plot(refined_c_l_x((N-1)*2^(2-J)+1:end-(N-1)*2^(2-J)),refined_c_l_y((N-1)*2^(2-J)+1:end-(N-1)*2^(2-J)),...
                                  %'s','MarkerSize',10,'Color','g','LineStyle','none')
  %c_0
  plot(c_0(:,1),c_0(:,2),'s','MarkerSize',10,'Color','k','LineStyle','none')
  legend('original curve','data', 'c^{(0)}','FontSize',14)
%}

