[mask_ev_3,mask_odd_3]=NSP_create_mask (3);
[mask_ev_25,mask_odd_25]=NSP_create_mask (2.5);
[mask_ev_2,mask_odd_2]=NSP_create_mask (2);
[mask_ev_0,mask_odd_0]=NSP_create_mask (0);

r3=NSP_refinements ([0 0 1 0 0]', 5, mask_ev_3, mask_odd_3);
r25=NSP_refinements ([0 0 1 0 0]', 5, mask_ev_25, mask_odd_25);
r2=NSP_refinements ([0 0 1 0 0]', 5, mask_ev_2, mask_odd_2);
r0=NSP_refinements ([0 0 1 0 0]', 5, mask_ev_0, mask_odd_0);

figure
  N=5; %N is odd
  x_data_for_f=-2:2;
  plot(x_data_for_f,[0 0 1 0 0],'r-*')
  hold on
  x_data=-2:2^(-5):2;
  plot(x_data,r3{6},'k')
  plot(x_data,r25{6},'k')
  plot(x_data,r2{6},'k')
  plot(x_data,r0{6},'k')
