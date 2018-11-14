# Getting and Cleaning Data Final Assignment Code Book


## Features - Tidy
subject: int<br/>
	one of 30 test subjects
	
activity: character<br/>
	walking<br/>
	walking_upstairs<br/>
	walking_downstairs<br/>
	sitting<br/>
	standing<br/>
	laying

readtype: character<br/>
	time = time domain signals<br/>
	frequency = frequency domain signals

motion: character<br/>
	body = body acceleration<br/>
	gravity = gravity acceleration
	
sensor: character<br/>
	acc = raw source was accelerometer<br/>
	gyro = raw source was gyroscope
	
jerk: logical<br/>
	TRUE if a jerk was being measured
	
func: character<br/>
	mean = raw data mean<br/>
	std = raw data standard deviation

x: num<br/>
	x axis value

y: num<br/>
	y axis value

z: num<br/>
	z axis value

	
## Features - Summary
subject<br/>
activity<br/>
sensor<br/>
func<br/>
x - summarized by mean()<br/>
y - summarized by mean()<br/>
z - summarized by mean()

GROUPED BY: subject, activity, sensor, func

