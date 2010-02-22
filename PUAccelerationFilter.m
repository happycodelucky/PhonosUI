//
//  PUAccelerationSignalFilter.m
//  PhonosUI
//
//  Created by Paul Bates on 02/18/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import "PUAccelerationFilter.h"


/*******************************************************************************
 PUAccelerationFilter private interface
 ******************************************************************************/
@interface PUAccelerationFilter()

-(void)filterAcceleration:(UIAcceleration*)acceleration;

@end


/*******************************************************************************
 PUAccelerationFilter implementation
 ******************************************************************************/
@implementation PUAccelerationFilter

@synthesize x = x_;
@synthesize y = y_;
@synthesize z = z_;
@synthesize timestamp = timestamp_;


#pragma mark -
#pragma mark Initialization

-(id)init {
	if ((self = [super init])) {
		x_ = 0;
		y_ = 0;
		z_ = 0;
		timestamp_ = 0;
	}
	return self;
}


#pragma mark -
#pragma mark Public instance methods

-(void)addAcceleration:(UIAcceleration *)acceleration {
	//PFAssertTNotNil(acceleration);

	// Set timestamp from original acceleration.
	timestamp_ = acceleration.timestamp;
	
	// Perform actual filtering.
	[self filterAcceleration:acceleration];
}


#pragma mark -
#pragma mark Private instance methods

-(void)filterAcceleration:(UIAcceleration*)acceleration {
	//PFAssertTNotNil(acceleration);
	
	// No filtering, just basic assignment.
	x_ = acceleration.x;
	y_ = acceleration.y;
	z_ = acceleration.z;
}

@end
