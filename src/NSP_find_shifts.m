function shift = NSP_find_shifts(all_alpha_ev, all_alpha_odd,k)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % some results: (for ns cubic B-spline mask) %
  % theta=7    =>   shifts=[12,11,11,11,11,11] %
  % theta=2.5  =>   shifts=[32,13,12,11,11,11] %
  % theta=1    =>   shifts=[12,11,11,11,11,11] %
  % theta=i    =>   shifts=[10,11,11,11,11,11] %
  % theta=7i   =>   shifts=[3,6,9,10,11,11]    %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  gammas=NSP_find_gamma(all_alpha_ev, 15);

  data=1:45;

  alpha_ev=all_alpha_ev{k};
  le=length(alpha_ev);
  alpha_odd=all_alpha_odd{k};
  lo=length(alpha_odd);
  gamma=gammas{k};
  downsampled_data=1:2:45;


  for shift=1:10

  shift

    % convolotion with gamma
    prev_data=zeros(size(downsampled_data));
    for i=1:length((downsampled_data))
      for j=1:length((downsampled_data))
        if i-j+shift>0 && i-j+shift<=length(gamma)
          prev_data(i)= prev_data(i)+downsampled_data(j)*gamma(i-j+shift);
        end
      end
    end

    % refinning prev_data by S_alpha
      %even rule
      refined_data_ev=zeros(length(prev_data),1);
      for i=1:length(refined_data_ev)
         for j=-ceil(le/2)+1:floor(le/2)
             if i+j>0  &&  i+j<=length(prev_data)
                refined_data_ev(i)=refined_data_ev(i)+prev_data(i+j)*alpha_ev(j+ceil(le/2));
             end
         end
      end

      %odd rule
      refined_data_odd=zeros(length(prev_data)-1,1);
      for i=1:length(refined_data_odd)
         for j=-ceil(lo/2)+1:floor(lo/2)
               if i+j>0  &&  i+j<=length(prev_data)
                refined_data_odd(i)=refined_data_odd(i)+prev_data(i+j)*alpha_odd(j+ceil(lo/2));
             end
         end
      end

      %merging the even and the odd refinements
      refined_data=[refined_data_ev';[refined_data_odd',0]];
      refined_data=refined_data(:);
      %getting the current refinement (omitting the 0 in the end)
      refined_data=refined_data(1:end-1);
   refined_data'

  end


