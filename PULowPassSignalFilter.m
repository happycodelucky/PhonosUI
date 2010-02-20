//
//  PULowPassSignalFilter.m
//  PhonosUI
//
//  Created by Paul Bates on 02/18/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import "PULowPassSignalFilter.h"

double NormalizeSignal(double x, double y, double z);
double ClampSignal(double v, double min, double max);

@implementation PULowPassSignalFilter


#pragma mark -
#pragma mark Public instance methods

-(void)addSignal:(UIAcceleration*)signal {
	double alpha = filterConstant_;
	
	if(self.isAdaptive)
	{
		double d = ClampSignal(fabs(NormalizeSignal(x_, y_, z_) - 
									NormalizeSignal(signal.x, signal.y, signal.z)
									) / kAccelerometerMinStep - 1.0, 0.0, 1.0);
		alpha = (1.0 - d) * alpha / kAccelerometerNoiseAttenuation + d * alpha;
	}
	
	x_ = signal.x * alpha + x_ * (1.0 - alpha);
	y_ = signal.y * alpha + y_ * (1.0 - alpha);
	z_ = signal.z * alpha + z_ * (1.0 - alpha);
}

@end
