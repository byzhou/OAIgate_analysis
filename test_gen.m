function test_gen( bitnum, volt, DFE_ratio, FA_ratio)
%bitnum             -> number of bits for sim
%volt               -> operating voltage
%DFE_ratio          -> DFE pulling strength
%FA_ratio           -> functional assurance sizing

gen_freq    = 1e9;
gen_period  = 1 / gen_freq;

fprintf('Start random generation.....\n');
path = '../eqzGate/parameter.m';
fid = fopen ( path, 'w');

if (fid == -1)
    fprintf('The file here %s can not be opened.\n', path);
else
    fprintf('The file here %s has been succussfully opened. \n', path);
end

fprintf ( fid , '.PARAM vdd=%5.5f v_low=0 buff_vdd=vdd v_hig=vdd\n', volt);
fprintf ( fid , '.TRAN 100e-12 %de-9 START=0.0\n', bitnum);

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

fprintf ( fid , '.PARAM dfe_n_oaix2=%dn dfe_p_oaix2=%dn ratio=%5.3f cap=0.663f vdd=%5.3f buff_vdd=vdd v_hig=vdd v_low=0\n', DFE_ratio * 630 , DFE_ratio * 415 , FA_ratio, volt);
fprintf ( fid , '.TRAN 1e-12 %de-9 START=0.0\n', bitnum);
%fprintf ( '.TRAN 1e-12 %de-9 START=0.0\n', bitnum);
 
if (fclose(fid) == 0)
    fprintf ('File %s written successfuly!\n', path);
else
    fprintf ('ERROR: Cannot close file %s! Now exiting\n', path);
end


 vsrc_rand_gen (bitnum, gen_freq, 10, 'vsrc_a', 1, 1, 'v1', 'a', '0');
 vsrc_rand_gen (bitnum, gen_freq, 10, 'vsrc_b1', 1, 1, 'v2', 'b1', '0');
 vsrc_rand_gen (bitnum, gen_freq, 10, 'vsrc_b2', 1, 1, 'v4', 'b2', '0');

 vsrc_DFE_gen (bitnum, gen_period, 10);
%vsrc_rand_gen (10, 1e9, 1, 'vsrc_a', 1, 1, 'v1', 'a', '0');
%vsrc_rand_gen (10, 1e9, 1, 'vsrc_b1', 1, 1, 'v2', 'b1', '0');
%vsrc_rand_gen (10, 1e9, 1, 'vsrc_b2', 1, 1, 'v4', 'b2', '0');

fprintf('Sourcing the hspice simulation files.....\n');

%!source /ad/eng/opt/cadence/cdssetup/add_ic612.sh
%!source /ad/eng/opt/cadence/cdssetup/add_freepdk45.sh
%!source /ad/eng/support/software/linux/all/all/synopsys/add_syn.sh

fprintf('Begin to simulate hspice.....\n');
!hspice OAI21_nangate45.sp -o ../hspice_data/OAI21_nangate45 > last_run.log 
%!hspice OAI21_eqz_nangate45.sp -o ../hspice_data/OAI21_eqz_nangate45 > last_run.log 

fprintf('Begin to have EDP analysis.....\n');
%fprintf('Begin to remove previous EDP analysis.....\n');
%!rm ../EDP_data/*
EDP(bitnum, gen_period, 10, volt);
%EDP_eqz(bitnum, gen_period, 10, volt , DFE_ratio, FA_ratio);

