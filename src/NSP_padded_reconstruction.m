function [reconstructed_data] = NSP_padded_reconstruction (padded_c_0, padded_details, all_alpha_ev, all_alpha_odd)

  J=length(padded_details);
  C=cell(J,1);

  coarse_data=padded_c_0;

  for l=1:J
    %computing Sa(c(l-1)) as a convolotion of the coarse data and alpha
    L=length(coarse_data);

    %even rule
    alpha_ev=all_alpha_ev{l};
    refined_data_ev=zeros(L,1);
    for i=1:L
       for j=-1:1 %because length(alpha_ev)=3
           if i+j>0  &&  i+j<=L
              refined_data_ev(i)=refined_data_ev(i)+coarse_data(i+j)*alpha_ev(j+2);
           end
       end
    end

    %odd rule
    alpha_odd=all_alpha_odd{l};
    refined_data_odd=zeros(L-1,1); %because we add new points only between 2 original points
    for i=1:L-1
        for j=0:1
            if i-j+1>0  &&  i-j+1<=L
               refined_data_odd(i)=refined_data_odd(i)...
                                   +coarse_data(i+j)*alpha_odd(j+1);
            end
        end
    end

    %merging the even and the odd refinements
    refined_data=[refined_data_ev';[refined_data_odd',0]];
    refined_data=refined_data(:);
    refined_data=refined_data(1:end-1);%getting the refinement (omitting the 0 in the end)

    %adding the details d(l) to Sa(c(l-1)), to get: c(l)=Sa(c(l-1))+d(l)
    C{l}=refined_data+padded_details{l};
    %for the next iteration
    coarse_data=C{l};
  end

  padded_reconstructed_data=C{J};

  %getting the reconstructed_data (without the padding)
  length_data=(length(padded_reconstructed_data)+4)/5;
  reconstructed_data=padded_reconstructed_data(2*length_data-1:end-(2*length_data-2));



