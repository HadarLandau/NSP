function gamma = NSP_find_gamma(alpha_ev, eps)
% alpha_ev is cell(6,1);

gamma=cell(6,1);
GammaLength=100;%%%%

for k=1:6
  L=length(alpha_ev{k});  %(S_alpha_[0],...,S_alpha_[5])
  zero_pad_size=floor((GammaLength-L)/2);
  zero_pad=zeros(zero_pad_size,1);
  padded_vec=[zero_pad;alpha_ev{k};zero_pad];

  gamma_mask=ifft(1./fft(padded_vec));

  % Truncating
  indices=zeros(length(gamma_mask),1);
  for j=1:length(indices)
      if abs(gamma_mask(j))>10^(-eps)
          indices(j)=1;
      end
  end

  % Filling the places
  res=zeros(length(gamma_mask),1);
  for j=1:length(res)
      if indices(j)==1
          res(j)=gamma_mask(j);
      end
  end

  supp_min=find(res ~= 0, 1, 'first');
  supp_max=find(res ~= 0, 1, 'last');
  gamma{k}=real(res(supp_min:supp_max)); %%real?  %(gamma_[0],...,gamma_[5])
  gamma{k}=gamma{k}/sum(gamma{k});%%%%%%
  s=sum(gamma{k});%%%%%%%%
end

%
figure
for k=1:6
  subplot(2,3,k)
  plot ((gamma{k}))
  xticklabels({})
  if k==1
      xlim([38 64])
  elseif k==2
      xlim([19 29])
  elseif k==3
      xlim([16 26])
  else
      xlim([15 25])
  end
  title (['$\ell$ = ',num2str(k)],'FontSize', 24 ,'Interpreter','latex')
end
%}

