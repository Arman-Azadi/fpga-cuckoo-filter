destroy .structure
destroy .wave
destroy .source
destroy .signal

echo ##########################################################
echo    "                                                   "
echo    " Simulation of the Cuckoo Filter System ... "
echo    "                                                   "
echo ##########################################################

echo    "Creating Library"

vlib work
vmap work


echo    "Compiling Cuckoo Filter System Modules ..."
vlog -work work -quiet ../src/*.v
###-cover bcesx

echo    "Compiling Cuckoo Filter System Testbench ..."
vlog -work work -quiet ./System_TestBench.v
###-cover bcesx



echo #############################################################
echo    "                                                      "
echo    " Simulating Cuckoo Filter System Testbench ... "
echo    "                                                      "
echo #############################################################

configure wave -timelineunits ns

# vsim -voptargs=+acc -quiet -L work +no_tchk_msg +notimingchecks work.System_tb
vsim -voptargs=+acc -quiet -L work +no_tchk_msg +notimingchecks work.System_tb

echo #####################################
echo    "                             "
echo    " Adding Signals to Waveforms "
echo    "                             "
echo #####################################

do wave.do

configure wave -timelineunits ns

echo #####################################
echo    "                             "
echo    " Simulation Started ...      "
echo    "                             "
echo #####################################

run -all
