function y=sample_result(voltage,frequency);
format longeng;

%not display in command line
%diary my_data.out;
%diary on;
 
%record start time
start_time=datestr(now,'mm-dd-yyyy HH:MM:SS FFF');

%read in data
addpath('/home/bobzhou/Desktop/571/research/hspice_toolbox/HspiceToolbox/');
%x1=loadsig('4KSA_zafar_design_Feedback_Equalization_supply_voltage_530m.tr0');
%x1=loadsig('4KSA_zafar_design_FO2_inverter_paris_supply_voltage_530m.tr0');
%x1=loadsig('4KSA_zafar_design_supply_voltage_520m.tr0');
%x1=loadsig('4KSA_inside_flipflop_design_Feedback_Equalization_supply_voltage_800m.tr0');
%file_path_1= strcat (fName, '_inv_', int2str(j-1), '.dat');
file_path_1 = '16KSA_FO1_design_supply_voltage_800m_500p.tr0';
%file_path_1 = '16KSA_FO1_design_supply_voltage_800m_500p.tr0';
x1          = loadsig(file_path_1);
%perfect result
fName       = '16KSA_FO1_design_supply_voltage';
file_path_2 = strcat (fName, '_',int2str(voltage), 'm_', int2str(frequency), 'p.tr0');
x2          = loadsig(file_path_2);
%file_path_2 = strcat (fName, '.tr0');
%disp(file_path_2);
%x2=loadsig('4KSA_zafar_design_Feedback_Equalization_supply_voltage_800m.tr0');
%x2=loadsig('4KSA_zafar_design_FO2_inverter_paris_supply_voltage_800m.tr0');
%x2=loadsig('4KSA_zafar_design_supply_voltage_800m.tr0');
%x2=loadsig('4KSA_inside_flipflop_design_Feedback_Equalization_supply_voltage_500m.tr0');

%perfect result

%supply voltage
vdd1=0.8;
vdd2=voltage/1000;

t1=evalsig(x1,'TIME');%+50e-12;
vpower=evalsig(x1,'v_vpower');
sum_0=evalsig(x1,'v_q0');
sum_1=evalsig(x1,'v_q1');
sum_2=evalsig(x1,'v_q2');
sum_3=evalsig(x1,'v_q3');
sum_4=evalsig(x1,'v_q4');
sum_5=evalsig(x1,'v_q5');
sum_6=evalsig(x1,'v_q6');
sum_7=evalsig(x1,'v_q7');
sum_8=evalsig(x1,'v_q8');
sum_9=evalsig(x1,'v_q9');
sum_10=evalsig(x1,'v_q10');
sum_11=evalsig(x1,'v_q11');
sum_12=evalsig(x1,'v_q12');
sum_13=evalsig(x1,'v_q13');
sum_14=evalsig(x1,'v_q14');
sum_15=evalsig(x1,'v_q15');
sum_16=evalsig(x1,'v_q16');

t2=evalsig(x2,'TIME');%+50e-12;
pvpower=evalsig(x2,'v_vpower');
psum_0=evalsig(x2,'v_q0');
psum_1=evalsig(x2,'v_q1');
psum_2=evalsig(x2,'v_q2');
psum_3=evalsig(x2,'v_q3');
psum_4=evalsig(x2,'v_q4');
psum_5=evalsig(x2,'v_q5');
psum_6=evalsig(x2,'v_q6');
psum_7=evalsig(x2,'v_q7');
psum_8=evalsig(x2,'v_q8');
psum_9=evalsig(x2,'v_q9');
psum_10=evalsig(x2,'v_q10');
psum_11=evalsig(x2,'v_q11');
psum_12=evalsig(x2,'v_q12');
psum_13=evalsig(x2,'v_q13');
psum_14=evalsig(x2,'v_q14');
psum_15=evalsig(x2,'v_q15');
psum_16=evalsig(x2,'v_q16');

