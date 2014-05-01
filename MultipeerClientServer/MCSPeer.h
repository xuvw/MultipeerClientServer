//
//  MCSPeer.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/20/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

@interface MCSPeer : NSObject <MCSessionDelegate>

@property (nonatomic, strong, readonly) MCSession *session;
@property (nonatomic, copy, readonly) NSString *serviceType;
@property (nonatomic, copy, readonly) NSString *uuid;
@property (nonatomic, copy, readonly) NSArray *connectedPeers;

- (id)initWithServiceType:(NSString *)serviceType;

- (void)start;

- (void)createStreamToHostWithCompletion:(void(^)(NSInputStream *inputStream, NSOutputStream *outputStream))completion;

@end
