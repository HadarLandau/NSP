function gamma = NSP_find_gamma2 (alpha_ev, eps)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function computes decimation mask gamma for a given refinement         %
% mask alpha                                                                  %
%                                                                             %
% Input:                                                                      %
%   alpha_ev - a vector representing the even part of the refinement mask     %
%   eps      - precision threshold for truncating small values in the         %
%              decimation mask                                                %
%                                                                             %
% Output:                                                                     %
%   gamma    - a normalized vector representing the truncated decimation mask %      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% symmetric zero-padding of alpha
GammaLength=100; % fixed target length for zero-padded filter
L=length(alpha_ev); 
zero_pad_size=floor((GammaLength-L)/2);
zero_pad=zeros(zero_pad_size,1);
padded_vec=[zero_pad;alpha_ev;zero_pad];

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
gamma=real(res(supp_min:supp_max)); 

% normalize
gamma=gamma/sum(gamma);

end