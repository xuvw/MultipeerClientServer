//
//  MCSRequestOperation.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/23/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

#import "MCSServer.h"

@interface MCSRequestOperation : NSOperation

@property (nonatomic, readonly) id responseObject;
@property (nonatomic, readonly) NSData *responseData;

- (id)initWithRequest:(id)request server:(id)server;

@end
