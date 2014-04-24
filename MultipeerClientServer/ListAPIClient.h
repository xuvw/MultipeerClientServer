//
//  ListAPIClient.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/21/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;

#import "MCSPeer.h"

@interface ListAPIClient : NSObject

- (id)initWithPeer:(MCSPeer *)peer;

- (void)addListItem:(NSString *)text withCompletion:(void(^)(BOOL success))completion;

@end
