%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RUN_FIG2                                                            %
%                                                                     %
% This script displays the coefficients of the first four decimation  %
% operators shown in Figure 2.                                        %
%                                                                     %
% Steps:                                                              %
%   1. The even and odd refinement masks of the non-stationary        %
%      generalization of the cubic B-spline scheme are generated      %
%      using a chosen parameter theta.                                %
%   2. The associated decimation masks gamma^(l) are computed from    %
%      the even masks.                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate refinement masks for theta = 10
% mask_ev  - even refinement masks
% mask_odd - odd refinement masks
[mask_ev, mask_odd]=NSP_create_mask_cubic(10);

% compute the decimation masks gamma^(l)
% the parameter 15 sets the truncation precision for small coefficients
gamma=NSP_find_gamma(mask_ev,15);