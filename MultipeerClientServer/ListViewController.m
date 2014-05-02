//
//  ListViewController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListViewController.h"
#import "ListAppAsyncAPI.h"
#import "ListDataSource.h"

@interface ListViewController () <UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ListDataSource *dataSource;

- (IBAction)addItem:(id)sender;

@end

@implementation ListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.dataSource = [[ListDataSource alloc] initWithCollectionView:self.collectionView listServerState:self.state];
	self.collectionView.delegate = self;
}

- (IBAction)addItem:(id)sender;
{
	ListItem *listItem = [[ListItem alloc] initWithText:@"Test"];
	[self.listAppAPI addListItem:listItem withCompletion:^(BOOL success) {
		NSLog(@"addListItem: %d", success);
	}];
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	/*
	if (indexPath.row < self.peer.session.connectedPeers.count) {
		UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
		cell.backgroundColor = [UIColor colorWithHue:0.f saturation:0.f brightness:0.85f alpha:1.f];
	}
	 */
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	cell.backgroundColor = [UIColor colorWithHue:0.f saturation:0.f brightness:0.85f alpha:1.f];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	cell.backgroundColor = [UIColor whiteColor];
}

@end
