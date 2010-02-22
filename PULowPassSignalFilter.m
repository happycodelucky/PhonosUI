//
//  PULowPassSignalFilter.m
//  PhonosUI
//
//  Created by Paul Bates on 02/18/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import "PULowPassSignalFilter.h"
#import "AccelerationSignalFilterFunctions.h"


/*******************************************************************************
 PULowPassSignalFilter implementation
 ******************************************************************************/
@implementation PULowPassSignalFilter

#pragma mark -
#pragma mark Private instance methods

-(void)filterAcceleration:(UIAcceleration*)acceleration {
	double alpha = filterConstant_;
	
	if(self.isAdaptive)
	{
		double d = ClampSignal(fabs(NormalizeSignal(x_, y_, z_) - 
									NormalizeSignal(acceleration.x, acceleration.y, acceleration.z)
									) / kPUAccelerometerMinStep - 1.0, 0.0, 1.0);
		alpha = (1.0 - d) * alpha / kPUAccelerometerNoiseAttenuation + d * alpha;
	}
	
	x_ = acceleration.x * alpha + x_ * (1.0 - alpha);
	y_ = acceleration.y * alpha + y_ * (1.0 - alpha);
	z_ = acceleration.z * alpha + z_ * (1.0 - alpha);
}

@end
