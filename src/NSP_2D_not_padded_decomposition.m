function [c_0, details] = NSP_2D_not_padded_decomposition (data, J, all_alpha_ev, all_alpha_odd, all_shifts)

  % J is an integer number in the range of [1,6]
  details=cell(J,1);
%  padded_details=cell(J,1);
%  padded_data=[data(3:end,:);data;data;data;data(1:end-2,:)];
  c_l=data;  %padded C_J
  all_gammas=NSP_find_gamma(all_alpha_ev, 15);



  for l=J:-1:1

  %%%% computing C_l-1 by gamma[l-1] %%%%

    %downsampling C_l
    L=length(c_l);  %should be odd  %for l=J: L=5*length(data)-4
    downsampled_c_l=zeros((L+1)/2,2);
    for i=1:length(downsampled_c_l)
      downsampled_c_l(i,:)=c_l(2*i-1,:);
    end

    %convolotion with gamma
    prev_c_l=zeros(size(downsampled_c_l));  %C_l-1
    gamma=all_gammas{l};%*sqrt(1.000024141921292);
    length(gamma)
    shift=all_shifts(l);
    %
    for i=1:length((downsampled_c_l))
      for j=1:length((downsampled_c_l))
        if i-j+shift>0 && i-j+shift<=length(gamma)
          prev_c_l(i,:)= prev_c_l(i,:)+downsampled_c_l(j,:).*gamma(i-j+shift);
 %         i
 %         j
 %         gamma(i-j+shift)
 %         downsampled_c_l(j,:)
 %         prev_c_l(i,:)
        end
      end
    end
    %}

  %%%% computing S_alpha[l-1](C_l-1) %%%%

    %even rule
    alpha_ev=all_alpha_ev{l};
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
    alpha_odd=all_alpha_odd{l};
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
    refined_c_l_x=refined_c_l_x(1:end-1)
    refined_c_l_y=refined_c_l_y(1:end-1);
    refined_c_l=[refined_c_l_x,refined_c_l_y];

  %%%% computing d[l] %%%%

    details{l}=c_l-refined_c_l;

    %for the next iteration:
    c_l=prev_c_l;

end

  c_0=prev_c_l;

%{
  %getting the original pyramid (without the padding)
  length_data=length(data);
  for l=1:J
    padded_details_l=padded_details{l};
    pad_length=(2*length_data-2)/(2^(J-l));
    details{l}=padded_details_l(pad_length+1:end-pad_length,:);
  end

  pad_length=(2*length_data-2)/(2^J);
  c_0=prev_c_l(pad_length+1:end-pad_length,:);%.*sqrt(1.000024141582802);%%%%%%%;
%}

  NSP_plot_details (details)

  figure
%{
  f1=@(t) cos(t); f2=@(t) sin(t);   %%circle
  %f1=@(t) 4*cos(t); f2=@(t) 2*sin(t);   %%ellipse
  %f1=@(t) t; f2=@(t) t.^2;  %%parabola
  %f1=@(t) cosh(t); f2=@(t) sinh(t);   %%hyperbola

  N=size(data,1); %N is odd
  %the original signal
  t_for_f=-pi:2^(-10):pi;
  plot(f1(t_for_f),f2(t_for_f))
  hold on
  %the data
  plot(data(:,1),data(:,2),'s','MarkerSize',13,'Color','k','LineStyle','none')
  hold on
%}
  %S_alpha[l-1](C_l-1)
  plot(refined_c_l_x(:),refined_c_l_y(:),...
                                    '.','MarkerSize',15,'Color','r','LineStyle','none')
  legend('original curve','data', 'S_alpha[l-1](C_l-1)')
%}

