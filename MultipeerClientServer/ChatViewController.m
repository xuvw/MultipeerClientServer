//
//  ChatViewController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/6/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatViewController.h"
#import "MSMessageViewController.h"

@interface ChatViewController () <MSMessageViewControllerDelegate>

@property (nonatomic, strong) MSMessageViewController *messageViewController;
@property (nonatomic, strong) NSTimer *chatPollingTimer;

- (void)scheduleChatPolling;
- (void)pollChat:(id)sender;

- (MSMessageBubbleViewModel *)messageBubbleViewModelForMessageText:(NSString *)messageText isAuthor:(BOOL)isAuthor;

@end

@implementation ChatViewController

- (void)viewWillLayoutSubviews
{
	self.messageViewController.maxKeyboardLayoutGuide = self.topLayoutGuide;
	[super viewWillLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self scheduleChatPolling];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"embedMessageViewSegue"]) {
		self.messageViewController = segue.destinationViewController;
		self.messageViewController.delegate = self;
	}
	else {
		return [super prepareForSegue:segue sender:sender];
	}
}

- (void)scheduleChatPolling
{
	dispatch_async(dispatch_get_main_queue(), ^{
		self.chatPollingTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(pollChat:) userInfo:nil repeats:NO];
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

- (MSMessageBubbleViewModel *)messageBubbleViewModelForMessageText:(NSString *)messageText isAuthor:(BOOL)isAuthor
{
	MSMessageBubbleLayoutSpec *layoutSpec = [[MSMessageBubbleLayoutSpec alloc] init];
	layoutSpec.collectionViewSize = self.view.bounds.size;
	layoutSpec.bubbleMaskImageSize = CGSizeMake(48.f, 35.f);
	layoutSpec.bubbleMaskOffset = CGPointMake(20.f, 16.f);
	layoutSpec.alignMessageLabelRight = isAuthor;
	
	if (isAuthor) {
		layoutSpec.messageBubbleInsets = UIEdgeInsetsMake(0.f, 74.f, 0.f, 10.f);
		layoutSpec.messageLabelInsets = UIEdgeInsetsMake(6.5f, 12.f, 7.5f, 18.f);
	}
	else {
		layoutSpec.messageBubbleInsets = UIEdgeInsetsMake(0.f, 10.f, 0.f, 74.f);
		layoutSpec.messageLabelInsets = UIEdgeInsetsMake(6.5f, 18.f, 7.5f, 12.f);
	}
	
	CGFloat constraintWidth = self.view.bounds.size.width - (layoutSpec.messageBubbleInsets.left + layoutSpec.messageBubbleInsets.right + layoutSpec.messageLabelInsets.left + layoutSpec.messageLabelInsets.right);
	CGSize constraintSize = CGSizeMake(constraintWidth, MAXFLOAT);
	layoutSpec.messageLabelSize = [messageText boundingRectWithSize:constraintSize
																			  options:NSStringDrawingUsesLineFragmentOrigin
																		  attributes:@{ NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody] }
																			  context:nil].size;
	
	return [[MSMessageBubbleViewModel alloc] initWithMessageLabelText:messageText isAuthor:isAuthor layoutSpec:layoutSpec];
}

#pragma mark MSMessageViewControllerDelegate

- (MSMessageInputViewModel *)messageInputViewModel
{
	MSMessageInputLayoutSpec *layoutSpec = [[MSMessageInputLayoutSpec alloc] init];
	//layoutSpec.messageInputTextViewContentInset = UIEdgeInsetsMake(5.f, 3.f, 0.f, 0.f);
	layoutSpec.messageInputTextViewContentInset = UIEdgeInsetsMake(5.f, 3.f, -2.f, 0.f);
	layoutSpec.messageInputTextViewPadding = UIEdgeInsetsMake(8.f, 8.f, 8.f, 8.f);
	
	MSMessageInputViewModel *viewModel = [[MSMessageInputViewModel alloc] initWithLayoutSpec:layoutSpec];
	viewModel.messageInputCornerRadius = 5.f;
	viewModel.messageInputBorderWidth = 0.5f;
	viewModel.messageInputBackgroundColor = [UIColor colorWithWhite:1 alpha:0.825f];
	viewModel.messageInputBorderColor = [UIColor colorWithWhite:0.5f alpha:0.4f];
	viewModel.messageInputFont = [UIFont systemFontOfSize:16];
	viewModel.messageInputFontColor = [UIColor darkTextColor];
	viewModel.sendButtonFont = [UIFont boldSystemFontOfSize:17.f];
	viewModel.backgroundToolbarName = @"backgroundToolbar";
	viewModel.inputTextViewName = @"inputTextView";
	viewModel.sendButtonName = @"sendButton";
	
	viewModel.layoutConstraints = @[
	  @"H:[sendButton]-6-|",
	  @"V:[sendButton]-4.5-|",
	  [NSString stringWithFormat:@"H:|-%.2f-[inputTextView]-%.2f-[sendButton]-6-|", viewModel.layoutSpec.messageInputTextViewPadding.left, viewModel.layoutSpec.messageInputTextViewPadding.right],
	  [NSString stringWithFormat:@"V:|-%.2f-[inputTextView]-%.2f-|", viewModel.layoutSpec.messageInputTextViewPadding.top, viewModel.layoutSpec.messageInputTextViewPadding.bottom],
  ];
	
	return viewModel;
}

- (NSUInteger)messageCount
{
	return self.chat.messages.count;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	Message *message = self.chat.messages[ indexPath.row ];
	MSMessageBubbleViewModel *viewModel = [self messageBubbleViewModelForMessageText:message.text isAuthor:YES];
	return [viewModel.layoutSpec cellSize];
}

- (MSMessageBubbleViewModel *)messageBubbleViewModelAtIndexPath:(NSIndexPath *)indexPath
{
	Message *message = self.chat.messages[ indexPath.row ];
	return [self messageBubbleViewModelForMessageText:message.text isAuthor:YES];
}

- (void)messageViewController:(MSMessageViewController *)messageViewController didSendMessageText:(NSString *)messageText
{
	
}

@end
