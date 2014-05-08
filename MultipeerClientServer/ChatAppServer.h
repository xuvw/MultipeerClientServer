//
//  ChatAppServer.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/30/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSServer.h"
#import "ChatAppAsyncAPI.h"

@interface ChatAppServer : MCSServer <ChatAppAsyncAPI>

- (id)initWithServiceType:(NSString *)serviceType chat:(Chat *)chat;

@end
