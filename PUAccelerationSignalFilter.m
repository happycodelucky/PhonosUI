//
//  PUAccelerationSignalFilter.m
//  PhonosUI
//
//  Created by Paul Bates on 02/18/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import "PUAccelerationSignalFilter.h"


double NormalizeSignal(double x, double y, double z) {
	return sqrt(x * x + y * y + z * z);
}


double ClampSignal(double v, double min, double max) {
	if(v > max)
		return max;
	else if(v < min)
		return min;
	else
		return v;
}


@implementation PUAccelerationSignalFilter
@synthesize x = x_;
@synthesize y = y_;
@synthesize z = z_;
@synthesize timestamp = timestamp_;
@synthesize adaptive = adaptive_;


#pragma mark -
#pragma mark Initialization

-(id)init {
	if ((self = [super init])) {
		x_ = 0;
		y_ = 0;
		z_ = 0;
		timestamp_ = 0;
		filterConstant_ = 0;	
		adaptive_ = NO;
	}
	return self;
}

-(id)initWithSampleRate:(double)rate cutoffFrequency:(double)frequency {
	if ((self = [self init])) {
		double dt = 1.0 / rate;
		double RC = 1.0 / frequency;
		filterConstant_ = dt / (dt + RC);
	}
	
	return self;
}


#pragma mark -
#pragma mark Public instance methods

-(void)addSignal:(UIAcceleration *)signal {
	x_ = signal.x;
	y_ = signal.y;
	z_ = signal.z;
}

@end
