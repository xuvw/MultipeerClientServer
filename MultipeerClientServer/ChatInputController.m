//
//  ChatInputController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/5/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatInputController.h"

static inline UIViewAnimationOptions UIViewAnimationOptionsFromUIViewAnimationCurve(UIViewAnimationCurve curve)
{
	switch (curve) {
		case UIViewAnimationCurveEaseInOut:
			return UIViewAnimationOptionCurveEaseInOut;
		case UIViewAnimationCurveEaseIn:
			return UIViewAnimationOptionCurveEaseIn;
		case UIViewAnimationCurveEaseOut:
			return UIViewAnimationOptionCurveEaseOut;
		case UIViewAnimationCurveLinear:
			return UIViewAnimationOptionCurveLinear;
	}
}

@interface ChatInputController () <UITextViewDelegate>

@property (nonatomic, strong) id<ChatAppAsyncAPI> chatAppAPI;
@property (nonatomic, strong) ChatInputView *chatInputView;
@property (nonatomic, strong) NSLayoutConstraint *keyboardConstraint;

- (IBAction)sendPressed:(id)sender;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end

@implementation ChatInputController

- (id)initWithChatAppAPI:(id<ChatAppAsyncAPI>)chatAppAPI chatInputView:(ChatInputView *)chatInputView keyboardConstraint:(NSLayoutConstraint *)keyboardConstraint
{
	self = [super init];
	if (self) {
		self.chatAppAPI = chatAppAPI;
		self.chatInputView = chatInputView;
		self.keyboardConstraint = keyboardConstraint;
		
		self.chatInputView.inputTextView.delegate = self;
		[self.chatInputView.sendButton addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)sendPressed:(id)sender
{
	Message *message = [[Message alloc] initWithText:self.chatInputView.inputTextView.text];
	[self.chatAppAPI addMessage:message withCompletion:^(int32_t revision) {
		/**/
	}];
	
	self.chatInputView.inputTextView.text = @"";
	[self textViewDidChange:self.chatInputView.inputTextView];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
	UIViewAnimationCurve animationCurve;
	NSTimeInterval animationDuration;
	CGRect keyboardRect;
	
	[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
	
	self.keyboardConstraint.constant = keyboardRect.size.height;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	{
		[self.chatInputView.superview layoutIfNeeded];
	}
	
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

	self.keyboardConstraint.constant = 0.f;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	{
		[self.chatInputView.superview layoutIfNeeded];
	}
	
	[UIView commitAnimations];
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
	[UIView animateWithDuration:0.1f animations:^{
		[self.chatInputView scrollToCaret];
		[self.chatInputView invalidateIntrinsicContentSize];
	}];
}

@end
