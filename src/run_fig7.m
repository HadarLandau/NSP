%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RUN_FIG7                                                             %
%                                                                      %
% This script performs a multiscale analysis of a unit circle with a   %
% localized oscillatory distortion, as shown in Figure 7.              %
%                                                                      %
% Steps:                                                               %
%   1. A set of N = 256 equidistant sample points is generated from    %
%      the unit circle with a localized oscillatory distortion of      %
%      amplitude sigma = 0.3.                                          %
%   2. Four levels of multiscale analysis are performed using the      %
%      decomposition procedure described in the paper.                 %
%   3. The resulting detail coefficients and coarse data are plotted.  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate the sampled data with localized oscillatory distortion with
% amplitude sigma = 0.3
f_samples_qrtrnoisycircle=NSP_2D_get_samples(256,0.3,'qrtr'); 

% perform four levels of multiscale analysis and plot the results
NSP_2D_padded_decomposition(f_samples_qrtrnoisycircle, 4, 'fig7', 1);