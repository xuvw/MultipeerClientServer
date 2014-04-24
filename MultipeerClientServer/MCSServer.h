//
//  MCSServer.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/20/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSPeer.h"
#import "MCSRequestHandler.h"

@interface MCSServer : MCSPeer

@property (nonatomic, strong, readonly) MCSRequestHandler *requestHandler;

@end
