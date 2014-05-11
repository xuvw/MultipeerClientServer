//
//  MessageCollectionViewCell.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/8/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import UIKit;

@interface MessageCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak, readonly) IBOutlet UITextView *textView;

@end
