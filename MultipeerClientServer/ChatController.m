//
//  ChatController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/6/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatController.h"

@interface ChatController ()

@property (nonatomic, strong) id<ChatAppAsyncAPI> chatAppAPI;
@property (nonatomic, strong) Chat *chat;
@property (nonatomic, strong) NSTimer *timer;

- (void)pollChat:(id)sender;

@end

@implementation ChatController

- (id)initWithChatAppAPI:(id<ChatAppAsyncAPI>)chatAppAPI chat:(Chat *)chat
{
	self = [super init];
	if (self) {
		self.chatAppAPI = chatAppAPI;
		self.chat = chat;
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scheduleChatPolling
{
	dispatch_async(dispatch_get_main_queue(), ^{
		self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(pollChat:) userInfo:nil repeats:NO];
	});
}

- (void)pollChat:(id)sender
{
	[self.chatAppAPI getChatRevisionWithCompletion:^(int32_t revision) {
		if (self.chat.revision < revision) {
			[self.chatAppAPI getChatWithCompletion:^(Chat *chat) {
				if (chat) {
					dispatch_async(dispatch_get_main_queue(), ^{
						self.chat.revision = chat.revision;
						self.chat.messages = chat.messages;
					});
				}
				
				[self scheduleChatPolling];
			}];
		}
		else {
			[self scheduleChatPolling];
		}
	}];
}

@end
