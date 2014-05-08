//
//  ChatInputView.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/5/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import UIKit;

@interface ChatInputView : UIView

@property (nonatomic, strong, readonly) UITextView *inputTextView;
@property (nonatomic, strong, readonly) UIButton *sendButton;

- (void)scrollToCaret;

@end
