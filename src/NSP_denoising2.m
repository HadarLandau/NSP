function [] = NSP_denoising2 (data, J, all_alpha_ev, all_alpha_odd, all_shifts)
  %instead of tresholding we ommite the last level of the details

  %getting the pyramid
  [c_0, details, padded_c_0, padded_details]=NSP_padded_decomposition (data, J, all_alpha_ev, all_alpha_odd, all_shifts);

  %ploting the details
 % NSP_plot_details(details);

  %'ommitting' the last levels of the details, both in the padded and in the not padded details
  denoised_details=cell(J,1);
  for l=1:J-2
    denoised_details{l}=details{l};
  end
  denoised_details{J-1}=zeros(size(details{J-1}));
  denoised_details{J}=zeros(size(details{J})); %instead of ommitting the last level, we zeroing(?) it,
                                               % so the reconstruction will fit c_0 which corresponds to J
                                               % levels of refinement
  denoised_padded_details=cell(J,1);
  for l=1:J-2
    denoised_padded_details{l}=padded_details{l};
  end
  denoised_padded_details{J-1}=zeros(size(padded_details{J-1}));
  denoised_padded_details{J}=zeros(size(padded_details{J}));

  %ploting the denoised details
 % NSP_plot_details(denoised_details);

  %reconstructing the denoised data
  reconstructed_data=NSP_padded_reconstruction (padded_c_0, denoised_padded_details, all_alpha_ev, all_alpha_odd);

  %getting the reconstructed denoised pyramid
  [reconstructed_c_0, reconstructed_details,~,~]=NSP_padded_decomposition (reconstructed_data, J, all_alpha_ev, all_alpha_odd, all_shifts);

  %ploting the reconstructed denoised details
 % NSP_plot_details(reconstructed_details);

  %plot
  figure
  istart=1; N=257; K=6;
  f=@(x) sin(4*(x-1)*pi/(N*2^-(K+1)));
  x_data_for_f=istart:2^(-10):istart+(N-1)*2^(-K);
  plot(x_data_for_f,f(x_data_for_f),'Color','k','LineWidth',1.5)
  hold on
  x_data=istart:2^(-J):istart+(N-1)*2^(-J);
  plot(x_data, data, '.','MarkerSize',13,'Color','b', x_data, reconstructed_data,'Color','r','LineWidth',1.5)
  legend('original function','data','reconstructed_data')
