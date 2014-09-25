These codes are for Measuring single gate performance, EDP specificly. An example should be:
when you need to analyze one gate EDP analysis compared to another and you need to measure 
it for an average of a thousand times. These codes are ideal for this situation. In the para-
meter file, you can re-write the supply voltage to provide a voltage scaling scenario.

The way that all these codes work is like this:
    1 Generate the voltage infomation for the voltage sources.
    2 Generate the Decision feed-back signal for the DFE source.
    3 Fire up the hspice for simulation.
    4 Conduct EDP analysis, and write to a file.
    5 Plot the figure. ( This figure is not generated automaticly. Since the number of 
      tests can be re-configured, that determine how the figure is generated.)

How folders are organized:

eqzGate         -> All the codes are here. (They are gitted.)
fig             -> Ploted figures are stored here.
hspice_data     -> Hspice rubbish.
ob_files        -> Observing codes from here.
vsrc_files      -> Generated signals about to be fed.

