//
//  ViewController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ViewController.h"
#import "MultipeerClient.h"
#import "MultipeerServer.h"
#import "ServerBrowserViewController.h"

@interface ViewController ()

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MultipeerClient *client;
@property (nonatomic, strong) MultipeerServer *server;

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
	}
	else if ([segue.identifier isEqualToString:@"startServerSegue"]) {
		
	}
}

- (IBAction)startClient:(id)sender
{
	[self createSession];
	self.client = [[MultipeerClient alloc] initWithSession:self.session serviceType:@"ms-multichat"];
	[self performSegueWithIdentifier:@"startClientSegue" sender:sender];
}

- (IBAction)startServer:(id)sender
{
	[self createSession];
	self.server = [[MultipeerServer alloc] initWithSession:self.session serviceType:@"ms-multichat" guid:[[NSUUID UUID] UUIDString]];
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

@end
