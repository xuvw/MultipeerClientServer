//
//  ChatViewController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/6/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatController.h"

@interface ChatViewController ()

@property (nonatomic, strong) ChatController *chatController;

@end

@implementation ChatViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.chatController = [[ChatController alloc] initWithChatAppAPI:self.chatAppAPI chat:self.chat];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	if (!self.chatController) {
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self.chatController scheduleChatPolling];
}

@end
