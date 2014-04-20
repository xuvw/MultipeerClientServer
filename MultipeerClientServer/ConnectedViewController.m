//
//  ConnectedViewController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/17/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ConnectedViewController.h"
#import "ConnectedPeersDataSource.h"
#import "MCSPeer.h"

@interface ConnectedViewController () <UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ConnectedPeersDataSource *connectedPeersDataSource;

@end

@implementation ConnectedViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.connectedPeersDataSource = [[ConnectedPeersDataSource alloc] initWithCollectionView:self.collectionView peer:self.peer];
	self.collectionView.delegate = self;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row < self.peer.session.connectedPeers.count) {
		UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
		cell.backgroundColor = [UIColor colorWithHue:0.f saturation:0.f brightness:0.85f alpha:1.f];
	}
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
