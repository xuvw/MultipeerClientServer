//
//  ChatDataSource.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;

@class Chat;

@interface ChatDataSource : NSObject

- (id)initWithCollectionView:(UICollectionView *)collectionView chat:(Chat *)chat;

@end
