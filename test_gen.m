function test_gen( bitnum, volt, DFE_ratio, FA_ratio) 
%bitnum             -> number of bits for sim
%volt               -> operating voltage
%DFE_ratio          -> DFE pulling strength
%FA_ratio           -> functional assurance sizing

%This function is for running the entire simulation. Details of why it looks 
%like this will be explained in the README.md.
%YOU NEED TO SOURCE SOURCEFILES OUTSIDE MATLAB

%NEXT LINE IS VERY IMPOOOOOOOORTANT!!!      NEXT LINE IS VERY IMPOOOOOOOORTANT!!!
%BE AWARE THAT RANDOM GENERATION PERIOD MUST BE LARGER THAN GATE DELAY
%BE AWARE THAT RANDOM GENERATION PERIOD MUST BE LARGER THAN GATE DELAY
%BE AWARE THAT RANDOM GENERATION PERIOD MUST BE LARGER THAN GATE DELAY
%BE AWARE THAT RANDOM GENERATION PERIOD MUST BE LARGER THAN GATE DELAY
%BE AWARE THAT RANDOM GENERATION PERIOD MUST BE LARGER THAN GATE DELAY
%PREVIOUS LINE IS VERY IMPOOOOOOOORTANT!!!  PREVIOUS LINE IS VERY IMPOOOOOOOORTANT!!!

%This defines the random generation speed.
gen_freq    = volt * 1e9;
gen_period  = 1 / gen_freq;

%Define the simulation setup for the hspice by writing values in the paramter file.
fprintf('Start random generation.....\n');
path = '../eqzGate/parameter.m';
fid = fopen ( path, 'w');

if (fid == -1)
    fprintf('The file here %s can not be opened.\n', path);
else
    fprintf('The file here %s has been succussfully opened. \n', path);
end

fprintf ( fid , '.PARAM vdd=%5.5f v_low=0 buff_vdd=vdd v_hig=vdd\n', volt);
fprintf ( fid , '.TRAN 100e-12 %de-9 START=0.0\n', bitnum * gen_period);

if (fclose(fid) == 0)
    fprintf ('File %s written successfuly!\n', path);
else
    fprintf ('ERROR: Cannot close file %s! Now exiting\n', path);
end

fprintf('Start DFE signal generation.....\n');
path = '../eqzGate/parameter_eqz.m';
fid = fopen ( path, 'w');

if (fid == -1)
    fprintf('The file here %s can not be opened.\n', path);
else
    fprintf('The file here %s has been succussfully opened. \n', path);
end

fprintf ( fid , ...
'.PARAM dfe_n_oaix2=%dn dfe_p_oaix2=%dn ratio=%5.3f cap=0.663f vdd=%5.3f buff_vdd=vdd v_hig=vdd v_low=0\n', ...
DFE_ratio * 630 , DFE_ratio * 415 , FA_ratio, volt);
fprintf ( fid , '.TRAN 1e-12 %de-9 START=0.0\n', bitnum * gen_period);
 
if (fclose(fid) == 0)
    fprintf ('File %s written successfuly!\n', path);
else
    fprintf ('ERROR: Cannot close file %s! Now exiting\n', path);
end

%Generate the input the entire testing system
 vsrc_rand_gen (bitnum, gen_freq, 10, 'vsrc_a', 1, 1, 'v1', 'a', '0');
 vsrc_rand_gen (bitnum, gen_freq, 10, 'vsrc_b1', 1, 1, 'v2', 'b1', '0');
 vsrc_rand_gen (bitnum, gen_freq, 10, 'vsrc_b2', 1, 1, 'v4', 'b2', '0');

%Generate the DFE signal feeding into DFE voltage source.
 vsrc_DFE_gen (bitnum, gen_period, 10);

fprintf('Sourcing the hspice simulation files.....\n');

fprintf('Begin to simulate hspice.....\n');

%LETS FIRE UP THE HSPICE AND LET OTHERS SIMULATE WITH PAIN IN THE ASS
!hspice OAI21_nangate45.sp -o ../hspice_data/OAI21_nangate45  
!hspice OAI21_eqz_nangate45.sp -o ../hspice_data/OAI21_eqz_nangate45  

fprintf('Begin to have EDP analysis.....\n');

%Personally, I recommand you to turn this off, since you can still find your data
%even if people killed your process. The reason why others will kill your process
%is explicitly explained in the last comment.

%fprintf('Begin to remove previous EDP analysis.....\n');
%!rm ../EDP_data/*

%Finally we need to calculate data.
EDP(bitnum, gen_period, 10, volt);
EDP_eqz(bitnum, gen_period, 10, volt , DFE_ratio, FA_ratio);

