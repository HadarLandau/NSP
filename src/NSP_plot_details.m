function [] = NSP_plot_details (details)

  J=length(details);

  X=cell(J,1);
  for j = 1:J
     X{j}=linspace(0,2*pi,length(details{j}))';
  end

  details_norms=cell(J,1);
  max_norms=zeros(J,1);

  %Measuring the norms
  for k=1:J
    details_norms{k}=sqrt(sum(details{k}.^2,2)); %%%%%
    max_norms(k)=max(details_norms{k});
  end

  figure
  %str=strrep(char(f),'@(x)','');
  %title(['f(x)=',str;'alpha odd=',num2str(alpha_odd');'alpha ev=',num2str(alpha_ev')])
  subplot(J,1,1);
  %title(['N=',num2str(N)])
  for k=1:J
         subplot(J,1,k);
         stem(details_norms{k},'b','Marker','none','LineWidth',1);%%%%%
         stem(X{k},details_norms{k},'b','Marker','none','LineWidth',1);%%%%%
         ylabel(['scale ',num2str(k)],'interpreter','latex');
         set(gca,'XTickLabel',[]);
         xlim([0, 2*pi]);
         yticklabels = [0, max_norms(k)];
         set(gca, 'xtick', [0, 2*pi]);
         set(gca,'YTick', yticklabels);
         set(gca,'fontsize',24);
         set(gca, 'Box', 'off');
         %set(get(gca,'ylabel'),'rotation',60);
  end
  set(gcf,'position',[10,10,1000,800]);
