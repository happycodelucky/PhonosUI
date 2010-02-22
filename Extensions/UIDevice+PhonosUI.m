//
//  UIDevice+PhonosUI.m
//  PhonosUI
//
//  Created by Paul Bates on 01/20/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import "PhonosFoundation.h"
#import "UIDevice+PhonosUI.h"


static NSString * const kDeviceGenerationiPhone = @"iPhone1,1";
static NSString * const kDeviceGenerationiPhone3G = @"iPhone1,2";
static NSString * const kDeviceGenerationiPhone3GS = @"iPhone2,1";
static NSString * const kDeviceGenerationiPhone4G = @"iPhone3,1";
static NSString * const kDeviceGenerationiPodTouch1G = @"iPod1,1";
static NSString * const kDeviceGenerationiPodTouch2G = @"iPod2,1";
static NSString * const kDeviceGenerationiPodTouch3G = @"iPod2,2";
static NSString * const kDeviceNameiPad = @"iPad";
static NSString * const kDeviceNameiPhone = @"iPhone";
static NSString * const kDeviceNameiPodTouch = @"iPod Touch";


/*******************************************************************************
 UIDevice (PhonosFoundation) Implementation
 ******************************************************************************/
@implementation UIDevice (PhonosFoundation)
@dynamic machine;
@dynamic type;
@dynamic generation;
@dynamic connectivity;
@dynamic cameraAvailable;
@dynamic compassAvailable;
@dynamic gpsAvailable;
@dynamic microphoneAvailable;


#pragma mark -
#pragma mark Device Information

- (NSString *)machine
{	
	static NSString *machine = nil;
	
	@synchronized(self) {
		if (machine == nil) {
			size_t len = 0;
			int mib[] = {CTL_HW, HW_MACHINE};
			if (sysctl(mib, 2, NULL, &len, NULL, 0) == 0) {
				char *buffer = malloc(len);
				if (buffer){
					if (sysctl(mib, 2, buffer, &len, NULL, 0) == 0) {
						machine = [[NSString alloc] initWithCString:buffer encoding:NSASCIIStringEncoding];
					}
					free(buffer);
				}
			} else {
				PFAssert(NO, @"Unable to fetch the platform machine information from sysctl");
			}
			PFAssertTNotNil(machine);
		}		
	}
	
	return machine;
}


- (UIDeviceType)type
{
	NSString *deviceName = [self name];
	PFAssertTNotNil(deviceName);
	
	if ([kDeviceNameiPhone isEqualToString:deviceName])
		return UIDeviceTypeiPhone;
		
	if ([kDeviceNameiPodTouch isEqualToString:deviceName])
		return UIDeviceTypeiPodTouch;
	
	if ([kDeviceNameiPad isEqualToString:deviceName])
		return UIDeviceTypeiPad;	
	
	PFAssert(NO, @"Unable to determine device type.");
	return UIDeviceTypeiPodTouch;
}


- (int)generation
{
	UIDeviceType type = self.type;
	NSString *machine = self.machine;
	PFAssertTNotNilOrEmpty(machine);
	
	if (type == UIDeviceTypeiPhone) {
		if ([kDeviceGenerationiPhone4G isEqualToString:machine])
			return 4;
		if ([kDeviceGenerationiPhone3GS isEqualToString:machine])
			return 3;
		if ([kDeviceGenerationiPhone3G isEqualToString:machine])
			return 2;
		if ([kDeviceGenerationiPhone isEqualToString:machine])
			return 1;
	} else if (type == UIDeviceTypeiPodTouch) {
		if ([kDeviceGenerationiPodTouch3G isEqualToString:machine])
			return 3;
		if ([kDeviceGenerationiPodTouch2G isEqualToString:machine])
			return 2;
		if ([kDeviceGenerationiPodTouch1G isEqualToString:machine])
			return 1;
	} else if (type == UIDeviceTypeiPad) {
		return 1;
	}
	
	PFAssert(NO, @"Unable to determine device generation");
	return 0;
}


#pragma mark -
#pragma mark Network Status

- (UIDeviceConnectivity)connectivity
{
    // Create zero address
    struct sockaddr_in sockAddr;
    bzero(&_sockAddr, sizeof(_sockAddr));
    sockAddr.sin_len = sizeof(sockAddr);
    sockAddr.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef nrRef = SCNetworkReachabilityCreateWithAddress(NULL, (const struct sockaddr *)&sockAddr);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(nrRef, &flags);
	if (!didRetrieveFlags) {
		NSLog(@"Unable to fetch the network reachablity flags");
	}
	
	CFRelease(nrRef);	
	
// TODO: Before we get through returning set up an observer for notification. Then
// We can report network changes back.
	
	if (!didRetrieveFlags || (flags & kSCNetworkReachabilityFlagsReachable) != kSCNetworkReachabilityFlagsReachable)
		// Unable to connect to a network (no signal or airplane mode activated)
		return UIDeviceConnectivityNone;
	
	if ((_flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
		// Only a cellular network connection is available.
		return UIDeviceConnectivityCellular;
	
	// WiFi connection available.
	return UIDeviceConnectivityWiFi;
}


#pragma mark -
#pragma mark Integrated Hardware

- (BOOL)cameraAvailable
{
	return self.type == UIDeviceTypeiPhone;
}


- (BOOL)compassAvailable
{
	return self.type == UIDeviceTypeiPhone && self.generation > 3;
}


- (BOOL)gpsAvailable
{
	return self.type == UIDeviceTypeiPhone && self.generation > 2;	
}


- (BOOL)microphoneAvailable
{
	return (self.type == UIDeviceTypeiPhone) || (self.type == UIDeviceTypeiPodTouch && self.generation > 3);	
}

@end

