//
//  PUApplicationServiceCoordinator.h
//  PhonosUI
//
//  Created by Paul Bates on 01/25/10.
//  Copyright 2010 The Evil Radish Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const PUErrorDomain = @"PUErrorDomain";


/*
 * @interface PUApplicationServiceCoordinator
 *
 *	Coordinates starting and stopping of application-based services.
 *	Typically used from a UIApplicationDelegate implementation.
 *
 */
@interface PUApplicationServiceCoordinator : NSObject {
	BOOL m_started;
	NSMutableSet *m_startedServices;
}
@property (nonatomic, readonly)	BOOL applicationServicesStarted;	// Indicates if the application services have already been started.

// +defaultCoordinator
//	Singleton instance of the Application Service Coordinator.
//
+ (PUApplicationServiceCoordinator *)defaultCoordinator;

// -startApplicationServices:error:
//	Starts all the supplied application services, using a supplied array of 
//	service objects.
//
// Arguments:
//	@services: Array of objects conforming to PUApplicationServiceDelegate to
//             start services on.
//	@error:    Optional error object returned if one of the services failed to
//             start corrected.
//
// Returns:
//	YES if there was no error; NO if there was a problem starting one of the
//	applications service. If returning NO, check error argument for an
//	explaination.
- (BOOL)startApplicationServices:(NSArray *)services error:(NSError **)error;

// -startApplicationServices:
//	Starts all the supplied application services by using runtime inference to
//	detect and initialize all classes conforming to the 
//	PUApplicationServiceDelegate protocol.
//
// Arguments:
//	@error: Optional error object returned if one of the services failed to
//          start corrected.
//
// Returns:
//	YES if there was no error; NO if there was a problem starting one of the
//	applications service. If returning NO, check error argument for an
//	explaination.
- (BOOL)startApplicationServicesAutomatically:(NSError **)error;

// -stopApplicationServices
//	Stops all started application services started by calling either
//	startApplicationServices:error: or startApplicationServices:.
- (void)stopApplicationServices;

@end


/*
 * @protocol PUApplicationServiceDelegate
 *
 *	Defines methods required implementing for class instances wishing to 
 *	support starting and stopping of application-based services.
 *
 */
@protocol PUApplicationServiceDelegate

@required

// -initWithCoordinator:
//	Initializes the service delegate object with the coordinator object
//	(PUApplicationServiceCoordinator *), that will be used to start and stop
//	the services managed by the delegate.
//
// Arguments:
//	@coordinator: PUApplicationServiceCoordinator instance that will own the
//                service delegate.
- (id)initWithCoordinator:(PUApplicationServiceCoordinator *)coordinator;

// -startService:
//	Starts the supplied service.
//
// Arguments:
//	@error: Optional error object returned if the service failed to start.
//
// Returns:
//	YES if there was no error; NO if there was a problem starting the service.
//	If returning NO, check error argument for an explaination.
- (BOOL)startService:(NSError **)error;


@optional

// -stopService
//	Stops the application service started.
- (void)stopService:(BOOL)terminating;

@end
