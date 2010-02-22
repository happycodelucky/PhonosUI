//
//  PUAccelerometer.h
//  PhonosUI
//
//  Created by Paul Bates on 02/18/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// Forward declarations
@class PUAccelerometer;
@class PUAccelerationFilter;


/*
 * @protocol PUAccelerometerFilterDelegate
 *
 *	Protcol to receive notification of filtered accelerometer levels.
 *
 */
@protocol PUAccelerometerFilterDelegate

@required
- (void)accelerometer:(PUAccelerometer *)accelerometer didFilterAcceleration:(PUAccelerationFilter *)filter;

@optional
- (void)accelerometerWillBeginUpdating:(PUAccelerometer *)accelerometer;
- (void)accelerometerDidStopUpdating:(PUAccelerometer *)accelerometer;

@end


/*
 * @interface PUAccelerometer
 *
 *	Singleton accelerometer class for use with PUAccelerationFilter objects.
 *
 */
@interface PUAccelerometer : NSObject <UIAccelerometerDelegate> {
@protected
	NSObject<PUAccelerometerFilterDelegate> *_delegate;
	NSTimeInterval _updateInterval;
	PUAccelerationFilter *_filter;
	BOOL _updating;
}
@property (nonatomic, retain) NSObject<PUAccelerometerFilterDelegate> *delegate;
@property (nonatomic, readonly) PUAccelerationFilter *filter;
@property (nonatomic, readonly) NSTimeInterval updateInterval;
@property (nonatomic, readonly, getter=isUpdating) BOOL updating;

+ (PUAccelerometer *)sharedAccelerometer;

- (BOOL)startUpdating:(NSObject<PUAccelerometerFilterDelegate> *)aDelegate atInterval:(NSTimeInterval)aInterval;
- (BOOL)startUpdating:(NSObject<PUAccelerometerFilterDelegate> *)aDelegate atInterval:(NSTimeInterval)aInterval usingFilter:(PUAccelerationFilter *)aFilter;
- (void)stopUpdating;

@end
