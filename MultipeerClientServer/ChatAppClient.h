//
//  ChatAppClient.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/30/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSClient.h"
#import "ChatAppAsyncAPI.h"

@interface ChatAppClient : MCSClient <ChatAppAsyncAPI>

- (id)initWithServiceType:(NSString *)serviceType maxConcurrentOperationCount:(NSUInteger)maxConcurrentOperationCount;

@end
