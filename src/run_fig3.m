%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RUN_FIG3                                                             %
%                                                                      %
% This script compares non-stationary geometric subdivision with       %
% stationary B-spline refinement, as shown in Figure 3.                %
%                                                                      %
% Steps:                                                               %
%   1. A set of N = 16 equidistant sample points is generated from     %
%      the unit circle.                                                %
%   2. The non-stationary geometric refinement masks are constructed   %
%      using the parameter v = cos(2π/N).                              %
%   3. A stationary refinement scheme is defined using uniform         %
%      cubic B-spline masks.                                          %
%   4. Three levels of refinement are applied using both schemes.      %
%   5. The resulting refined point sets are displayed for comparison.  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate initial sampled data (unit circle, no noise)
f_samples=NSP_2D_get_samples (16, 0, 'base');

% construct geometric non-stationary subdivision masks,
% the parameter initial_v is chosen according to v = cos(2π/N)
[a1_ev, a1_odd]=NSP_create_mask_a1 (cos(2*pi/16));

% construct uniform cubic B-spline masks (stationary scheme)
CBS_ev=cell(6,1);
CBS_odd=cell(6,1);

for k=1:6
    CBS_ev{k}=[0.125 ; 0.75; 0.125];    % even mask
    CBS_odd{k}=[0.5 0.5];               % odd mask
end

% perform refinement using geometric (non-stationary) scheme
geometric_refined=NSP_2D_refinements (f_samples, 3, a1_ev, a1_odd);

% perform refinement using B-spline (stationary) scheme
B_spline_refined=NSP_2D_refinements (f_samples, 3, CBS_ev, CBS_odd);