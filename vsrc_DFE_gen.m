function  vsrc_DFE_gen ( bitnum , period , sampleRate);
%bitnum         -> number of bits for testing
%period         -> time period
%sampleRate     -> sample rate

%This is only for DFE signal generation
%I guess that is not that useful in the future, since we prove that
%DFE is not useful.
format longeng;

%Read in the voltage source signal file. These files have not been interpolated.
srcA_path   = '../vsrc_files/function_check_vsrc_a_0.txt';
srcB1_path  = '../vsrc_files/function_check_vsrc_b1_0.txt';
srcB2_path  = '../vsrc_files/function_check_vsrc_b2_0.txt';
%Path of DFE signal
srcDFE_path = '../vsrc_files/vsrc_DFE_0_cadence.dat';
pDFE_path   = '../vsrc_files/vsrc_DFE_0.dat';

data_srcA   = load ( srcA_path , '-regexp' , '%d %d\n' );
data_srcB1  = load ( srcB1_path , '-regexp' , '%d %d\n' );
data_srcB2  = load ( srcB2_path , '-regexp' , '%d %d\n' );
fid_cds     = fopen( srcDFE_path , 'w' );
fid         = fopen( pDFE_path , 'w' );

time_srcA   = data_srcA(:,1) / 1e9;
time_srcB1  = data_srcB1(:,1) / 1e9;
time_srcB2  = data_srcB2(:,1) / 1e9;

volt_srcA   = data_srcA(:,2);
volt_srcB1  = data_srcB1(:,2);
volt_srcB2  = data_srcB2(:,2);

fprintf( fid , '%s %s %s PWL', 'v12', 'DFE' , '0');

currTime    = 0;
for j = 1 : sampleRate

    currVolt = 'V_hig';
    currTime = currTime + 1e-15;
    fprintf( fid_cds , '%5.9e %s\n', currTime , currVolt);
    fprintf( fid , '+ %5.9e %s\n', currTime , currVolt);
    currTime = currTime + period / sampleRate - 1e-15;
    fprintf( fid_cds , '%5.9e %s\n', currTime , currVolt);
    fprintf( fid , '+ %5.9e %s\n', currTime , currVolt);

end

for i = 2 : bitnum

    if ((volt_srcB1(i - 1) | volt_srcB2(i - 1)) & volt_srcA(i - 1))
        currVolt = 'V_hig';
    else
        currVolt = 'V_low';
    end

    for j = 1 : sampleRate

        currTime = currTime + 1e-15;
        fprintf( fid_cds , '%5.9e %s\n', currTime , currVolt);
        fprintf( fid , '+ %5.9e %s\n', currTime , currVolt);
        currTime = currTime + period / sampleRate - 1e-15;
        fprintf( fid_cds , '%5.9e %s\n', currTime , currVolt);
        fprintf( fid , '+ %5.9e %s\n', currTime , currVolt);

    end

end

if (fclose(fid) == 0)
    fprintf ('File %s written successfuly!\n', srcDFE_path);
else
    fprintf ('ERROR: Cannot close file %s! Now exiting\n', fid);
    return;
end
