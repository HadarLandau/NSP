function shift = NSP_find_shifts2 (alpha_ev, alpha_odd)
  %alpha_ev is a vector

  gamma=NSP_find_gamma2(alpha_ev, 5);

  %data=1:45;
  data=NSP_2D_get_samples2(65, 0);

  le=length(alpha_ev);
  lo=length(alpha_odd);
  %downsampled_data=1:2:45;
  %downsampled_data=NSP_2D_get_samples2(33, 0) - not good
  downsampled_data=data(1:2:end,:);

%
  for shift=1:11

  shift

    % convolotion with gamma
    prev_data=zeros(size(downsampled_data));
    for i=1:length((downsampled_data))
      for j=1:length((downsampled_data))
        if i-j+shift>0 && i-j+shift<=length(gamma)
          prev_data(i,:)= prev_data(i,:)+downsampled_data(j,:)*gamma(i-j+shift);
        end
      end
    end

    % refinning prev_data by S_alpha
      %even rule
      refined_data_ev=zeros(length(prev_data),2);
      for i=1:length(refined_data_ev)
         for j=-ceil(le/2)+1:floor(le/2)
             if i+j>0  &&  i+j<=length(prev_data)
                refined_data_ev(i,:)=refined_data_ev(i,:)+prev_data(i+j,:)*alpha_ev(j+ceil(le/2));
             end
         end
      end

      %odd rule
      refined_data_odd=zeros(length(prev_data)-1,2);
      for i=1:length(refined_data_odd)
         for j=-ceil(lo/2)+1:floor(lo/2)
               if i+j>0  &&  i+j<=length(prev_data)
                refined_data_odd(i,:)=refined_data_odd(i,:)+prev_data(i+j,:)*alpha_odd(j+ceil(lo/2));
             end
         end
      end

      %merging the even and the odd refinements
      refined_data_x=[refined_data_ev(:,1)';[refined_data_odd(:,1)',0]];
      refined_data_x=refined_data_x(:);
      refined_data_y=[refined_data_ev(:,2)';[refined_data_odd(:,2)',0]];
      refined_data_y=refined_data_y(:);
      %getting the current refinement (omitting the 0 in the end)
      refined_data_x=refined_data_x(1:end-1);
      refined_data_y=refined_data_y(1:end-1);
      refined_data=[refined_data_x,refined_data_y];

   %refined_data'
   d=refined_data-data
%{
   figure
   %the data
   plot(data(:,1),data(:,2))%,'s','MarkerSize',13,'Color','k','LineStyle','none')
   hold on
   plot(refined_data(:,1),refined_data(:,2))
%}

  end

%}
