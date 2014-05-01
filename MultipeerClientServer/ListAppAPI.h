//
//  ListAppAPI.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/28/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;

#import "MCSPeer.h"
#import "ListApp.h"

@interface ListAppAPI : NSObject

- (id)initWithPeer:(MCSPeer *)peer maxConcurrentOperationCount:(NSUInteger)maxConcurrentOperationCount;

- (void)addListItem:(ListItem *)listItem withCompletion:(void(^)(BOOL success))completion;

@end
