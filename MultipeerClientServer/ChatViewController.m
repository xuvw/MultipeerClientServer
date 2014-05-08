//
//  ChatViewController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/6/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatController.h"
#import "ChatInputController.h"
#import "ChatInputView.h"

@interface ChatViewController ()

@property (nonatomic, strong) ChatController *chatController;
@property (nonatomic, strong) ChatInputController *chatInputController;

@property (nonatomic, weak) IBOutlet UICollectionView *chatCollectionView;
@property (nonatomic, weak) IBOutlet ChatInputView *chatInputView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *chatInputViewConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *keyboardConstraint;

@end

@implementation ChatViewController

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	if (!self.chatController) {
		CGFloat navBarHeight = self.navigationController.navigationBarHidden ? self.navigationController.navigationBar.frame.origin.y : self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
		CGFloat maxHeight = self.chatInputView.frame.origin.y + self.chatInputView.frame.size.height - navBarHeight;
		self.chatController = [[ChatController alloc] initWithChatAppAPI:self.chatAppAPI chat:self.chat collectionView:self.chatCollectionView];
		self.chatInputController = [[ChatInputController alloc] initWithChatAppAPI:self.chatAppAPI chatInputView:self.chatInputView maxChatInputViewHeight:maxHeight chatInputViewConstraint:self.chatInputViewConstraint keyboardConstraint:self.keyboardConstraint];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self.chatController scheduleChatPolling];
}

@end
