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
@class PUAccelerationSignalFilter;


/*
 * @protocol PUAccelerometerFilterDelegate
 *
 *	Protcol to receive notification of filtered accelerometer levels.
 *
 */
@protocol PUAccelerometerFilterDelegate

@required
- (void)accelerometer:(PUAccelerometer *)accelerometer didFilterAcceleration:(PUAccelerationSignalFilter *)filter;

@optional
- (void)accelerometerWillBeginUpdating:(PUAccelerometer *)accelerometer;
- (void)accelerometerDidStopUpdating:(PUAccelerometer *)accelerometer;

@end


/*
 * @interface PUAccelerometer
 *
 *	Single
 *
 */
@interface PUAccelerometer : NSObject <UIAccelerometerDelegate> {
@protected
	NSObject<PUAccelerometerFilterDelegate> *_delegate;
	NSTimeInterval _updateInterval;
	PUAccelerationSignalFilter *_filter;
	BOOL _updating;
}
@property (nonatomic, retain) NSObject<PUAccelerometerFilterDelegate> *delegate;
@property (nonatomic, readonly) PUAccelerationSignalFilter *filter;
@property (nonatomic, readonly) NSTimeInterval updateInterval;
@property (nonatomic, readonly, getter=isUpdating) BOOL updating;

+ (PUAccelerometer *)defaultAccelerometer;

- (BOOL)startUpdating:(id <PUAccelerometerFilterDelegate>)aDelegate atInterval:(NSTimeInterval)aInterval;
- (BOOL)startUpdating:(id <PUAccelerometerFilterDelegate>)aDelegate atInterval:(NSTimeInterval)aInterval usingFilter:(PUAccelerationSignalFilter *)aFilter;
- (void)stopUpdating;

@end
