/*
 *  AccelerationSignalFilterFunctions.h
 *  PhonosUI
 *
 *	Header file include private functions for use with acceleration signal
 *	filters.
 *
 *  Created by Paul Bates on 02/21/10.
 *  Copyright 2010 The Evil Radish Corporation. All rights reserved.
 *
 */

#import <math.h>


// Filtering constants
#define kPUAccelerometerMinStep				0.02
#define kPUAccelerometerNoiseAttenuation	3.0

// Defaults
#define kPUAccelerometerUpdateFrequency		60.0
#define kPUAccelerometerCutOffFrequency		5.0


//	NormalizeSignal(x, y, z)
//	Normalizes an acceleration's axis signals.
//
inline double NormalizeSignal(double x, double y, double z) {
	return sqrt(x * x + y * y + z * z);
}

//	ClampSignal(v, min, max)
//	Limits an accelerations's axis signal between a minimum and maximum range.
//
inline double ClampSignal(double v, double min, double max) {
	if(v > max)
		return max;
	else if(v < min)
		return min;
	else
		return v;
}
