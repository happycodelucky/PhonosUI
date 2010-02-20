//
//  PUAccelerationSignalFilter.h
//  PhonosUI
//
//  Created by Paul Bates on 02/18/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kAccelerometerMinStep				0.02
#define kAccelerometerNoiseAttenuation		3.0

/*
 * @interface PUAccelerationSignalFilter
 *
 *	Abstract filter base class for filtering signal input.
 *
 */
@interface PUAccelerationSignalFilter : NSObject
{
	BOOL adaptive_;
	double filterConstant_;
	UIAccelerationValue x_, y_, z_;
	NSTimeInterval timestamp_;
}
@property(nonatomic, readonly) UIAccelerationValue x;
@property(nonatomic, readonly) UIAccelerationValue y;
@property(nonatomic, readonly) UIAccelerationValue z;
@property(nonatomic, readonly) UIAccelerationValue timestamp;
@property(nonatomic, getter=isAdaptive) BOOL adaptive;

- (id)initWithSampleRate:(double)rate cutoffFrequency:(double)frequency;

- (void)addSignal:(UIAcceleration*)signal;

@end
