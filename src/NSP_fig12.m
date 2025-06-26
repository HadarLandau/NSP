[mask_ev_i,mask_odd_i]=NSP_create_mask (i);
[mask_ev_3i,mask_odd_3i]=NSP_create_mask (3i);
[mask_ev_5i,mask_odd_5i]=NSP_create_mask (5i);
[mask_ev_7i,mask_odd_7i]=NSP_create_mask (7i);

ri=NSP_refinements ([0 0  0 1 0 0 0 ]', 5, mask_ev_i, mask_odd_i);
r3i=NSP_refinements ([0 0  0 1 0 0  0]', 5, mask_ev_3i, mask_odd_3i);
r5i=NSP_refinements ([0 0  0 1 0 0  0]', 5, mask_ev_5i, mask_odd_5i);
r7i=NSP_refinements ([0 0 1 0  0]', 5, mask_ev_7i, mask_odd_7i);

figure
  N=5; %N is odd
  x_data_for_f=-3:3;
  plot(x_data_for_f,[0 0 0.5  1 0.5  0 0],'r-*')
  hold on
  x_data=-3:2^(-5):3;
  length(x_data)
  length(ri{6})
  plot(x_data,ri{6},'k')
  plot(x_data,r3i{6},'k')
  plot(x_data,r5i{6},'k')
  plot(x_data,r7i{6},'k')
