//
//  ConnectedPeersDataSource.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/17/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ConnectedPeersDataSource.h"
#import "UILabelCollectionViewCell.h"
#import "MCSPeer.h"

static void *ConnectedPeersContext = &ConnectedPeersContext;

@interface ConnectedPeersDataSource () <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MCSPeer *peer;
@property (nonatomic, strong) MCSession *session;

@end

@implementation ConnectedPeersDataSource

- (id)initWithCollectionView:(UICollectionView *)collectionView peer:(MCSPeer *)peer
{
	self = [super init];
	if (self)
	{
		self.collectionView = collectionView;
		self.collectionView.dataSource = self;
		self.peer = peer;
		self.session = self.peer.session;
		
		[self.peer addObserver:self forKeyPath:@"connectedPeers" options:NSKeyValueObservingOptionNew context:ConnectedPeersContext];
	}
	
	return self;
}

- (void)dealloc
{
	[self.peer removeObserver:self forKeyPath:@"connectedPeers"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == ConnectedPeersContext) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.collectionView reloadData];
			NSLog(@"hey");
		});
	}
	else {
		return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.peer.session.connectedPeers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UILabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"connectedPeerCell" forIndexPath:indexPath];
	if (cell) {
		NSString *connectedPeerName = @"Untitled Peer";
		if (indexPath.row < self.peer.connectedPeers.count) {
			MCPeerID *connectedPeer = self.peer.connectedPeers[ indexPath.row ];
			connectedPeerName = connectedPeer.displayName;
		}
		
		cell.label.text = connectedPeerName;
	}
	
	return cell;
}

@end
