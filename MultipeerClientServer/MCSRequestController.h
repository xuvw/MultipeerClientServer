//
//  MCSRequestController.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

#import "MCSRequest.h"

@interface MCSRequestController : NSObject

- (void)sendRequest:(MCSRequest *)request toPeer:(MCPeerID *)peerID withSession:(MCSession *)session;

- (void)processResponseData:(NSData *)responseData;

@end
