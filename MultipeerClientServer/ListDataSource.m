//
//  ListDataSource.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListDataSource.h"
#import "ListServerState.h"
#import "UILabelCollectionViewCell.h"

static void *ListItemsContext = &ListItemsContext;

@interface ListDataSource () <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ListServerState *listServerState;
@end

@implementation ListDataSource

- (id)initWithCollectionView:(UICollectionView *)collectionView listServerState:(ListServerState *)listServerState
{
	self = [super init];
	if (self) {
		self.collectionView = collectionView;
		self.collectionView.dataSource = self;
		
		self.listServerState = listServerState;
		[self.listServerState addObserver:self forKeyPath:@"listItems" options:NSKeyValueObservingOptionNew context:ListItemsContext];
	}
	
	return self;
}

- (void)dealloc
{
	[self.listServerState removeObserver:self forKeyPath:@"listItems"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == ListItemsContext) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.collectionView reloadData];
		});
	}
	else {
		return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.listServerState.listItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UILabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listItemCell" forIndexPath:indexPath];
	if (cell) {
		NSString *text = @"Invalid";
		if (indexPath.row < self.listServerState.listItems.count) {
			text = self.listServerState.listItems[ indexPath.row ];
		}
		
		cell.label.text = text;
	}
	
	return cell;
}

@end
