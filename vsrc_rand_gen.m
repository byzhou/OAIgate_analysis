function vsrc_rand_gen (bit_num, frequency, sampleRate, fName, fileNumber, inverse,...
                        vsrcName, outName, gndName)
% bit_num       -> number of bits to generate
% frequency     -> on what frequency
% sampleRate    -> how many bits for one frequency
% fNmae         -> filename to be saved
% fileNumber    -> how many files
% vsrcName      -> voltage source name
% outName       -> voltage source output net name
% gndName       -> voltage source connection to groundName

% Example of voltage source generation:
% vsrc_rand_gen (1000, 1e9, 10, 'vsrc_a', 1, 1, 'v1', 'a', '0');

period = 1/frequency;

% Make a seed for rand:
RandStream.setGlobalStream(RandStream('mt19937ar', 'seed', sum(100*clock)));

for j = 1:fileNumber
    curr_time = 0;
    curr_voltage = 'V_low';
    fNameSave = strcat ('../vsrc_files/',fName, '_', int2str(j-1), '.dat');
    fN4cds = strcat ('../vsrc_files/',fName, '_', int2str(j-1), '_cadence.dat');
    %fN4DFE = strcat ('../vsrc_files/', 'vsrc_DFE', '_', int2str(j-1), '_cadence.dat');
    fValue = strcat ('../vsrc_files/','function_check_',fName, '_', int2str(j-1), '.txt');

    if (inverse == 1)
        curr_voltage_inv = 'V_hig';
        fNameSave_inv = strcat ('../vsrc_files/',fName, '_inv_', int2str(j-1), '.dat');
        fid_inv = fopen(fNameSave_inv, 'w');
    end
    
    fid         = fopen(fNameSave, 'w');
    fid_cds     = fopen(fN4cds, 'w');
    %fid_DFE     = fopen(fN4DFE, 'w');
    fid_func    = fopen(fValue, 'w');

    if (fid == -1 || fid_inv == -1 || fid_func == -1 || fid_cds == -1)
        fprintf ('ERROR: Cannot open %s to write! Now exiting!', fNameSave);
    end

    fprintf(fid, '%s %s %s PWL\n', vsrcName, outName, gndName);
    
    for i = 1 : bit_num
        bit = round (rand());
        if (bit == 1)
            curr_voltage = 'V_hig';
            curr_voltage_inv = 'V_low';
            curr_bit = 1;
        else
            curr_voltage = 'V_low';
            curr_voltage_inv = 'V_hig';
            curr_bit = 0;
        end

        fprintf (fid_func, '%d %d\n', curr_time * 1e9, curr_bit);

        %curr_time = curr_time + 1e-15;

        for j = 1 : sampleRate

            curr_time = curr_time + 1e-15;
            fprintf (fid, '+ %5.6fn %s\n', curr_time * 1e9, curr_voltage);
            fprintf (fid_cds, '%5.6fn %s\n', curr_time * 1e9, curr_voltage);
            fprintf (fid_inv, '+ %5.6fn %s\n', curr_time * 1e9, curr_voltage_inv);
            %fprintf (fid_inv, '+ %5.9e %s\n', curr_time, curr_voltage_inv);

            curr_time =  curr_time + period / sampleRate - 1e-15;
            fprintf (fid, '+ %5.6fn %s\n', curr_time * 1e9, curr_voltage);
            fprintf (fid_cds, '%5.6fn %s\n', curr_time * 1e9, curr_voltage);
            fprintf (fid_inv, '+ %5.6fn %s\n', curr_time * 1e9, curr_voltage_inv);
            %fprintf (fid, '+ %5.9e %s\n', curr_time, curr_voltage);
            %fprintf (fid_inv, '+ %5.9e %s\n', curr_time, curr_voltage_inv);
        end
    end

    if (fclose(fid) == 0)
        fprintf ('File %s written successfuly!\n', fNameSave);
    else
        fprintf ('ERROR: Cannot close file %s! Now exiting\n', fNameSave);
        return;
    end
    
    if (fclose(fid_inv) == 0)
        fprintf ('File %s written successfuly!\n', fNameSave_inv);
    else
        fprintf ('ERROR: Cannot close file %s! Now exiting\n', fNameSave_inv);
        return;
    end

    if (fclose(fid_func) == 0)
        fprintf ('File %s written successfuly!\n', fValue);
    else
        fprintf ('ERROR: Cannot close file %s! Now exiting\n', fValue);
        return;
    end
        
    if (fclose(fid_cds) == 0)
        fprintf ('File %s written successfuly!\n', fN4cds);
    else
        fprintf ('ERROR: Cannot close file %s! Now exiting\n', fN4cds);
        return;
    end
end
