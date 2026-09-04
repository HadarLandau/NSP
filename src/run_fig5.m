%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RUN_FIG5                                                              %
%                                                                       %
% This script performs a multiscale analysis of three noisy versions    %
% of the sampled unit circle, as shown in Figure 5.                     %
%                                                                       %
% Steps:                                                                %
%   1. A set of N = 256 equidistant sample points is generated from     %
%      the unit circle with a wavy distortion of amplitude sigma = 0.3. %
%   2. A mildly oscillatory version is generated using the base mode    %
%      with amplitude sigma = 0.1.                                      %
%   3. A more strongly oscillatory version is generated using the base  %
%      mode with amplitude sigma = 0.3.                                 %
%   4. Four levels of multiscale analysis are performed on each data    %
%      set using the decomposition procedure described in the paper.    %
%   5. The resulting detail coefficients and coarse data are plotted.   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate the sampled data with different types and levels of distortion
f_samples_semicircle=NSP_2D_get_samples (256,0.3,'wavy');      % wavy-distorted data
f_samples_lessnoisycircle=NSP_2D_get_samples (256,0.1,'base'); % mildly oscillatory data
f_samples_noisycircle=NSP_2D_get_samples (256,0.3,'base');     % more strongly oscillatory data

% perform four levels of multiscale analysis
NSP_2D_padded_decomposition3 (f_samples_semicircle, 4, 'fig5', 1);
NSP_2D_padded_decomposition3 (f_samples_lessnoisycircle, 4, 'fig5', 1);
NSP_2D_padded_decomposition3 (f_samples_noisycircle, 4, 'fig5', 1);