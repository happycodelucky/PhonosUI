//
//  PUHighPassSignalFilter.m
//  PhonosUI
//
//  Created by Paul Bates on 02/18/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import "PUHighPassSignalFilter.h"
#import "AccelerationSignalFilterFunctions.h"


/*******************************************************************************
 PUHighPassSignalFilter implementation
 ******************************************************************************/
@implementation PUHighPassSignalFilter

#pragma mark -
#pragma mark Private instance methods

-(void)filterAcceleration:(UIAcceleration*)acceleration {
	double alpha = filterConstant_;
	double ax = acceleration.x;
	double ay = acceleration.y;
	double az = acceleration.z;
	
	if(self.isAdaptive)
	{
		double d = ClampSignal(fabs(NormalizeSignal(x_, y_, z_) - 
									NormalizeSignal(ax, ay, az)
									) / kPUAccelerometerMinStep - 1.0, 0.0, 1.0);
		alpha = d * alpha / kPUAccelerometerNoiseAttenuation + (1.0 - d) * alpha;
	}
	
	x_ = alpha * (x_ + ax - lastX_);
	y_ = alpha * (y_ + ay - lastY_);
	z_ = alpha * (z_ + az - lastZ_);
	
	lastX_ = ax;
	lastY_ = ay;
	lastZ_ = az;
}

@end

