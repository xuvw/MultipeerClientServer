//
//  ViewController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ViewController.h"
#import "MCSClient.h"
#import "MCSServer.h"
#import "ServerBrowserViewController.h"
#import "ConnectedViewController.h"

@interface ViewController () <ServerBrowserViewControllerDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCSClient *client;
@property (nonatomic, strong) MCSServer *server;

- (IBAction)startClient:(id)sender;
- (IBAction)startServer:(id)sender;

- (void)createSession;

@end

@implementation ViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"startClientSegue"]) {
		ServerBrowserViewController *viewController = segue.destinationViewController;
		viewController.multipeerClient = self.client;
		viewController.delegate = self;
	}
	else if ([segue.identifier isEqualToString:@"startServerSegue"]
				|| [segue.identifier isEqualToString:@"joinServerSegue"]) {
		ConnectedViewController *viewController = segue.destinationViewController;
		viewController.peer = self.server ? self.server : self.client;
	}
}

- (IBAction)startClient:(id)sender
{
	[self createSession];
	self.client = [[MCSClient alloc] initWithSession:self.session serviceType:@"ms-multichat"];
	[self performSegueWithIdentifier:@"startClientSegue" sender:sender];
}

- (IBAction)startServer:(id)sender
{
	[self createSession];
	self.server = [[MCSServer alloc] initWithSession:self.session serviceType:@"ms-multichat"];
	[self performSegueWithIdentifier:@"startServerSegue" sender:sender];
}

- (void)createSession
{
	self.client = nil;
	self.server = nil;
	
	if (!self.session) {
		self.peerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
		self.session = [[MCSession alloc] initWithPeer:self.peerID];
	}
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
