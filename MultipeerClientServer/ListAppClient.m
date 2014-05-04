//
//  ListAppClient.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/30/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListAppClient.h"
#import "ListAppAPI.h"
#import "TBinaryProtocol.h"
#import "TNSStreamTransport.h"

static void *ConnectedContext = &ConnectedContext;

@interface ListAppClient ()

@property (nonatomic, strong) NSMutableSet *clients;
@property (nonatomic, strong) NSMutableSet *activeClients;
@property (nonatomic, strong) NSOperation *listPollingOperation;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, assign) NSUInteger maxConcurrentOperationCount;

- (void)createStreams;
- (ListAppAPIClient *)dequeueClient;

@end

@implementation ListAppClient

- (id)initWithServiceType:(NSString *)serviceType maxConcurrentOperationCount:(NSUInteger)maxConcurrentOperationCount
{
	self = [super initWithServiceType:serviceType];
	if (self) {
		self.clients = [NSMutableSet set];
		self.activeClients = [NSMutableSet set];
		self.operationQueue = [[NSOperationQueue alloc] init];
		self.operationQueue.maxConcurrentOperationCount = 0;
		self.maxConcurrentOperationCount = maxConcurrentOperationCount;
		
		[self addObserver:self forKeyPath:@"connected" options:NSKeyValueObservingOptionNew context:ConnectedContext];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == ConnectedContext) {
		if (self.connected ) {
			[self createStreams];
		}
	}
	else {
		return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)createStreams
{
	for (int i = 0; i < self.maxConcurrentOperationCount; ++i) {
		[self createStreamToHostWithCompletion:^(NSInputStream *inputStream, NSOutputStream *outputStream) {
			TNSStreamTransport *transport = [[TNSStreamTransport alloc] initWithInputStream:inputStream outputStream:outputStream];
			TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
			ListAppAPIClient *client = [[ListAppAPIClient alloc] initWithProtocol:protocol];
			[self.clients addObject:client];
			self.operationQueue.maxConcurrentOperationCount = self.clients.count;
		}];
	}
}

- (ListAppAPIClient *)dequeueClient
{
	ListAppAPIClient *client = self.clients.anyObject;
	if (client) {
		[self.activeClients addObject:client];
		[self.clients removeObject:client];
	}
	
	return client;
}

#pragma mark ListAppAsyncAPI

- (void)addListItem:(ListItem *)listItem withCompletion:(void(^)(int32_t revision))completion
{
	if (completion) {
		ListAppAPIClient *client = [self dequeueClient];
		if (!client) {
			completion(0);
		}
		else {
			NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
				int32_t result = [client addListItem:listItem];
				completion(result);
			}];
			
			operation.completionBlock = ^{
				dispatch_async(dispatch_get_main_queue(), ^{
					[self.clients addObject:client];
				});
			};
			
			[self.operationQueue addOperation:operation];
		}
	}
}

- (void)getListRevisionWithCompletion:(void(^)(int32_t revision))completion
{
	if (completion) {
		ListAppAPIClient *client = [self dequeueClient];
		if (!client) {
			completion(0);
		}
		else {
			NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
				int32_t revision = [client getListRevision];
				completion(revision);
			}];
			
			operation.completionBlock = ^{
				dispatch_async(dispatch_get_main_queue(), ^{
					[self.clients addObject:client];
				});
			};
			
			[self.operationQueue addOperation:operation];
		}
	}
}

- (void)getListWithCompletion:(void(^)(List *list))completion
{
	if (completion) {
		dispatch_async(dispatch_get_main_queue(), ^{
			ListAppAPIClient *client = [self dequeueClient];
			if (!client) {
				completion(nil);
			}
			else {
				NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
					List *list = [client getList];
					if (completion) {
						completion(list);
					}
				}];
				
				operation.completionBlock = ^{
					[self.clients addObject:client];
				};
				
				[self.operationQueue addOperation:operation];
			}
		});
	}
}

@end
