
# ps:
# 	iverilog -g2012 -o pixelArray -c pixelArray.fl
# 	vvp -n pixelArray

# ps:
# 	iverilog -g2012 -o pixelSensor -c pixelSensor.fl
# 	vvp -n pixelSensor

psfsm:
	iverilog -g2012 -o pixelSensorFsm -c pixelSensorFsm.fl
	vvp -n pixelSensorFsm

top: 
	iverilog -g2012 -o pixelTop -c pixelTop.fl
	vvp -n pixelTop
