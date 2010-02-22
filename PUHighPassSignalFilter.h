//
//  PUHighPassSignalFilter.h
//  PhonosUI
//
//  Created by Paul Bates on 02/18/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import "PUAccelerationSignalFilter.h"


/*
 * @interface PUAccelerationSignalFilter
 *
 *	Performs High-Pass signal filtering as described in the article found at
 *	http://en.wikipedia.org/wiki/High_pass_filter
 *
 */
@interface PUHighPassSignalFilter : PUAccelerationSignalFilter {
	UIAccelerationValue lastX_, lastY_, lastZ_;	
}

@end
