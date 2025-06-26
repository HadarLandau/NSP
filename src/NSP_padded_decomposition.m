function [c_0, details, padded_c_0, padded_details] = NSP_padded_decomposition (data, J, all_alpha_ev, all_alpha_odd, all_shifts)

  % J is an integer number in the range of [1,6]
  details=cell(J,1);
  padded_details=cell(J,1);
  padded_data=[data(3:end);data;data;data;data(1:end-2)];
  c_l=padded_data;  %padded C_J
  all_gammas=NSP_find_gamma(all_alpha_ev, 5);


  for l=J:-1:1

  %%%% computing C_l-1 by gamma[l-1] %%%%

    %downsampling C_l
    L=length(c_l);  %should be odd  %for l=J: L=5*length(data)-4
    downsampled_c_l=zeros((L+1)/2,1);
    for i=1:length(downsampled_c_l)
      downsampled_c_l(i)=c_l(2*i-1);
    end

    %convolotion with gamma
    prev_c_l=zeros(size(downsampled_c_l));  %C_l-1
    gamma=all_gammas{l};
    shift=all_shifts(l);
    for i=1:length((downsampled_c_l))
      for j=1:length((downsampled_c_l))
        if i-j+shift>0 && i-j+shift<=length(gamma)
          prev_c_l(i)= prev_c_l(i)+downsampled_c_l(j)*gamma(i-j+shift);
        end
      end
    end

  %%%% computing S_alpha[l-1](C_l-1) %%%%

    %even rule
    alpha_ev=all_alpha_ev{l};
    refined_c_l_ev=zeros(length(prev_c_l),1);
    for i=1:length(refined_c_l_ev)
       for j=-1:1 %because length(alpha_ev)=3
           if i+j>0  &&  i+j<=length(prev_c_l)
              refined_c_l_ev(i)=refined_c_l_ev(i)+prev_c_l(i+j)*alpha_ev(j+2);
           end
       end
    end

    %odd rule
    alpha_odd=all_alpha_odd{l};
    refined_c_l_odd=zeros(length(prev_c_l)-1,1);
    for i=1:length(refined_c_l_odd)
       for j=0:1
           if i+j>0  &&  i+j<=length(prev_c_l)
              refined_c_l_odd(i)=refined_c_l_odd(i)+prev_c_l(i+j)*alpha_odd(j+1);
           end
       end
    end

    %merging the even and the odd refinements
    refined_c_l=[refined_c_l_ev';[refined_c_l_odd',0]];
    refined_c_l=refined_c_l(:);
    %getting the current refinement (omitting the 0 in the end)
    refined_c_l=refined_c_l(1:end-1);


  %%%% computing d[l] %%%%

    padded_details{l}=c_l-refined_c_l;

    %for the next iteration:
    c_l=prev_c_l;

end

  padded_c_0=prev_c_l;

  %getting the original pyramid (without the padding)
  length_data=length(data);
  for l=1:J
    padded_details_l=padded_details{l};
    pad_length=(2*length_data-2)/(2^(J-l));
    details{l}=padded_details_l(pad_length+1:end-pad_length);
  end

  pad_length=(2*length_data-2)/(2^J);
  c_0=prev_c_l(pad_length+1:end-pad_length);

