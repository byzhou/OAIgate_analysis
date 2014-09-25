function y = EDP_eqz ( bitnum , period , sampleRate, volt , DFE_str, FA_ratio);
%bitnum         -> number of bits for testing
%period         -> time period
%sampleRate     -> sample rate
%volt           -> volt
%FA_ratio       -> function assurance ratio
format longeng;

%record start time
start_time=datestr(now,'mm-dd-yyyy HH:MM:SS FFF');

addpath('/home/bobzhou/Desktop/571/research/hspice_toolbox/HspiceToolbox/');
fprintf('Hspice tool box has been successfully loaded.\n');

data_path   = '../hspice_data/OAI21_eqz_nangate45.tr0';
srcA_path   = '../vsrc_files/function_check_vsrc_a_0.txt';
srcB1_path  = '../vsrc_files/function_check_vsrc_b1_0.txt';
srcB2_path  = '../vsrc_files/function_check_vsrc_b2_0.txt';

x           = loadsig(data_path);

%This is getting source info.

data_srcA   = load ( srcA_path , '-regexp' , '%d %d\n' );
data_srcB1  = load ( srcB1_path , '-regexp' , '%d %d\n' );
data_srcB2  = load ( srcB2_path , '-regexp' , '%d %d\n' );

time_srcA   = data_srcA(:,1) / 1e9;
time_srcB1  = data_srcB1(:,1) / 1e9;
time_srcB2  = data_srcB2(:,1) / 1e9;

volt_srcA   = data_srcA(:,2);
volt_srcB1  = data_srcB1(:,2);
volt_srcB2  = data_srcB2(:,2);

vdd             = volt;

%This is getting the signal info.
time            = evalsig(x , 'TIME');
Energy          = evalsig(x , 'vpower');
buff_input_a    = evalsig(x , 'a');
buff_input_b1   = evalsig(x , 'b1');
buff_input_b2   = evalsig(x , 'b2');

buff_output_a   = evalsig(x , 'a_in');
buff_output_b1  = evalsig(x , 'b1_in');
buff_output_b2  = evalsig(x , 'b2_in');

gate_output     = evalsig(x , 'output');

%Delay calculation initialization
i               = 1;
j               = 1;
k               = 1;
infi            = 10000;

delay           = 0;
previous_result = 0;
current_result  = 0;
transition      = 0;

for i = 2 : (bitnum - 1) 

    %move the buffer time pointer and the output time pointer to the start point of current signal.
    while ((time(j) < (i * period)) & (j < size(time , 1)) & (time(j) < (bitnum  * period)))
        j = j + 1;
    end

    while ((time(k) < (i * period)) & (k < size(time , 1)) & (time(k) < (bitnum  * period)))
        k = k + 1;
    end
    
    %Detect the signal start time point at the buffer output
    if (buff_output_a(i) == 1) & (buff_output_a(i + 1) == 0)
        while (k < size(time , 1)) & (time(j) < period * bitnum) & (buff_output_a(j) > (vdd / 2))
            k = k + 1;
        end
    elseif  (buff_output_a(i) == 0) & (buff_output_a(i + 1) == 1)
        while (k < size(time , 1)) & (time(j) < period * bitnum) & (buff_output_a(j) < (vdd / 2))
            k = k + 1;
        end
    elseif  (buff_output_b1(i) == 1) & (buff_output_b1(i + 1) == 0)
        while (k < size(time , 1)) & (time(j) < period * bitnum) & (buff_output_b1(j) > (vdd / 2))
            k = k + 1;
        end
    elseif  (buff_output_b1(i) == 0) & (buff_output_b1(i + 1) == 1)
        while (k < size(time , 1)) & (time(j) < period * bitnum) & (buff_output_b1(j) < (vdd / 2))
            k = k + 1;
        end
    elseif  (buff_output_b2(i) == 1) & (buff_output_b2(i + 1) == 0)
        while (k < size(time , 1)) & (time(j) < period * bitnum) & (buff_output_b2(j) > (vdd / 2))
            k = k + 1;
        end
    elseif  (buff_output_b2(i) == 0) & (buff_output_b2(i + 1) == 1)
        while (k < size(time , 1)) & (time(j) < period * bitnum) & (buff_output_b2(j) < (vdd / 2))
            k = k + 1;
        end
    end

    %Calculate the delay by first generating a pseudo-signal. Compare the time point of the actual signal 
    %with this signal
    previous_result     =  ~((volt_srcB1(i)  | volt_srcB2(i)) & volt_srcA(i));
    current_result      =  ~((volt_srcB1(i + 1) | volt_srcB2(i + 1)) & volt_srcA(i + 1));

    if (current_result & ~previous_result) ...

        %Previous output is 0 and current output is 1.
        while ((j < size(time , 1)) & (time(j) < period * bitnum) & (gate_output(j) < (vdd / 2)))
            j = j + 1;
        end
        
        %The output detector will goes to infinity after it mets the last transition. To prevent that becomes
        %a part of the delay, the delay calculation should exclude that.
        if ((j < size(time , 1)) & (time(j) < period * bitnum))
            delay = delay + time(j) - time(k);
        end

        %Calculate the transition times of one single experiment.
        transition = transition + 1;

    elseif (~current_result & previous_result) ...

        %Previous output is 1 and current output is 0.
        %Similar approach as the transition from 0 to 1.
        while (j < size(time , 1)) & (time(j) < period * bitnum) & (gate_output(j) > (vdd / 2)) 
            j = j + 1;
        end

        if ((j < size(time , 1)) & (time(j) < period * bitnum))
            delay = delay + time(j) - time(k);
        end

        transition = transition + 1;
    end
end

fprintf('The average delay is %5.12e. \n', delay / transition);
%energy consumption
energy_consump  = Energy ( size ( Energy , 1 ) ) * vdd * ( 1e-12 ) / period *( bitnum) ;
	
%record end time
end_time        = datestr(now,'mm-dd-yyyy HH:MM:SS FFF');

%calculate EDP
EDP             = (delay / bitnum * energy_consump);

%display the start and end time
disp(strcat('Start times----------------',start_time));
disp(strcat('End times------------------',end_time));

%display energy consumption
disp(strcat('file_path------------------',data_path));
fprintf(strcat('Delay_avg------------------',int2str(delay / bitnum), '%5.12e \n'), delay / transition);
disp(strcat('energy consumption---------',num2str(energy_consump)));
fprintf('EDP------------------------%5.9e\n', EDP);

%write EDP results to the file
path = '../EDP_data/OAI21X2_eqz.dat';
fid = fopen ( path , 'a' );

if (fid == -1)
    fprintf('The file here %s can not be opened.\n', path);
else
    fprintf('The file here %s has succussfully opened. \n', path);
end

fprintf ( fid , '%d %5.5f %5.5f %5.9e\n', volt , DFE_str, FA_ratio, EDP);

if (fclose(fid) == 0)
    fprintf ('File %s written successfuly!\n', path);
else
    fprintf ('ERROR: Cannot close file %s! Now exiting\n', path);
end

