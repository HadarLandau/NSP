function [] = NSP_denoising (data, J, all_alpha_ev, all_alpha_odd, all_shifts, treshold)

  %getting the pyramid
  [c_0, details]=NSP_padded_decomposition (data, J, all_alpha_ev, all_alpha_odd, all_shifts);

  %ploting the details
  NSP_plot_details(details);

  %tresholding the details
  denoised_details=cell(J,1);
  for l=1:J
    d=details{l};
    for j=1:length(d)
      if abs(d(j))<treshold
        d(j)=0;
      end
    end
    denoised_details{l}=d;
  end

  %ploting the denoised details
  NSP_plot_details(denoised_details);

  %reconstructing the denoised data
  reconstructed_data=NSP_reconstruction (c_0, denoised_details, all_alpha_ev, all_alpha_odd);

  %getting the reconstructed denoised pyramid
  [reconstructed_c_0, reconstructed_details]=NSP_padded_decomposition (reconstructed_data, J, all_alpha_ev, all_alpha_odd, all_shifts);

  %ploting the reconstructed denoised details
  NSP_plot_details(reconstructed_details);

  %plot
  figure
  istart=1; N=257;
  x_data=istart:2^(-J):istart+(N-1)*2^(-J);
  plot(x_data, reconstructed_data)
