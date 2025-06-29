% figure 1

function gamma = NSP_find_gamma(alpha_ev, eps)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function computes decimation masks gamma^(l) for a given refinement  %
% masks alpha^(l)                                                           %
%                                                                           %
% Input:                                                                    %
%   alpha_ev - cell array of length 6, each cell contains a refinement      %
%              mask, alpha^(l)                                              %
%   eps      - precision threshold for truncating small values in the       %
%              decimation mask                                              %
%                                                                           %
% Output:                                                                   %
%   gamma    - cell array of length 6, each cell contains a normalized      %
%              decimation mask, gamma^(l)                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gamma=cell(6,1); % initialize output cell array
GammaLength=100; % fixed target length for zero-padded filter

for l=1:6

  % symmetric zero-padding of alpha^(l) 
  L=length(alpha_ev{l});  
  zero_pad_size=floor((GammaLength-L)/2);
  zero_pad=zeros(zero_pad_size,1);
  padded_vec=[zero_pad;alpha_ev{l};zero_pad];

  % compute inverse in frequency domain
  gamma_mask=ifft(1./fft(padded_vec));

  % truncate insignificant values

  % binary mask for significant entries
  indices=zeros(length(gamma_mask),1);
  for j=1:length(indices)
      if abs(gamma_mask(j))>10^(-eps)
          indices(j)=1;
      end
  end

  % keep only significant coefficients
  res=zeros(length(gamma_mask),1);
  for j=1:length(res)
      if indices(j)==1
          res(j)=gamma_mask(j);
      end
  end

  % extract support
  supp_min=find(res ~= 0, 1, 'first');
  supp_max=find(res ~= 0, 1, 'last');
  % keep real part of nonzero range
  gamma{l}=real(res(supp_min:supp_max));

  % normalize
  gamma{l}=gamma{l}/sum(gamma{l});
end

% plot gamma^(l) for l=1,...,4
figure
for l=1:4
  subplot(1,4,l)
  plot ((gamma{l}))
  xticklabels({})
  if l==1
      xlim([38 64])
  elseif l==2
      xlim([19 29])
  elseif l==3
      xlim([16 26])
  else
      xlim([15 25])
  end
  title (['$\ell$ = ',num2str(l)],'FontSize', 24 ,'Interpreter','latex')
end
end

