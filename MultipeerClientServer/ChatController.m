//
//  ChatController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/6/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatController.h"
#import "ChatDataSource.h"
#import "MessageCollectionViewCell.h"

@interface ChatController () <UICollectionViewDelegateFlowLayout>

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
		
		CAGradientLayer *gradientLayer = [CAGradientLayer layer];
		[gradientLayer setFrame:[self.collectionView.layer bounds]];
		UIColor *topColor = [UIColor colorWithRed:90.f/255.f green:200.f/255.f blue:250.0/255.f alpha:1.f];
		UIColor *bottomColor = [UIColor colorWithRed:0.f/255.f green:122.f/255.f blue:25050/255.f alpha:1.f];
		gradientLayer.colors = @[ (id)topColor.CGColor, (id)bottomColor.CGColor ];
		//[self.collectionView.layer addSublayer:gradientLayer];
		
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

#pragma mark UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
	return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
	return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UIEdgeInsets messageInsets = UIEdgeInsetsMake(0.f, 29.f, 0.f, 120.f);
	
	CGSize size = CGSizeMake( self.collectionView.frame.size.width, 0.f );
	UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
	Message *message = [self.dataSource messageAtIndexPath:indexPath];
	
	CGFloat width = size.width - messageInsets.left - messageInsets.right;
	CGRect rect = [message.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
														  options:NSStringDrawingUsesLineFragmentOrigin
													  attributes:@{ NSFontAttributeName: font, NSParagraphStyleAttributeName: [[NSParagraphStyle alloc] init] }
														  context:nil];
	
	size.height = rect.size.height + 6.f;
	
	return size;
}

@end
