//
//  PUAccelerationSignalFilter.h
//  PhonosUI
//
//  Created by Paul Bates on 02/18/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/*
 * @interface PUAccelerationSignalFilter
 *
 *	Acceleration filter base class for filtering signal input.
 *
 *	This filter does nothing filter the input. Please use a specialized filter
 *	descendent in order to provided a actual level of acceleration filtering.
 *
 */
@interface PUAccelerationFilter : NSObject {
@protected	
	UIAccelerationValue x_, y_, z_;
	NSTimeInterval timestamp_;
}
@property(nonatomic, readonly) UIAccelerationValue x;
@property(nonatomic, readonly) UIAccelerationValue y;
@property(nonatomic, readonly) UIAccelerationValue z;
@property(nonatomic, readonly) UIAccelerationValue timestamp;

- (void)addAcceleration:(UIAcceleration*)acceleration;

@end
