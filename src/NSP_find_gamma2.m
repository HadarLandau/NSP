function gamma = NSP_find_gamma2 (alpha_ev, eps)
%alpha_ev is a vector

GammaLength=100;%%%%
L=length(alpha_ev);  %(S_alpha_[0],...,S_alpha_[5])
zero_pad_size=floor((GammaLength-L)/2);
zero_pad=zeros(zero_pad_size,1);
padded_vec=[zero_pad;alpha_ev;zero_pad];

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
gamma=real(res(supp_min:supp_max)); %%real?  %(gamma_[0],...,gamma_[5])
gamma=gamma/sum(gamma);%%%%%%
%s=sum(gamma)%%%%%%%%


%{
figure
plot ((gamma))
%xlim([0 13])
%}

