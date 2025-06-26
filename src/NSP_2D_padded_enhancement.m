function [enhanced_data] = NSP_2D_padded_enhancement (padded_c_0, padded_details)

  J=length(padded_details);

  %enhancing the details bigger than the treshold
  treshold=0.4 ;
  F=25 ; %factor

  new_details=cell(J,1);
  for l=1:J
    d=padded_details{l};
    for j=1:length(d)
      if abs(d(j))>treshold
        d(j)=F*d(j);
      end
    end
    new_details{l}=d;
  end

  %reconstructing the enhanced data
  enhanced_data=NSP_2D_padded_reconstruction (padded_c_0, new_details);

