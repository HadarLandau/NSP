function [reconstructed_data] = NSP_2D_padded_reconstruction (padded_c_0, padded_details)

  J=length(padded_details);
  C=cell(J,1);

  coarse_data=padded_c_0;

  length_data=(length(padded_details{J})+4)/5;

  for l=1:J
    %computing Sa(c(l-1)) as a convolotion of the coarse data and alpha
    L=length(coarse_data);
    %[alpha_ev, alpha_odd] = NSP_create_mask_a1_2 (cos(2*pi/(length_data/2^(J-l+1))));
    alpha_ev=[0.125,0.75,0.125]'; alpha_odd=[0.5 0.5]';

    %even rule
    le=length(alpha_ev);
    refined_data_ev=zeros(L,2);
    for i=1:L
       for j=-ceil(le/2)+1:floor(le/2)
           if i+j>0  &&  i+j<=L
              refined_data_ev(i,:)=refined_data_ev(i,:)+coarse_data(i+j,:)*alpha_ev(j+ceil(le/2));
           end
       end
    end

    %odd rule
    lo=length(alpha_odd);
    refined_data_odd=zeros(L-1,2); %because we add new points only between 2 original points
    for i=1:L-1
        for j=-ceil(lo/2)+1:floor(lo/2)
            if i+j>0  &&  i+j<=L
               refined_data_odd(i,:)=refined_data_odd(i,:)+coarse_data(i+j,:)*alpha_odd(j+ceil(lo/2));
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

    %adding the details d(l) to Sa(c(l-1)), to get: c(l)=Sa(c(l-1))+d(l)
    C{l}=refined_data+padded_details{l};
    %for the next iteration
    coarse_data=C{l};
  end

  padded_reconstructed_data=C{J};

  %getting the reconstructed_data (without the padding)
  length_data=(length(padded_reconstructed_data)+4)/5;
  reconstructed_data=padded_reconstructed_data(2*length_data-1:end-(2*length_data-2),:);

%{
  %plot
  figure
  plot(reconstructed_data(:,1),reconstructed_data(:,2))
%}



