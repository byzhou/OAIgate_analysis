function y = EDP ( bitnum , period , sampleRate );
%bitnum         -> number of bits for testing
%period         -> time period
%sampleRate     -> sample rate
format longeng;

%record start time
start_time=datestr(now,'mm-dd-yyyy HH:MM:SS FFF');

addpath('/home/bobzhou/Desktop/571/research/hspice_toolbox/HspiceToolbox/');
fprintf('Hspice tool box has been successfully loaded.\n');

data_path   = '/home/bobzhou/Desktop/571/research/2014_fall/singleGateMeasure/hspice_data/test_data.tr0';
srcA_path   = '/home/bobzhou/Desktop/571/research/2014_fall/singleGateMeasure/vsrc_files/function_check_vsrc_a_0.dat';
srcB1_path  = '/home/bobzhou/Desktop/571/research/2014_fall/singleGateMeasure/vsrc_files/function_check_vsrc_b1_0.dat';
srcB2_path  = '/home/bobzhou/Desktop/571/research/2014_fall/singleGateMeasure/vsrc_files/function_check_vsrc_b2_0.dat';

x           = loadsig(data_path);

%This is getting source info.

fid_vsrcA   = fopen ( srcA_path , 'r' );
fid_vsrcB1  = fopen ( srcB1_path , 'r' );
fid_vsrcB2  = fopen ( srcB2_path , 'r' );

if (fid_vsrcA == -1)
    fprintf('ERROR: Cannot open %s to read! Now exiting', srcA_path);
end

if (fid_vsrcB1 == -1)
    fprintf('ERROR: Cannot open %s to read! Now exiting', srcB1_path);
end

if (fid_vsrcB2 == -1)
    fprintf('ERROR: Cannot open %s to read! Now exiting', srcB2_path);
end

data_srcA   = fscanf(fid_vsrcA, '%5.9e %s ', Inf)
data_srcB1  = fscanf(fid_vsrcB1, '%5.9e %s', bitnum);
data_srcB2  = fscanf(fid_vsrcB2, '%5.9e %s', bitnum);

time_srcA   = data_srcA(1) 
time_srcB   = data_srcB1(:,1);
time_srcB   = data_srcB2(:,1);

volt_srcA   = data_srcA(:,2);
volt_srcB   = data_srcB1(:,2);
volt_srcB   = data_srcB2(:,2);

vdd             = 1;

%This is getting the signal info.
time            = evalsig(x , 'TIME');
Energy          = evalsig(x , 'v_Vpower');
buff_input_a    = evalsig(x , 'v_a');
buff_input_b1   = evalsig(x , 'v_b1');
buff_input_b2   = evalsig(x , 'v_b2');

buff_output_a   = evalsig(x , 'v_a_in');
buff_output_b1  = evalsig(x , 'v_b1_in');
buff_output_b2  = evalsig(x , 'v_b2_in');

gate_output     = evalsig(x , 'v_output');

%calculate delay
i               = 0;
j               = 0;
infi            = 10000;
%matching sequency
while (i < size(time_srcA)) & ((i + j) < size(time_srcA)) 
    if ~(gate_output (i * sampleRate) == ...
        ~((strcmp (volt_srcB1 (i + j), 'V_hig') | strcmp (volt_srcB2(i + j),'V_hig'))...
        | strcmp (volt_srcB1 (i + j), 'V_hig')))
        j = j + 1;
    else 
        i = i + 1;
    end
end

if (j > size( time_srcA ) / 2)
    printf('Output cannot be evalued');
    delay = infi;
else
    printf('Delay has reached %d cycles', j);
end

%calculate the fine resolution
delay           = 0;
for i = 2 : size(time_srcA)
    if (~((strcmp(volt_srcB1(i - 1),'V_hig') | strcmp(volt_srcB2(i - 1),'V_hig'))...
        | strcmp(volt_srcB1(i - 1),'V_hig')) & ...
        ((strcmp(volt_srcB1(i),'V_hig') | strcmp(volt_srcB2(i),'V_hig'))...
        | strcmp(volt_srcB1(i),'V_hig')))
        %Previous output is 1 and current output is 0
        k = 0;
        while (time(k + (i + j - 1) * 10) < time_srcA(i)) ...
            & (gate_output(k + (i + j - 1) * 10) > vdd/2)
            k = k + 1;
        end
        delay = delay + period * (i + j - 1) + period * k / 10;
    elseif ...
        (((strcmp(volt_srcB1(i - 1),'V_hig') | strcmp(volt_srcB2(i - 1),'V_hig'))...
        | strcmp(volt_srcB1(i - 1),'V_hig')) & ...
        ~((strcmp(volt_srcB1(i),'V_hig') | strcmp(volt_srcB2(i),'V_hig'))...
        | strcmp(volt_srcB1(i),'V_hig')))
        %Previous output is 0 and current output is 1 
        k = 0;
        while (time(k + (i + j - 1) * 10) < time_srcA(i)) ...
            & (gate_output(k + (i + j - 1) * 10) < vdd/2)
            k = k + 1;
        end
        delay = delay + period * (i + j - 1) + period * k / 10;
    end
end

printf('The average delay is %d.', delay / bitnum);
%energy consumption
energy_consump = Energy ( size ( vpower , 1 ) ) * vdd * ( 1e-12 ) / period *( bitnum ) ;
	
%record end time
end_time=datestr(now,'mm-dd-yyyy HH:MM:SS FFF');


%display the start and end time
disp(strcat('Start times----------------',start_time));
disp(strcat('End times------------------',end_time));


%display energy consumption
disp(strcat('file_path------------------',data_path));
disp(strcat('Delay_avg------------------',delay / bitnum));
disp(strcat('energy consumption---------',num2str(energy_consump)));

