//
//  MCSMultipeerServer.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

@interface MCSMultipeerServer : NSObject

- (id)initWithSession:(MCSession *)session serviceType:(NSString *)serviceType guid:(NSString *)guid;

@end
