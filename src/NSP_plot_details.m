% figures 4-7,9

function [] = NSP_plot_details (details)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function visualizes the detail coefficients from a multiscale transform. %
% It computes the Euclidean norm of the detail vectors at each scale            %
% and plots them as stem plots, one subplot per scale, for visual comparison.   %
%                                                                               %
% Input:                                                                        %
%   details - a cell array of length J, where each cell contains a matrix       %
%             representing detail coefficients at a given scale. Each matrix    %
%             is of size (#coefficients x dimension), e.g. (N x 2).             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % number of decomposition scales
  J=length(details);

  % create equally spaced sampling points in [0, 2*pi] for current scale
  X=cell(J,1);
  for j = 1:J
     X{j}=linspace(0,2*pi,length(details{j}))';
  end

  % preallocate arrays for detail norms and their maximum values
  details_norms=cell(J,1);
  max_norms=zeros(J,1);

  % compute the Euclidean norm of the detail vectors at each scale
  % and store the maximum norm
  for k=1:J
    details_norms{k}=sqrt(sum(details{k}.^2,2));
    max_norms(k)=max(details_norms{k});
  end

  % plot
  figure

  % plot each set of norms in a subplot
  for k=1:J
         subplot(J,1,k);
         
         % plot the detail norms as a stem plot
         stem(X{k},details_norms{k},'b','Marker','none','LineWidth',1);

         % label the y-axis with the corresponding scale number
         ylabel(['scale ',num2str(k)],'interpreter','latex');

         % remove x-axis tick labels
         set(gca,'XTickLabel',[]);

         % set consistent x-axis limits to match [0, 2*pi]
         xlim([0, 2*pi]);

         % set y-axis ticks to show only 0 and the max norm
         yticklabels = [0, max_norms(k)];
         set(gca, 'xtick', [0, 2*pi]);
         set(gca,'YTick', yticklabels);

         % adjust font size and remove box around subplot
         set(gca,'fontsize',24);
         set(gca, 'Box', 'off');
  end

  % set the figure size and position on screen
  set(gcf,'position',[10,10,1000,800]);
end