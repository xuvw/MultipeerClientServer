//
//  ListDataSource.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListDataSource.h"
#import "ListAppAPI.h"
#import "UILabelCollectionViewCell.h"

static void *ListItemsContext = &ListItemsContext;

@interface ListDataSource () <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) List *list;
@end

@implementation ListDataSource

- (id)initWithCollectionView:(UICollectionView *)collectionView list:(List *)list
{
	self = [super init];
	if (self) {
		self.collectionView = collectionView;
		self.collectionView.dataSource = self;

		self.list = list;
		[self.list addObserver:self forKeyPath:@"revision" options:NSKeyValueObservingOptionNew context:ListItemsContext];
	}
	
	return self;
}

- (void)dealloc
{
	[self.list removeObserver:self forKeyPath:@"revision"];
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
	return self.list.listItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UILabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listItemCell" forIndexPath:indexPath];
	if (cell) {
		NSString *text = @"Invalid";
		if (indexPath.row < self.list.listItems.count) {
			ListItem *listItem = self.list.listItems[ indexPath.row ];
			text = listItem.text;
		}
		
		cell.label.text = text;
	}
	
	return cell;
}

@end
