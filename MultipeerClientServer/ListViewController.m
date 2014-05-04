//
//  ListViewController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListViewController.h"
#import "ListDataSource.h"

@interface ListViewController () <UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ListDataSource *dataSource;
@property (nonatomic, strong) NSTimer *timer;

- (IBAction)addItem:(id)sender;

- (void)scheduleListPolling;
- (void)pollList:(id)sender;

@end

@implementation ListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.dataSource = [[ListDataSource alloc] initWithCollectionView:self.collectionView list:self.list];
	self.collectionView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self scheduleListPolling];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)scheduleListPolling
{
	dispatch_async(dispatch_get_main_queue(), ^{
		self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(pollList:) userInfo:nil repeats:NO];
	});
}

- (void)pollList:(id)sender
{
	[self.listAppAPI getListRevisionWithCompletion:^(int32_t revision) {
		if (self.list.revision < revision) {
			[self.listAppAPI getListWithCompletion:^(List *list) {
				if (list) {
					dispatch_async(dispatch_get_main_queue(), ^{
						self.list.revision = list.revision;
						self.list.listItems = list.listItems;
					});
				}

				[self scheduleListPolling];
			}];
		}
		else {
			[self scheduleListPolling];
		}
	}];
}

- (IBAction)addItem:(id)sender;
{
	ListItem *listItem = [[ListItem alloc] initWithText:@"Test"];
	[self.listAppAPI addListItem:listItem withCompletion:^(int32_t revision) {
		/**/
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