%sample data every peroid
sampling_rate_1=500e-12;
%fprintf('%12.5e\n',sampling_rate_1);

sampling_rate_2     = frequency*1e-12;
sampling_num        = 1e3;
error_num           = 0;
i                   = 1;
j                   = 1;

for sampling_counter=1:1:sampling_num
	
        size_t1 = size(t1);
        size_t2 = size(t2);

		while ((t1(i)<(sampling_counter*sampling_rate_1)) & (i<=(size_t1(1)-1)))
           %fprintf('%12.5e\n',sampling_rate_1);
           %fprintf('%12d\n',sampling_counter);
			i=i+1;
		end

		while ((t2(j)<(sampling_counter*sampling_rate_2)) & (j<=(size_t2(1)-1)))
			j=j+1;
		end
	
		if((sum_0(i-1)+sum_0(i))>vdd1)	    sampled_sum_0=1; else sampled_sum_0=0; end 
		if((sum_1(i-1)+sum_1(i))>vdd1)	    sampled_sum_1=1; else sampled_sum_1=0; end 
		if((sum_2(i-1)+sum_2(i))>vdd1)	    sampled_sum_2=1; else sampled_sum_2=0; end 
		if((sum_3(i-1)+sum_3(i))>vdd1)	    sampled_sum_3=1; else sampled_sum_3=0; end 
		if((sum_4(i-1)+sum_4(i))>vdd1)	    sampled_sum_4=1; else sampled_sum_4=0; end 
		if((sum_5(i-1)+sum_5(i))>vdd1)	    sampled_sum_5=1; else sampled_sum_5=0; end 
		if((sum_6(i-1)+sum_6(i))>vdd1)	    sampled_sum_6=1; else sampled_sum_6=0; end 
		if((sum_7(i-1)+sum_7(i))>vdd1)	    sampled_sum_7=1; else sampled_sum_7=0; end 
		if((sum_8(i-1)+sum_8(i))>vdd1)	    sampled_sum_8=1; else sampled_sum_8=0; end 
		if((sum_9(i-1)+sum_9(i))>vdd1)	    sampled_sum_9=1; else sampled_sum_9=0; end 
		if((sum_10(i-1)+sum_10(i))>vdd1)	sampled_sum_10=1; else sampled_sum_10=0; end 
		if((sum_11(i-1)+sum_11(i))>vdd1)	sampled_sum_11=1; else sampled_sum_11=0; end 
		if((sum_12(i-1)+sum_12(i))>vdd1)	sampled_sum_12=1; else sampled_sum_12=0; end 
		if((sum_13(i-1)+sum_13(i))>vdd1)	sampled_sum_13=1; else sampled_sum_13=0; end 
		if((sum_14(i-1)+sum_14(i))>vdd1)	sampled_sum_14=1; else sampled_sum_14=0; end 
		if((sum_15(i-1)+sum_15(i))>vdd1)	sampled_sum_15=1; else sampled_sum_15=0; end 
		if((sum_16(i-1)+sum_16(i))>vdd1)	sampled_sum_16=1; else sampled_sum_16=0; end 
	
		if((psum_0(j-1)+psum_0(j))>vdd1)	    psampled_sum_0=1; else psampled_sum_0=0; end 
		if((psum_1(j-1)+psum_1(j))>vdd1)	    psampled_sum_1=1; else psampled_sum_1=0; end 
		if((psum_2(j-1)+psum_2(j))>vdd1)	    psampled_sum_2=1; else psampled_sum_2=0; end 
		if((psum_3(j-1)+psum_3(j))>vdd1)	    psampled_sum_3=1; else psampled_sum_3=0; end 
		if((psum_4(j-1)+psum_4(j))>vdd1)	    psampled_sum_4=1; else psampled_sum_4=0; end 
		if((psum_5(j-1)+psum_5(j))>vdd1)	    psampled_sum_5=1; else psampled_sum_5=0; end 
		if((psum_6(j-1)+psum_6(j))>vdd1)	    psampled_sum_6=1; else psampled_sum_6=0; end 
		if((psum_7(j-1)+psum_7(j))>vdd1)	    psampled_sum_7=1; else psampled_sum_7=0; end 
		if((psum_8(j-1)+psum_8(j))>vdd1)	    psampled_sum_8=1; else psampled_sum_8=0; end 
		if((psum_9(j-1)+psum_9(j))>vdd1)	    psampled_sum_9=1; else psampled_sum_9=0; end 
		if((psum_10(j-1)+psum_10(j))>vdd1)	    psampled_sum_10=1; else psampled_sum_10=0; end 
		if((psum_11(j-1)+psum_11(j))>vdd1)	    psampled_sum_11=1; else psampled_sum_11=0; end 
		if((psum_12(j-1)+psum_12(j))>vdd1)	    psampled_sum_12=1; else psampled_sum_12=0; end 
		if((psum_13(j-1)+psum_13(j))>vdd1)	    psampled_sum_13=1; else psampled_sum_13=0; end 
		if((psum_14(j-1)+psum_14(j))>vdd1)	    psampled_sum_14=1; else psampled_sum_14=0; end 
		if((psum_15(j-1)+psum_15(j))>vdd1)	    psampled_sum_15=1; else psampled_sum_15=0; end 
		if((psum_16(j-1)+psum_16(j))>vdd1)	    psampled_sum_16=1; else psampled_sum_16=0; end 

		if( psampled_sum_0~=sampled_sum_0 || ... 
            psampled_sum_1~=sampled_sum_1 || ...
            psampled_sum_2~=sampled_sum_2 || ...
            psampled_sum_3~=sampled_sum_3 || ...
            psampled_sum_4~=sampled_sum_4 || ...
            psampled_sum_5~=sampled_sum_5 || ...
            psampled_sum_6~=sampled_sum_6 || ...
            psampled_sum_7~=sampled_sum_7 || ...
            psampled_sum_8~=sampled_sum_8 || ...
            psampled_sum_9~=sampled_sum_9 || ...
            psampled_sum_10~=sampled_sum_10 || ...
            psampled_sum_11~=sampled_sum_11 || ...
            psampled_sum_12~=sampled_sum_12 || ...
            psampled_sum_13~=sampled_sum_13 || ...
            psampled_sum_14~=sampled_sum_14 || ...
            psampled_sum_15~=sampled_sum_15 || ...
            psampled_sum_16~=sampled_sum_16)

			error_num=error_num+1;
			error_record_i(error_num)=i;
			error_record_j(error_num)=j;
		end

		k(sampling_counter)=t1(i);
		k1(sampling_counter)=t2(j);
		k2(sampling_counter)=sampling_counter*sampling_rate_1;
		k3(sampling_counter)=i;
		k4(sampling_counter)=j;

end	

error_rate=error_num/sampling_counter;

%energy consumption
energy1=vpower(size(vpower,1))*vdd1*(1e-12)/(500e-9)*(1e6)/2;
energy2=pvpower(size(pvpower,1))*vdd2*(1e-12)/(500e-9)*(1e6)/2;
	
%record end time
end_time=datestr(now,'mm-dd-yyyy HH:MM:SS FFF');

%turn on the display
%diary off;
%clc;

%display the start and end time
disp(strcat('Start times----------------',start_time));
disp(strcat('End times------------------',end_time));

%display result
disp(strcat('file_path_1----------------',file_path_1));
disp(strcat('error rates----------------',num2str(error_rate)));

%display energy consumption
disp(strcat('file_path_1----------------',file_path_1));
disp(strcat('energy consumption 1-------',num2str(energy1)));
disp(strcat('file_path_2----------------',file_path_2));
disp(strcat('energy consumption 2-------',num2str(energy2)));
