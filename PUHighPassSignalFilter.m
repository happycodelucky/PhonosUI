//
//  PUHighPassSignalFilter.m
//  PhonosUI
//
//  Created by Paul Bates on 02/18/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import "PUHighPassSignalFilter.h"

double NormalizeSignal(double x, double y, double z);
double ClampSignal(double v, double min, double max);

@implementation PUHighPassSignalFilter


#pragma mark -
#pragma mark Public instance methods

-(void)addSignal:(UIAcceleration*)signal {
	double alpha = filterConstant_;
	double sx = signal.x;
	double sy = signal.y;
	double sz = signal.z;
	
	if(self.isAdaptive)
	{
		double d = ClampSignal(fabs(NormalizeSignal(x_, y_, z_) - 
									NormalizeSignal(sx, sy, sz)
									) / kAccelerometerMinStep - 1.0, 0.0, 1.0);
		alpha = d * alpha / kAccelerometerNoiseAttenuation + (1.0 - d) * alpha;
	}
	
	x_ = alpha * (x_ + sx - lastX_);
	y_ = alpha * (y_ + sy - lastY_);
	z_ = alpha * (z_ + sz - lastZ_);
	
	lastX_ = sx;
	lastY_ = sy;
	lastZ_ = sz;
}

@end

