//
//  PUAccelerationSignalFilter.h
//  PhonosUI
//
//  Created by Paul Bates on 02/21/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import "PUAccelerationFilter.h"

/*
 * @interface PUAccelerationSignalFilter
 *
 *	Abstract filter base class for filtering signal input.
 *	Note: This class is not mean to be instantiated, please use a more concrete
 *	      descendent.
 *
 */
@interface PUAccelerationSignalFilter : PUAccelerationFilter {
@protected
	BOOL adaptive_;
	double filterConstant_;
}
@property(nonatomic, getter=isAdaptive) BOOL adaptive;

//
// Designated initializer //
//
- (id)initWithSampleRate:(double)rate cutoffFrequency:(double)frequency;

@end
