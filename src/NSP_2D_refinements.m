function [f_refinemented] = NSP_2D_refinements (data, J, mask_ev, mask_odd)
  %data here is N*2

  f_refinements=cell(J+1,1);
  f_refinements{1}=data;

  %refinemts
  fk=data;
  for k=1:J

      mask_ev_k=mask_ev{k};
      mask_odd_k=mask_odd{k};

      %even rule
      fev_kplus1=zeros(size(fk));
      for l=1:size(fev_kplus1,1)
         for j=-1:1
             if l+j>0  &&  l+j<=size(fk,1)
                fev_kplus1(l,:)=fev_kplus1(l,:)+fk(l+j,:).*mask_ev_k(j+2);  %N*2
             end
         end
      end

      %odd rule
      fodd_kplus1=zeros(size(fk,1)-1,size(fk,2));
      for l=1:size(fodd_kplus1,1)
         for j=0:1
             if l+j>0  &&  l+j<=size(fk,1)
                fodd_kplus1(l,:)=fodd_kplus1(l,:)+fk(l+j,:).*mask_odd_k(j+1);   %(N-1)*2
             end
         end
      end

%%%fk_plus1=zeros(size(fev_kplus1,1)+size(fodd_kplus1,1),size(fev_kplus1,2));
      %merging the even and the odd refinements
      fk_plus1_x=[fev_kplus1(:,1)';[fodd_kplus1(:,1)',0]];
      fk_plus1_x=fk_plus1_x(:);
      fk_plus1_y=[fev_kplus1(:,2)';[fodd_kplus1(:,2)',0]];
      fk_plus1_y=fk_plus1_y(:);
      %getting the current refinement (omitting the 0 in the end)
      fk_plus1_x=fk_plus1_x(1:end-1);
      fk_plus1_y=fk_plus1_y(1:end-1);
      fk_plus1=[fk_plus1_x,fk_plus1_y];
      f_refinements{k+1}=fk_plus1;

      %preparing for the next iteration
      fk=fk_plus1;
  end

  f_refinemented=f_refinements;%{K+1};

%
  figure
  f1=@(t) cos(t); f2=@(t) sin(t);
  %f1=@(t) 4*cos(t)+cos(4*t); f2=@(t) 4*sin(t)-sin(4*t);
  N=size(data,1); %N is odd
  istart=1; K=3;
  %the original signal
  t_for_f=istart:2^(-10):istart+(N-1)*2^(-K);
  plot(f1(t_for_f),f2(t_for_f))
  hold on
  %the data
  plot(data(:,1),data(:,2),'.','MarkerSize',15,'Color','k','LineStyle','none')
  hold on
  %the refinemented data
  f_refinement_J=f_refinements{J+1};
  plot(f_refinement_J(53:end-52,1),f_refinement_J(53:end-52,2))
  legend('original curve','data', 'refinemented data')
%}
