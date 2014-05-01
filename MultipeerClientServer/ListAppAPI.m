//
//  ListAppAPI.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/28/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListAppAPI.h"
#import "ListApp.h"
#import "TBinaryProtocol.h"
#import "TNSStreamTransport.h"

@interface ListAppAPI ()

@property (nonatomic, strong) MCSPeer *peer;
@property (nonatomic, strong) NSMutableSet *clients;
@property (nonatomic, strong) NSMutableSet *activeClients;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

- (ListAppClient *)dequeueClient;

@end

@implementation ListAppAPI

- (id)initWithPeer:(MCSPeer *)peer maxConcurrentOperationCount:(NSUInteger)maxConcurrentOperationCount
{
	self = [super init];
	if (self) {
		self.peer = peer;
		self.clients = [NSMutableSet set];
		self.activeClients = [NSMutableSet set];
		self.operationQueue = [[NSOperationQueue alloc] init];
		self.operationQueue.maxConcurrentOperationCount = 0;
		
		for (int i = 0; i < maxConcurrentOperationCount; ++i) {
			[self.peer createStreamToHostWithCompletion:^(NSInputStream *inputStream, NSOutputStream *outputStream) {
				TNSStreamTransport *transport = [[TNSStreamTransport alloc] initWithInputStream:inputStream outputStream:outputStream];
				TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
				ListAppClient *client = [[ListAppClient alloc] initWithProtocol:protocol];
				[self.clients addObject:client];
				self.operationQueue.maxConcurrentOperationCount = self.clients.count;
			}];
		}
	}
	
	return self;
}

- (void)addListItem:(ListItem *)listItem withCompletion:(void(^)(BOOL success))completion;
{
	ListAppClient *client = [self dequeueClient];
	NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
		BOOL result = [client addListItem:listItem];
		if (completion) {
			completion(result);
		}
	}];
	
	operation.completionBlock = ^{
		[self.clients addObject:client];
	};
	
	[self.operationQueue addOperation:operation];
}

- (ListAppClient *)dequeueClient
{
	ListAppClient *client = self.clients.anyObject;
	if (client) {
		[self.activeClients addObject:client];
		[self.clients removeObject:client];
	}
	
	return client;
}

@end
