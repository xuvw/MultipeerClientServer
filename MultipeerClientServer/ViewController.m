//
//  ViewController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ViewController.h"
#import "MCSClient.h"
#import "ListServer.h"
#import "ServerBrowserViewController.h"
#import "ListViewController.h"
#import "ListAPIClient.h"

@interface ViewController () <ServerBrowserViewControllerDelegate>

@property (nonatomic, strong) MCSClient *client;
@property (nonatomic, strong) ListServer *server;
@property (nonatomic, strong) ListServerState *state;

- (IBAction)startClient:(id)sender;
- (IBAction)startServer:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.state = [[ListServerState alloc] init];
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
		viewController.state = self.state;
		viewController.listAPIClient = [[ListAPIClient alloc] initWithPeer:(self.server ? self.server : self.client)];
	}
}

- (IBAction)startClient:(id)sender
{
	self.client = [[MCSClient alloc] initWithServiceType:@"ms-multichat"];
	[self.client start];
	[self performSegueWithIdentifier:@"startClientSegue" sender:sender];
}

- (IBAction)startServer:(id)sender
{
	self.server = [[ListServer alloc] initWithServiceType:@"ms-multichat" state:self.state];
	[self.server start];
	[self performSegueWithIdentifier:@"startServerSegue" sender:sender];
}

#pragma mark ServerBrowserViewControllerDelegate

- (void)serverBrowserViewController:(ServerBrowserViewController *)viewController wantsToJoinPeer:(MCPeerID *)peerID
{
	if (self.client) {
		[self.client connectToHost:peerID];
		[self dismissViewControllerAnimated:YES completion:^{
			[self performSegueWithIdentifier:@"joinServerSegue" sender:self];
		}];
	}
}

@end
