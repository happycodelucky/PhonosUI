//
//  PUApplicationServiceCoordinator.m
//  PhonosUI
//
//  Created by Paul Bates on 01/25/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/objc.h>
#import <objc/runtime.h>

#import "PUApplicationServiceCoordinator.h"
//#import "PhonosFoundation.h"
#import "PhonosUI.h"


/*******************************************************************************
 PUApplicationServiceCoordinator private interface
 ******************************************************************************/
@interface PUApplicationServiceCoordinator()

@property (nonatomic, retain) NSMutableSet *startedServices;

- (void)stopApplicationServices:(BOOL)terminating;

@end


// Singleton global for PUApplicationServiceCoordinator.
static PUApplicationServiceCoordinator *__PUApplicationServiceCoordinator = nil;

/*******************************************************************************
 PUApplicationServiceCoordinator implementation
 ******************************************************************************/
@implementation PUApplicationServiceCoordinator

@synthesize startedServices = m_startedServices;
@synthesize applicationServicesStarted = m_started;


#pragma mark -
#pragma mark Singleton

+ (PUApplicationServiceCoordinator *)defaultCoordinator
{
	@synchronized(self) {
		if (__PUApplicationServiceCoordinator == nil) {
			// No assignment done here, see allocWithZone.
			[[self alloc] init];
		}
	}
	
	//PFAssertTNotNil(__PUApplicationServiceCoordinator);
	return __PUApplicationServiceCoordinator;
}


#pragma mark -
#pragma mark Public methods

- (BOOL)startApplicationServices:(NSArray *)services error:(NSError **)error {
	//PFAssert(!self.applicationServicesStarted, @"not_services_started");
	//PFAssertTNotNilOrEmpty(services);
	
	if (m_startedServices == nil) {
		m_startedServices = [[NSMutableSet alloc] initWithCapacity:1];
	}	
	
	// Register for terminate notification to terminate the services.
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(applicationTerminatingNotification:)
												 name:UIApplicationWillTerminateNotification 
											   object:nil];	
	
	NSError *startError = nil;
	Protocol *delegateProtocol = @protocol(PUApplicationServiceDelegate);	
	for (id service in services) {
		if ([service conformsToProtocol:delegateProtocol]) {
			id<PUApplicationServiceDelegate> del = service;
			if ([del startService:&startError]) {
				// Start was a success, register the object in the started
				// set for later stopping.
				[m_startedServices addObject:del];
			} else {
				// An error occurred.
				//PFAssertTNotNil(startError);
				
				// Log it!
				PFLogError(startError);
				
				// Return it!
				if (error) {
					*error = [startError autorelease];
				}
				//PFAssert(!self.applicationServicesStarted, @"not_services_started");
				return NO;
			}			
		}
	}
	
	// Services have been started.
	m_started = YES;
	
	//PFAssert(self.applicationServicesStarted, @"services_started");	
	return YES;
}


- (BOOL)startApplicationServicesAutomatically:(NSError **)error {
	//PFAssert(!self.applicationServicesStarted, @"not_services_started");
	
	// Locate all classes implementing PUApplicationServicesDelegate and call
	// startApplicationServices.
	int numClasses = 0;
	Class *classes = NULL;
	BOOL started = NO;
	
	// Look for classes implementing PUApplicationServicesDelegate.
	numClasses = objc_getClassList(NULL, 0);
	if (numClasses > 0) {
		NSMutableArray *services = [[NSMutableArray alloc] initWithCapacity:1];
		
		// Iterate through all classes to find all registered classes
		// implementing PUApplicationServicesDelegate.
		Protocol *delegateProtocol = @protocol(PUApplicationServiceDelegate);
		classes = malloc(sizeof(Class) * numClasses);
		numClasses = objc_getClassList(classes, numClasses);
		for (int i = 0; i < numClasses; i++) {
			Class c = classes[i];
			if (class_conformsToProtocol(c, delegateProtocol)) {
				NSObject *service = [[c alloc] initWithCoordinator:self];
				[services addObject:service];
				[service release];
			}
		}
		free(classes);
		
		started = [self startApplicationServices:services error:error];
		[services release];
	}
	

	//PFAssert(self.applicationServicesStarted == started, @"services_started_set");	
	return started;
}


- (void)stopApplicationServices {
	if (self.applicationServicesStarted) {
		[self stopApplicationServices:YES];		
	}
	
	//PFAssert(!self.applicationServicesStarted, @"not_services_started");	
}


#pragma mark -
#pragma mark Private methods

- (void)stopApplicationServices:(BOOL)terminating {
	//PFAssert(self.applicationServicesStarted, @"services_started");
	//PFAssertNotNil(self.startedServices, @"services_not_nil");
	
	NSMutableSet *services = self.startedServices;
	if (services != nil && ![services isEmpty]) {
		NSMutableArray *removed = [[NSMutableSet alloc] initWithCapacity:[services count]];
		for (id service in services) {
			//PFAssert([service conformsToProtocol:@protocol(PUApplicationServiceDelegate)], @"service_conforms_to_PUApplicationServiceDelegate");
			if ([service respondsToSelector:@selector(stopService:)]){
				// stopService: is optional, so only call it on objects 
				// implementing it.
				[service stopService:terminating];
			}
			[removed addObject:service];
		}
		[services removeObjectsInArray:removed];
		
		//PFAssertTIsEmpty(services);
	}
	
	// Unregister notification if not terminating as we no longer need it.
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:UIApplicationWillTerminateNotification 
												  object:nil];
	
	// No more started services.
	m_started = NO;
	
	//PFAssert(!self.applicationServicesStarted, @"not_services_started");
}


#pragma mark -
#pragma mark Notification handling

- (void)applicationTerminatingNotification:(id)sender {
	if (self.applicationServicesStarted) {
		[self stopApplicationServices:YES];
	}
}


#pragma mark -
#pragma mark Memory management

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (__PUApplicationServiceCoordinator == nil) {
			// Assignment and return on first allocation.
			__PUApplicationServiceCoordinator = [super allocWithZone:zone];
			return __PUApplicationServiceCoordinator; 
		}
	}
	
	// On subsequent allocation attempts return nil!
	return nil; 
} 


- (id)copyWithZone:(NSZone *)zone {
	return self;
}


- (id)retain {
	return self;
}


- (unsigned)retainCount {
	return UINT_MAX; //denotes an object that cannot be released
}


- (void)release {
	//do nothing
}


- (id)autorelease {
	return self;
}

@end
