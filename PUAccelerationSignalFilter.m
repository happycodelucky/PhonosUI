//
//  PUAccelerationSignalFilter.m
//  PhonosUI
//
//  Created by Paul Bates on 02/21/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import "AccelerationSignalFilterFunctions.h"
#import "PUAccelerationSignalFilter.h"


/*******************************************************************************
 PUAccelerationSignalFilter implementation
 ******************************************************************************/
@implementation PUAccelerationSignalFilter
@synthesize adaptive = adaptive_;


#pragma mark -
#pragma mark Initialization

-(id)init {
	return [self initWithSampleRate:kPUAccelerometerUpdateFrequency 
					cutoffFrequency:kPUAccelerometerCutOffFrequency];
}


-(id)initWithSampleRate:(double)rate cutoffFrequency:(double)frequency {
	if ((self = [self init])) {
		double dt = 1.0 / rate;
		double RC = 1.0 / frequency;
		filterConstant_ = dt / (dt + RC);
	}
	
	return self;
}

@end
