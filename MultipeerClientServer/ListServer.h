//
//  ListServer.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/23/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSServer.h"
#import "ListServerState.h"

@interface ListServer : MCSServer

@property (nonatomic, strong, readonly) ListServerState *state;

- (id)initWithServiceType:(NSString *)serviceType state:(ListServerState *)state;

- (void)addListItem:(NSString *)text;

@end
