#!bin/bash

#This is for source the hspice running file
source source_files.sh;
echo 'Now you can run hspice codes in this folder.';
echo 'Time start at $(($(date +%s%N)/1000000))';

for  ((i=400;i<=400;i=i+10));
    do
    for  ((j=500;j<=1000;j=j+50));
        do
            echo .PARAM vdd=$i\m period=$j\p endtime=$j\n > parameter.m;
            cp 16KSA_FO1_design_supply_voltage.sp  16KSA_FO1_design_supply_voltage_$i\m_$j\p.sp;
            hspice 16KSA_FO1_design_supply_voltage_$i\m_$j\p.sp > 16KSA_FO1_design_supply_voltage_$i\m_$j\p.out;
            mail -s '16KSA_FO1_design_supply_voltage_$i\m_$j\p simulation just completed' -a 16KSA_FO1_design_supply_voltage_$i\m_$j\p.out bobzhou@bu.edu < test.log;
        done
    done
OAI21_nangate45.sp
