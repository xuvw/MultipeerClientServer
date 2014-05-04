//
//  ViewController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ViewController.h"
#import "ListAppClient.h"
#import "ListAppServer.h"
#import "ListAppAPI.h"
#import "ServerBrowserViewController.h"
#import "ListViewController.h"

@interface ViewController () <ServerBrowserViewControllerDelegate>

@property (nonatomic, strong) ListAppClient *client;
@property (nonatomic, strong) ListAppServer *server;
@property (nonatomic, strong) List *list;

- (IBAction)startClient:(id)sender;
- (IBAction)startServer:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.list = [[List alloc] initWithRevision:0 listItems:[NSMutableArray array]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"startClientSegue"]) {
		ServerBrowserViewController *viewController = segue.destinationViewController;
		viewController.multipeerClient = self.client;
		viewController.delegate = self;
	}
	else if ([segue.identifier isEqualToString:@"startServerSegue"]
				|| [segue.identifier isEqualToString:@"joinServerSegue"]) {
		ListViewController *viewController = segue.destinationViewController;
		viewController.listAppAPI = self.server ? self.server : self.client;
		viewController.list = self.list;
	}
}

- (IBAction)startClient:(id)sender
{
	self.list = [[List alloc] initWithRevision:0 listItems:[NSMutableArray array]];
	self.client = [[ListAppClient alloc] initWithServiceType:@"ms-multilist" maxConcurrentOperationCount:3];
	[self performSegueWithIdentifier:@"startClientSegue" sender:sender];
}

- (IBAction)startServer:(id)sender
{
	self.list = [[List alloc] initWithRevision:0 listItems:[NSMutableArray array]];
	self.server = [[ListAppServer alloc] initWithServiceType:@"ms-multilist" list:self.list];
	[self performSegueWithIdentifier:@"startServerSegue" sender:sender];
}

#pragma mark ServerBrowserViewControllerDelegate

- (void)serverBrowserViewController:(ServerBrowserViewController *)viewController wantsToJoinPeer:(MCPeerID *)peerID
{
	if (self.client) {
		[self.client connectToHost:peerID completion:^{
			dispatch_async(dispatch_get_main_queue(), ^{
				[self dismissViewControllerAnimated:YES completion:^{
					[self performSegueWithIdentifier:@"joinServerSegue" sender:self];
				}];
			});
		}];
	}
}

@end
