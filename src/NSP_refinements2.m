function [f_refinemented] = NSP_refinements2 (data, K, mask_ev, mask_odd)

  f_refinements=cell(K+1,1);
  f_refinements{1}=data;

  %refinemts
  fk=data;
  for k=1:K

      mask_ev_k=mask_ev{k};
      mask_odd_k=mask_odd{k};
      le=length(mask_ev_k);
      lo=length(mask_odd_k);

      %even rule
      fev_kplus1=zeros(length(fk),1);
      for l=1:length(fev_kplus1)
         fev_kplus1(l)=0;
         for j=-ceil(le/2)+1:floor(le/2)
             if l+j>0  &&  l+j<=length(fk)
                fev_kplus1(l)=fev_kplus1(l)+fk(l+j)*mask_ev_k(j+ceil(le/2));
             end
         end
      end

      %odd rule
      fodd_kplus1=zeros(length(fk)-1,1);
      for l=1:length(fodd_kplus1)
         fodd_kplus1(l)=0;
         for j=-ceil(lo/2)+1:floor(lo/2)
             if l+j>0  &&  l+j<=length(fk)
                fodd_kplus1(l)=fodd_kplus1(l)+fk(l+j)*mask_odd_k(j+ceil(lo/2));
             end
         end
      end

      %merging the even and the odd refinements
      fk_plus1=[fev_kplus1';[fodd_kplus1',0]];
      fk_plus1=fk_plus1(:);
      %getting the current refinement (omitting the 0 in the end)
      fk_plus1=fk_plus1(1:end-1);
      f_refinements{k+1}=fk_plus1;

      %preparing for the next iteration
      fk=fk_plus1;
  end

  f_refinemented=f_refinements;%{K+1};

%
  figure
  J=1;
  N=length(data) %N is odd
  f=@(x) sin(4*(x-1)*pi/(N*2^-(J+1)));
  %f=@(x) heaviside(x-1-(N-1)/2^(J+1))+heaviside(x-(N-1)/2^(J+1))+heaviside(x-2-(N-1)/2^(J+1));
  istart=1;
   %the signal
  x_data_for_f=istart:2^(-10):istart+(N-1)*2^(-J);
  %plot(x_data_for_f,f(x_data_for_f))
  hold on
   %the data
  %x_data_for_f=-floor(N/2):floor(N/2);
  x_data_for_data=1:2^(-J):1+(N-1)*2^(-J); %%%%%%%
  plot(x_data_for_data,data,'.-','Color','k')%,'LineStyle','none')%,'-*')
  hold on
   %the refinemented data
  %x_data=-floor(N/2):2^(-K):floor(N/2);
  x_data=1:2^(-(K+J)):1+(N-1)*2^(-J); %%%%%%%%%%
  length(x_data)
  length(f_refinements{K+1})
  plot(x_data,f_refinements{K+1})
  %xticks(1:0.5:9)
  %xlim([1,9])
  %legend('original function', 'data', 'refinemented data')
  legend('data', 'refinemented data')
%}
