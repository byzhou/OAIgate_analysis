function eqz_plot();
%This function is very specific contour plot drawing. It only draws with specific
%amount of data points

EDP_eqz_path    = '../EDP_data/OAI21X2_eqz.dat';

data_eqz        = load ( EDP_eqz_path , '-regexp',...
                    '%e %f %f %e\n');

volt            = data_eqz(:,1);
DFE_width_ratio = data_eqz(:,2);
FA_width_ratio  = data_eqz(:,3);
EDP             = data_eqz(:,4);

%plot( DFE_width_ratio( 1 : 10) , EDP( 1 : 10 ));
%Read in the data
for i = 1 : 10
    for j = 1 : 10
        EDP_data (i , j)    = (EDP ( ( i - 1 ) * 10 + j));
    end
end

DFE             = 1 : 10;
FA              = 0.2 : 0.1 : 1.1;

contourf (  FA,  DFE, EDP_data , 20, '-.');
title({'Contour of OAI Gate working under 400mV',...
         'Original Desgin EDP 3.562305649e-11  Optimized New Design EDP 9.313121542e-11'},...
         'FontSize', 15, 'fontWeight', 'bold');
xlabel ({'FA width ratio to 630 / 415 inverter'},'FontSize', 15, 'fontWeight', 'bold');
ylabel ({'DFE width ratio to 630 / 415 inverter'},'FontSize', 15, 'fontWeight', 'bold');
whitebg('white');

