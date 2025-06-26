function [prev_c_l, details] = NSP_decomposition (data, J, all_alpha_ev, all_alpha_odd, all_shifts)

  % J is an integer number in the range of [1,6]
  details=cell(J,1);
  c_l=data; %C_J
  all_gammas=NSP_find_gamma(all_alpha_ev, 8);


  for l=J:-1:1

  %%%% computing C_l-1 by gamma[l-1] %%%%

    %downsampling C_l
    L=length(c_l);  %should be odd
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

    details{l}=c_l-refined_c_l;

    %for the next iteration:
    c_l=prev_c_l;

  end

