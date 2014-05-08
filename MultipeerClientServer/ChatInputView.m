//
//  ChatInputView.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/5/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatInputView.h"

@interface ChatInputView ()

@property (nonatomic, strong) UIToolbar *backgroundToolbar;
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) UIButton *sendButton;

- (void)commonInit;
- (void)addBackgroundToolbar;
- (void)addInputTextView;
- (void)addSendButton;

@end

@implementation ChatInputView

- (id)init
{
	return [super init];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if(self) {
		[self commonInit];
	}
	return self;
}

- (void)scrollToCaret
{
	CGRect rect = [self.inputTextView caretRectForPosition:self.inputTextView.selectedTextRange.start];
	rect.size.height += self.inputTextView.textContainerInset.bottom;
	[self.inputTextView scrollRectToVisible:rect animated:NO];
}

- (void)commonInit
{
	[self addBackgroundToolbar];
	[self addInputTextView];
	[self addSendButton];
}

- (void)addBackgroundToolbar
{
	if (!self.backgroundToolbar) {
		UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
		toolbar.barStyle = UIBarStyleDefault;
		toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundToolbar = toolbar;
		[self addSubview:toolbar];
	}
}

- (void)addInputTextView
{
	if (!self.inputTextView) {
		UITextView *textView = [[UITextView alloc] init];
		textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		textView.frame = CGRectMake(8.f, 8.f, self.bounds.size.width - 63.f, 30.f);
		textView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.825f];
		textView.font = [UIFont systemFontOfSize:16];
		textView.textColor = [UIColor darkTextColor];
		textView.textContainerInset = UIEdgeInsetsMake(6.f, 2.f, 0.f, 0.f);
		textView.layer.cornerRadius = 5.f;
		textView.layer.borderWidth = 0.5f;
		textView.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.4f].CGColor;
		self.inputTextView = textView;
		[self addSubview:textView];
	}
}

- (void)addSendButton
{
	if (!self.sendButton) {
		UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
		sendButton.frame = CGRectMake(self.bounds.size.width - 47.0f, 7.0f, 39.0f, 32.0f);
		sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
		sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
		sendButton.userInteractionEnabled = YES;
		[sendButton setTitle:@"Send" forState:UIControlStateNormal];
		self.sendButton = sendButton;
		[self addSubview:sendButton];
	}
}

@end
