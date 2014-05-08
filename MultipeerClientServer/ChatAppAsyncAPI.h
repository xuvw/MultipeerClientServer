//
//  ChatAppAsyncAPI.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/1/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatAppAPI.h"

@protocol ChatAppAsyncAPI <NSObject>

- (void)addMessage:(Message *)message withCompletion:(void(^)(int32_t revision))completion;
- (void)getChatRevisionWithCompletion:(void(^)(int32_t revision))completion;
- (void)getChatWithCompletion:(void(^)(Chat *chat))completion;

@end
