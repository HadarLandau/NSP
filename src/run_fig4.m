%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RUN_FIG4                                                            %
%                                                                     %
% This script performs a multiscale analysis of sampled data from     %
% the unit circle, as shown in Figure 4.                              %
%                                                                     %
% Steps:                                                              %
%   1. A set of N = 256 equidistant sample points is generated from   %
%      the unit circle.                                               %
%   2. Four levels of multiscale analysis are performed using the     %
%      decomposition procedure described in the paper.                %
%   3. The resulting detail coefficients are plotted, along with the  %
%      coarse data obtained from the decomposition process.           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate initial sampled data from the unit circle
f_samples_circle=NSP_2D_get_samples (256,0,'base');

% perform four levels of multiscale analysis
NSP_2D_padded_decomposition3 (f_samples_circle, 4, 'fig4', 1);