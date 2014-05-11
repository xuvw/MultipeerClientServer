//
//  ChatInputController.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/5/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatInputView.h"
#import "ChatAppAsyncAPI.h"

@interface ChatInputController : NSObject

- (id)initWithChatAppAPI:(id<ChatAppAsyncAPI>)chatAppAPI chatInputView:(ChatInputView *)chatInputView keyboardConstraint:(NSLayoutConstraint *)keyboardConstraint;

@end
