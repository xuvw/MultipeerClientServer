//
//  ListDataSource.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListDataSource.h"
#import "ListAppState.h"
#import "UILabelCollectionViewCell.h"

static void *ListItemsContext = &ListItemsContext;

@interface ListDataSource () <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ListAppState *listAppState;
@end

@implementation ListDataSource

- (id)initWithCollectionView:(UICollectionView *)collectionView listAppState:(ListAppState *)listAppState
{
	self = [super init];
	if (self) {
		self.collectionView = collectionView;
		self.collectionView.dataSource = self;
		
		self.listAppState = listAppState;
		[self.listAppState addObserver:self forKeyPath:@"listItems" options:NSKeyValueObservingOptionNew context:ListItemsContext];
	}
	
	return self;
}

- (void)dealloc
{
	[self.listAppState removeObserver:self forKeyPath:@"listItems"];
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
	return self.listAppState.listItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UILabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listItemCell" forIndexPath:indexPath];
	if (cell) {
		NSString *text = @"Invalid";
		if (indexPath.row < self.listAppState.listItems.count) {
			text = self.listAppState.listItems[ indexPath.row ];
		}
		
		cell.label.text = text;
	}
	
	return cell;
}

@end
