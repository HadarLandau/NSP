function [] = NSP_test (istart, N, J, K, theta)

  if imag(theta)==0
    f=@(x) exp(theta*x);
  else
    f=@(x) sin(imag(theta)*x);
  end


  [mask_ev, mask_odd] = NSP_create_mask (theta);
   %sampling the function over 2−JZ
  f_samples=zeros(N,1);
  for i=1:N
      f_samples(i)=f(istart+(i-1)*2^(-J));
  end
  f_samples
  max_sample=f_samples(end);

  f_refinements=cell(K+1,1);
  f_refinements{1}=f_samples;

  %refinements
  fk=f_samples;
  for k=1:K

      mask_ev_k=mask_ev{k};
      mask_odd_k=mask_odd{k};

      %even rule
      fev_kplus1=zeros(length(fk),1);
      for l=1:length(fev_kplus1)
         for j=-1:1
             if l+j>0  &&  l+j<=length(fk)
                fev_kplus1(l)=fev_kplus1(l)+fk(l+j)*mask_ev_k(j+2);
             end
         end
      end

      %odd rule
      fodd_kplus1=zeros(length(fk)-1,1);
      for l=1:length(fodd_kplus1)
         for j=0:1
             if l+j>0  &&  l+j<=length(fk)
                fodd_kplus1(l)=fodd_kplus1(l)+fk(l+j)*mask_odd_k(j+1);
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
   %the signal
  x_data_for_f=istart:2^(-10):istart+(N-1)*2^(-J);
  plot(x_data_for_f,f(x_data_for_f))
  hold on
   %the data
  %x_data_for_f=-floor(N/2):floor(N/2);
  x_data_for_data=1:2^(-J):1+(N-1)*2^(-J); %%%%%%%
  plot(x_data_for_data,f_samples,'.','MarkerSize',15,'Color','k','LineStyle','none')%,'-*')
  hold on
   %the refinemented data
  %x_data=-floor(N/2):2^(-K):floor(N/2);
  x_data=1:2^(-(K+J)):1+(N-1)*2^(-J); %%%%%%%%%%
  length(x_data)
  length(f_refinements{K+1})
  plot(x_data,f_refinements{K+1})
  %xticks(1:0.5:9)
  %xlim([1,9])
  legend('original function', 'data', 'refinemented data')
