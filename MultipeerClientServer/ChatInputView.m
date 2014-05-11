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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPaddingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomPaddingConstraint;

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

- (CGSize)intrinsicContentSize
{
	return CGSizeMake(0.f, self.inputTextView.contentSize.height + 16.f);
}

- (void)scrollToCaret
{
	CGRect rect = [self.inputTextView caretRectForPosition:self.inputTextView.selectedTextRange.start];
	rect.size.height += self.inputTextView.textContainerInset.bottom;
	[self.inputTextView scrollRectToVisible:rect animated:NO];
}

- (void)commonInit
{
	self.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self addBackgroundToolbar];
	[self addInputTextView];
	[self addSendButton];
	
	NSDictionary *views = @{
		@"backgroundToolbar" : self.backgroundToolbar,
		@"inputTextView" : self.inputTextView,
		@"sendButton" : self.sendButton,
	};

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[backgroundToolbar]|" options:0 metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundToolbar]|" options:0 metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[sendButton]-6-|" options:0 metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sendButton]-4.5-|" options:0 metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[inputTextView]-8-[sendButton]" options:0 metrics:nil views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[inputTextView]-8-|" options:0 metrics:nil views:views]];

	[self setNeedsUpdateConstraints];
}

- (void)addBackgroundToolbar
{
	if (!self.backgroundToolbar) {
		UIToolbar *toolbar = [[UIToolbar alloc] init];
		toolbar.translatesAutoresizingMaskIntoConstraints = NO;
		toolbar.barStyle = UIBarStyleDefault;
		self.backgroundToolbar = toolbar;
		[self addSubview:toolbar];
	}
}

- (void)addInputTextView
{
	if (!self.inputTextView) {
		UITextView *textView = [[UITextView alloc] init];
		textView.translatesAutoresizingMaskIntoConstraints = NO;
		textView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.825f];
		textView.font = [UIFont systemFontOfSize:16];
		textView.textColor = [UIColor darkTextColor];
		textView.textContainerInset = UIEdgeInsetsMake(5.f, 3.f, 0.f, 0.f);
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
		sendButton.translatesAutoresizingMaskIntoConstraints = NO;
		sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
		sendButton.userInteractionEnabled = YES;
		[sendButton setTitle:@"Send" forState:UIControlStateNormal];
		self.sendButton = sendButton;
		[self addSubview:sendButton];
	}
}

@end
