//
//  ListAppClient.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/30/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSClient.h"
#import "ListAppAsyncAPI.h"

@interface ListAppClient : MCSClient <ListAppAsyncAPI>

- (id)initWithServiceType:(NSString *)serviceType maxConcurrentOperationCount:(NSUInteger)maxConcurrentOperationCount;

@end
