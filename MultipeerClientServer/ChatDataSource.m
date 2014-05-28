//
//  ChatDataSource.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatDataSource.h"
#import "ChatAppAPI.h"

static void *ChatRevisionContext = &ChatRevisionContext;

@interface ChatDataSource () <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) Chat *chat;

@end

@implementation ChatDataSource

- (id)initWithCollectionView:(UICollectionView *)collectionView chat:(Chat *)chat
{
	self = [super init];
	if (self) {
		self.collectionView = collectionView;
		self.collectionView.dataSource = self;

		self.chat = chat;
		[self.chat addObserver:self forKeyPath:@"revision" options:NSKeyValueObservingOptionNew context:ChatRevisionContext];
	}
	
	return self;
}

- (void)dealloc
{
	[self.chat removeObserver:self forKeyPath:@"revision"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == ChatRevisionContext) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.collectionView reloadData];
		});
	}
	else {
		return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (Message *)messageAtIndexPath:(NSIndexPath *)indexPath
{
	return self.chat.messages[ indexPath.row ];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.chat.messages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end
