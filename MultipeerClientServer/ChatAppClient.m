//
//  ChatAppClient.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/30/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatAppClient.h"
#import "ChatAppAPI.h"
#import "TBinaryProtocol.h"
#import "TNSStreamTransport.h"

static void *ConnectedContext = &ConnectedContext;

@interface ChatAppClient ()

@property (nonatomic, strong) NSMutableSet *clients;
@property (nonatomic, strong) NSMutableSet *activeClients;
@property (nonatomic, strong) NSOperation *chatPollingOperation;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, assign) NSUInteger maxConcurrentOperationCount;

- (void)createStreams;
- (ChatAppAPIClient *)dequeueClient;

@end

@implementation ChatAppClient

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
			ChatAppAPIClient *client = [[ChatAppAPIClient alloc] initWithProtocol:protocol];
			[self.clients addObject:client];
			self.operationQueue.maxConcurrentOperationCount = self.clients.count;
		}];
	}
}

- (ChatAppAPIClient *)dequeueClient
{
	ChatAppAPIClient *client = self.clients.anyObject;
	if (client) {
		[self.activeClients addObject:client];
		[self.clients removeObject:client];
	}
	
	return client;
}

#pragma mark ChatAppAsyncAPI

- (void)addMessage:(Message *)message withCompletion:(void(^)(int32_t revision))completion
{
	if (completion) {
		ChatAppAPIClient *client = [self dequeueClient];
		if (!client) {
			completion(0);
		}
		else {
			NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
				int32_t result = [client addMessage:message];
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

- (void)getChatRevisionWithCompletion:(void(^)(int32_t revision))completion
{
	if (completion) {
		ChatAppAPIClient *client = [self dequeueClient];
		if (!client) {
			completion(0);
		}
		else {
			NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
				int32_t revision = [client getChatRevision];
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

- (void)getChatWithCompletion:(void(^)(Chat *chat))completion
{
	if (completion) {
		dispatch_async(dispatch_get_main_queue(), ^{
			ChatAppAPIClient *client = [self dequeueClient];
			if (!client) {
				completion(nil);
			}
			else {
				NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
					Chat *chat = [client getChat];
					if (completion) {
						completion(chat);
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
