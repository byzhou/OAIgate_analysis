** Generated for: hspiceD
** Generated on: Sep 14 17:59:54 2014
** Design library name: dummy_4_bit
** Design cell name: test_OAI21
** Design view name: schematic
.GLOBAL vdd! _gnet0 vss!



.OP

.TEMP 25
.OPTION
+    ARTIST=2
+    INGOLD=2
+    PARHIER=LOCAL
+    PSF=2
+    post=1
.PROBE TRAN V(a) V(b1) V(b2) V(a_in) V(b1_in) V(b2_in) V(output) V(Vpower)
.INCLUDE "/ad/eng/users/b/o/bobzhou/Desktop/571/hw3/tech_files/45nm_HP.pm"
.INCLUDE "/home/bobzhou/Desktop/571/research/2014_fall/singleGateMeasure/eqzGate/include_files.m"
.include "../vsrc_files/vsrc_a_0.dat"
.include "../vsrc_files/vsrc_b1_0.dat"
.include "../vsrc_files/vsrc_b2_0.dat"

** Library name: NangateOpenCellLibrary
** Cell name: OAI21_X2
** View name: schematic
.subckt OAI21_X2 a b1 b2 zn
m_i_2_0 vss! a net_0 vss! NMOS_VTL L=50e-9 W=415e-9
m_i_2_1 net_0 a vss! vss! NMOS_VTL L=50e-9 W=415e-9
m_i_1__m0 zn b2 net_0 vss! NMOS_VTL L=50e-9 W=415e-9
m_i_1__m1 net_0 b2 zn vss! NMOS_VTL L=50e-9 W=415e-9
m_i_0__m0 net_0 b1 zn vss! NMOS_VTL L=50e-9 W=415e-9
m_i_0__m1 zn b1 net_0 vss! NMOS_VTL L=50e-9 W=415e-9
m_i_3__m0 zn b1 net_1__m0_0 _gnet0 PMOS_VTL L=50e-9 W=630e-9
m_i_4__m0 net_1__m0_0 b2 _gnet0 _gnet0 PMOS_VTL L=50e-9 W=630e-9
m_i_3__m1 net_1__m1 b1 zn _gnet0 PMOS_VTL L=50e-9 W=630e-9
m_i_4__m1 _gnet0 b2 net_1__m1 _gnet0 PMOS_VTL L=50e-9 W=630e-9
m_i_5_0 zn a _gnet0 _gnet0 PMOS_VTL L=50e-9 W=630e-9
m_i_5_1 _gnet0 a zn _gnet0 PMOS_VTL L=50e-9 W=630e-9
.ends OAI21_X2
** End of subcircuit definition.

** Library name: equalized_logic
** Cell name: buffer4test
** View name: schematic
.subckt buffer4test buff_vdd buff_vss input output inh_bulk_n inh_bulk_p
m1 output net14 buff_vdd inh_bulk_p pmos_vtl L=50e-9 W=1.26e-6
m3 net14 input buff_vdd inh_bulk_p pmos_vtl L=50e-9 W=1.26e-6
m0 output net14 buff_vss inh_bulk_n nmos_vtl L=50e-9 W=830e-9
m9 net14 input buff_vss inh_bulk_n nmos_vtl L=50e-9 W=830e-9
.ends buffer4test
** End of subcircuit definition.

** Library name: dummy_4_bit
** Cell name: test_OAI21
** View name: schematic
xi15 a_in b1_in b2_in output OAI21_X2
f0 vpower 0 CCCS v3  1 M=1
v10 buff_vss 0 DC=0
v8 buff_vdd 0 DC=buff_vdd
v6 vss! 0 DC=0
v3 _gnet0 0 DC=vdd
xi18 buff_vdd buff_vss b2 b2_in 0 vdd! buffer4test
xi17 buff_vdd buff_vss b1 b1_in 0 vdd! buffer4test
xi16 buff_vdd buff_vss a a_in 0 vdd! buffer4test
c10 vpower 0 1e-12 IC=0
c0 output 0 663e-18
.END
