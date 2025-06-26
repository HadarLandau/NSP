function [f_refinemented] = NSP_2D_refinements2 (data, J, mask_ev, mask_odd)
  %for samples from N equidistant points on a shape
  %%data here is N*2

  f_refinements=cell(J+1,1);
  f_refinements{1}=data;

  %refinemts
  fk=[data;data;data]; %%%% length(fk=3N) for circle, ellipse
  %fk=[flip(data);data;flip(data)]; %for hyperbola
  for k=1:J

      mask_ev_k=mask_ev{k};
      mask_odd_k=mask_odd{k};
      le=length(mask_ev_k);
      lo=length(mask_odd_k);

      %even rule
      fev_kplus1=zeros(size(fk));
      for l=1:size(fev_kplus1,1)
         for j=-ceil(le/2)+1:floor(le/2)
             if l+j>0  &&  l+j<=size(fk,1)
                fev_kplus1(l,:)=fev_kplus1(l,:)+fk(l+j,:).*mask_ev_k(j+ceil(le/2));  %N*2
             end
         end
      end

      %odd rule
      fodd_kplus1=zeros(size(fk,1)-1,size(fk,2));
      for l=1:size(fodd_kplus1,1)
         for j=-ceil(lo/2)+1:floor(lo/2)
             if l+j>0  &&  l+j<=size(fk,1)
                fodd_kplus1(l,:)=fodd_kplus1(l,:)+fk(l+j,:).*mask_odd_k(j+ceil(lo/2));   %(N-1)*2
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

  f_refinemented=f_refinements%{K+1};

%
  figure

  f1=@(t) cos(t); f2=@(t) sin(t);   %%circle
  %f1=@(t) 4*cos(t); f2=@(t) 2*sin(t);   %%ellipse
  %f1=@(t) t; f2=@(t) t.^2;  %%parabola
  %f1=@(t) cosh(t); f2=@(t) sinh(t);   %%hyperbola

  N=size(data,1); %N is odd
  %the original signal
  t_for_f=-pi:2^(-10):pi;
  plot(f1(t_for_f),f2(t_for_f))
  hold on
  %the data
  plot(data(:,1),data(:,2),'-s','MarkerSize',13,'Color','k','MarkerFaceColor','k','LineStyle','none')
  hold on
  %the refinemented data
  f_refinement_J=f_refinements{J+1};
  plot(f_refinement_J((N-1)*2^J:end-N*2^J,1),f_refinement_J((N-1)*2^J:end-N*2^J,2),...
                                    '.','MarkerSize',15,'Color','r','LineStyle','none')
  xlim([-1.2 1.2])
  ylim([-1.2 1.2])
  legend('original curve','data', 'refinemented data','Interpreter','latex','FontSize',35)
%}
