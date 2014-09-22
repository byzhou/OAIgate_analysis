function eqz_plot();

EDP_eqz_path    = '../EDP_data/OAI21X2_eqz.dat';

data_eqz        = load ( EDP_eqz_path , '-regexp',...
                    '%e %f %f %e\n');

volt            = data_eqz(:,1);
DFE_width_ratio = data_eqz(:,2);
FA_width_ratio  = data_eqz(:,3);
EDP             = data_eqz(:,4);

%plot( DFE_width_ratio( 1 : 10) , EDP( 1 : 10 ));
for i = 1 : 10
    for j = 1 : 10
        EDP_data (i , j)    = EDP ( ( i - 1 ) * 10 + j);
    end
end

DFE             = 1 : 10;
FA              = 0.1 : 0.1 : 1;

contourf ( DFE , FA , EDP_data );
title({'Contour of OAI Gate working under 400mV',...
         'Original Desgin EDP 1.509259606e-07 Optimized New Design EDP 1.308663214e-07'},...
         'FontSize', 15, 'fontWeight', 'bold');
xlabel ('DFE width ratio to 630 / 415 inverter');
ylabel ('FA width ratio to 630 / 415 inverter');
whitebg('white');

