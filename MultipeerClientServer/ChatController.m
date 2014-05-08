//
//  ChatController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/6/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatController.h"
#import "ChatDataSource.h"

@interface ChatController () <UICollectionViewDelegate>

@property (nonatomic, strong) id<ChatAppAsyncAPI> chatAppAPI;
@property (nonatomic, strong) Chat *chat;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ChatDataSource *dataSource;
@property (nonatomic, strong) NSTimer *timer;

- (void)pollChat:(id)sender;

@end

@implementation ChatController

- (id)initWithChatAppAPI:(id<ChatAppAsyncAPI>)chatAppAPI chat:(Chat *)chat collectionView:(UICollectionView *)collectionView
{
	self = [super init];
	if (self) {
		self.chatAppAPI = chatAppAPI;
		self.chat = chat;
		self.collectionView = collectionView;
		self.collectionView.delegate = self;
		self.dataSource = [[ChatDataSource alloc] initWithCollectionView:collectionView chat:chat];
		
		UIEdgeInsets contentInset = self.collectionView.contentInset;
		contentInset.bottom += 46.f;
		self.collectionView.contentInset = contentInset;
		
		UIEdgeInsets scrollIndicatorInsets = self.collectionView.scrollIndicatorInsets;
		scrollIndicatorInsets.bottom += 46.f;
		self.collectionView.scrollIndicatorInsets = scrollIndicatorInsets;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
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

- (void)keyboardWillShow:(NSNotification *)notification
{
	UIViewAnimationCurve animationCurve;
	NSTimeInterval animationDuration;
	CGRect keyboardRect;
	
	[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	UIEdgeInsets contentInset = self.collectionView.contentInset;
	contentInset.bottom += keyboardRect.size.height;
	self.collectionView.contentInset = contentInset;
	
	UIEdgeInsets scrollIndicatorInsets = self.collectionView.scrollIndicatorInsets;
	scrollIndicatorInsets.bottom += keyboardRect.size.height;
	self.collectionView.scrollIndicatorInsets = scrollIndicatorInsets;
	
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	UIViewAnimationCurve animationCurve;
	NSTimeInterval animationDuration;
	CGRect keyboardRect;
	
	[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
	
	UIEdgeInsets contentInset = self.collectionView.contentInset;
	contentInset.bottom -= keyboardRect.size.height;
	self.collectionView.contentInset = contentInset;
	
	UIEdgeInsets scrollIndicatorInsets = self.collectionView.scrollIndicatorInsets;
	scrollIndicatorInsets.bottom -= keyboardRect.size.height;
	self.collectionView.scrollIndicatorInsets = scrollIndicatorInsets;
	
	[UIView commitAnimations];
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	/*
	 if (indexPath.row < self.peer.session.connectedPeers.count) {
	 UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	 cell.backgroundColor = [UIColor colorWithHue:0.f saturation:0.f brightness:0.85f alpha:1.f];
	 }
	 */
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	cell.backgroundColor = [UIColor colorWithHue:0.f saturation:0.f brightness:0.85f alpha:1.f];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	cell.backgroundColor = [UIColor whiteColor];
}

@end
