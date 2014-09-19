function y = EDP ( bitnum , period , sampleRate );
%bitnum         -> number of bits for testing
%period         -> time period
%sampleRate     -> sample rate
format longeng;

%uniform buffer delay is not included

%record start time
start_time=datestr(now,'mm-dd-yyyy HH:MM:SS FFF');

addpath('/home/bobzhou/Desktop/571/research/hspice_toolbox/HspiceToolbox/');
fprintf('Hspice tool box has been successfully loaded.\n');

data_path   = '../hspice_data/OAI21_nangate45.tr0';
srcA_path   = '../vsrc_files/function_check_vsrc_a_0.txt';
srcB1_path  = '../vsrc_files/function_check_vsrc_b1_0.txt';
srcB2_path  = '../vsrc_files/function_check_vsrc_b2_0.txt';

x           = loadsig(data_path);

%This is getting source info.

data_srcA   = load ( srcA_path , '-regexp' , '%d %d\n' );
data_srcB1  = load ( srcA_path , '-regexp' , '%d %d\n' );
data_srcB2  = load ( srcA_path , '-regexp' , '%d %d\n' );

time_srcA   = data_srcA(:,1) / 1e9;
time_srcB1  = data_srcB1(:,1) / 1e9;
time_srcB2  = data_srcB2(:,1) / 1e9;

volt_srcA   = data_srcA(:,2);
volt_srcB1  = data_srcB1(:,2);
volt_srcB2  = data_srcB2(:,2);

vdd             = 1;

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

%calculate delay
i               = 1;
j               = 1;
k               = 0;
infi            = 10000;

%matching sequency
%while (i < size(time_srcA)) & ((i + j) < size(time_srcA)) if ~(gate_output (i * sampleRate) == ...
%        ~((strcmp (volt_srcB1 (i + j), 'V_hig') | strcmp (volt_srcB2(i + j),'V_hig'))...
%        | strcmp (volt_srcB1 (i + j), 'V_hig')))
%        j = j + 1;
%    else 
%        i = i + 1;
%    end
%end

%if (j > size( time_srcA ) / 2)
%    printf('Output cannot be evalued\n');
%    delay = infi;
%else
%    fprintf('Delay has reached %d cycles.\n', j);
%end

%calculate the fine resolution
delay           = 0;
previous_result = 0;
current_result  = 0;


for i = 2 : (bitnum - 1) 

    while ((time(j) < (i * period)) & (j < size(time , 1)) & (time(j) < (bitnum  * period)))
        j = j + 1;
    end

    previous_result     =  ~(((volt_srcB1(i) == 1) | (volt_srcB2(i) == 1))...
                            & (volt_srcA(i) == 1));
    current_result      =  ~(((volt_srcB1(i + 1) == 1) | (volt_srcB2(i + 1) == 1))...
                            & (volt_srcA(i + 1) == 1));

    fprintf('voltage A %d, voltage B1 %d, voltage B2 %d\n', volt_srcA(i), volt_srcB1(i), volt_srcB2(i));
%    fprintf('previous_result %d, current_result %d, gate_output %d\n', previous_result, current_result, gate_output(i));
%    fprintf('rule %d\n ', (j < size(time,1)))% , (time(j) < (period * bitnum)) , (gate_output(j) < vdd / 2));

    if (current_result & ~previous_result) ...
        %Previous output is 0 and current output is 1
        while (j < size(time , 1)) & (time(j) < period * bitnum) & (gate_output(j) < (vdd / 2))
            j = j + 1;
        end
        delay = delay + time(j) - i * period;
        %fprintf('time j %5.9e %5.9e \n', time(j), period * i);
        fprintf('Current time is %5.9e, The delay is %5.9e. And the ref %5.9e. Gate output is %5.9e\n', time(j), time(j) - i * period, i * period, gate_output(j));

    elseif (~current_result & previous_result) ...
        %Previous output is 1 and current output is 0 
        while (j < size(time , 1)) & (time(j) < period * bitnum) & (gate_output(j) > (vdd / 2)) 
            j = j + 1;
        end
        delay = delay + time(j) - i * period;
        %fprintf('time j %5.9e %5.9e \n', time(j), period * i);
        fprintf('Current time is %5.9e, The delay is %5.9e. And the ref %5.9e. Gate output is %5.9e\n', time(j), time(j) - i * period, i * period, gate_output(j));

    end

    %fprintf('The value of j is %d \n', j);
    %fprintf('Single Delay of one sim is %5.9f. \n', delay * 1e9);
end

fprintf('The average delay is %5.12e. \n', delay / (bitnum));
%energy consumption
energy_consump = Energy ( size ( Energy , 1 ) ) * vdd * ( 1e-12 ) / period *( bitnum) ;
	
%record end time
end_time=datestr(now,'mm-dd-yyyy HH:MM:SS FFF');

%display the start and end time
disp(strcat('Start times----------------',start_time));
disp(strcat('End times------------------',end_time));

%display energy consumption
disp(strcat('file_path------------------',data_path));
fprintf(strcat('Delay_avg------------------',int2str(delay / bitnum), '%5.12e \n'), delay / (bitnum));
disp(strcat('energy consumption---------',num2str(energy_consump)));
fprintf('EDP------------------------%5.9e\n', (delay / bitnum * energy_consump));

