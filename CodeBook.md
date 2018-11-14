# Getting and Cleaning Data Final Assignment Code Book


## Features - Tidy
subject: int
	one of 30 test subjects
	
activity: character
	walking
	walking_upstairs
	walking_downstairs
	sitting
	standing
	laying

readtype: character
	time = time domain signals
	frequency = frequency domain signals

motion: character
	body = body acceleration
	gravity = gravity acceleration
	
sensor: character
	acc = raw source was accelerometer
	gyro = raw source was gyroscope
	
jerk: logical
	TRUE if a jerk was being measured
	
func: character
	mean = raw data mean
	std = raw data standard deviation

x: num
	x axis value

y: num
	y axis value

z: num
	z axis value

	
## Features - Summary
subject
activity
sensor
func
x - summarized by mean()
y - summarized by mean()
z - summarized by mean()

GROUPED BY: subject, activity, sensor, func

