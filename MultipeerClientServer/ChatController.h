//
//  ChatController.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/6/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatAppAsyncAPI.h"

@interface ChatController : NSObject

- (id)initWithChatAppAPI:(id<ChatAppAsyncAPI>)chatAppAPI chat:(Chat *)chat collectionView:(UICollectionView *)collectionView;

- (void)scheduleChatPolling;

@end
