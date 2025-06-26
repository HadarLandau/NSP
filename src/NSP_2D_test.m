function [results, fixed_results] = NSP_2D_test (mask_ev,all_shifts)
%convolotion of mask_ev and gamma should result in delta
  J=length(mask_ev);
  results=cell(J,1);
  fixed_results=cell(J,1);

  all_gammas=NSP_find_gamma(mask_ev, 12);

  for k=1:J
    mask_ev_k=mask_ev{k};
    %convolotion with gamma
    result=zeros(size(mask_ev_k));
    fixed_result=zeros(size(mask_ev_k));
    gamma=all_gammas{k};
    fixed_gamma=all_gammas{k}.*sqrt(1.000024141921292);
    shift=all_shifts(k);
    for i=1:length(mask_ev_k)
      for j=1:length(mask_ev_k)
        if i-j+shift>0 && i-j+shift<=length(gamma)
          result(i)= result(i)+mask_ev_k(j).*gamma(i-j+shift);
          fixed_result(i)= fixed_result(i)+mask_ev_k(j).*fixed_gamma(i-j+shift);
        end
      end
    end
    results{k}=result-[0;0;1;0;0];
    s=sum(result);
    fixed_results{k}=fixed_result-[0;0;1;0;0];
    fs=sum(fixed_result);
  end

  results;
  fixed_results;

