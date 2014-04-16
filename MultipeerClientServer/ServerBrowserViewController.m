//
//  ServerBrowserViewController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ServerBrowserViewController.h"
#import "NearbyServersDataSource.h"
#import "MultipeerClient.h"
#import "NearbyServer.h"

@interface ServerBrowserViewController () <UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NearbyServersDataSource *nearbyServersDataSource;

@end

@implementation ServerBrowserViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.nearbyServersDataSource = [[NearbyServersDataSource alloc] initWithCollectionView:self.collectionView multipeerClient:self.multipeerClient];
	self.collectionView.delegate = self;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row < self.multipeerClient.nearbyServers.count) {
		NearbyServer *nearbyServer = self.multipeerClient.nearbyServers[ indexPath.row ];
		[self.multipeerClient connectToHost:nearbyServer.peerID];
	}
}

@end
