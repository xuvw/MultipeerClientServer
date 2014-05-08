//
//  ChatAppServer.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/30/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ChatAppServer.h"
#import "ChatAppAPI.h"
#import "TSharedProcessorFactory.h"
#import "TBinaryProtocol.h"
#import "TNSStreamTransport.h"
#import "TTransportException.h"

@interface ChatAppServer () <ChatAppAPI, MCSServerDelegate>

@property (nonatomic, strong) Chat *chat;
@property (nonatomic, strong) NSMutableDictionary *peerProcessorMap;

- (void)addProcessor:(id<TProcessor>)processor forPeer:(MCPeerID *)peerID;

@end

@implementation ChatAppServer

- (id)initWithServiceType:(NSString *)serviceType chat:(Chat *)chat
{
	self = [super initWithServiceType:serviceType];
	if (self) {
		self.chat = chat;
		self.peerProcessorMap = [NSMutableDictionary dictionary];
		self.delegate = self;
	}
	
	return self;
}

- (void)addProcessor:(id<TProcessor>)processor forPeer:(MCPeerID *)peerID
{
	NSMutableArray *processors = self.peerProcessorMap[ peerID ];
	if (!processors) {
		processors = [NSMutableArray array];
		self.peerProcessorMap[ peerID ] = processors;
	}
	
	[processors addObject:processor];
}

#pragma mark ChatAppAsyncAPI

- (void)addMessage:(Message *)message withCompletion:(void(^)(int32_t revision))completion
{
	if (completion) {
		int32_t result = [self addMessage:message];
		completion(result);
	}
}

- (void)getChatRevisionWithCompletion:(void(^)(int32_t revision))completion
{
	if (completion) {
		int32_t revision = [self getChatRevision];
		completion(revision);
	}
}

- (void)getChatWithCompletion:(void(^)(Chat *chat))completion
{
	if (completion) {
		Chat *chat = [self getChat];
		completion(chat);
	}
}

#pragma mark ChatAppAPI

- (int32_t)addMessage:(Message *)message
{
	[self.chat.messages addObject:message];
	self.chat.revision = self.chat.revision + 1;
	return self.chat.revision;
}

- (int32_t)getChatRevision
{
	return self.chat.revision;
}

- (Chat *)getChat
{
	return self.chat;
}

#pragma mark MCSServerDelegate

- (void)multipeerServer:(MCSServer *)server didDisconnectPeer:(MCPeerID *)peerID
{
	[self.peerProcessorMap removeObjectForKey:peerID];
}

- (void)multipeerServer:(MCSServer *)server didStartInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream forPeer:(MCPeerID *)peerID
{
	TNSStreamTransport *transport = [[TNSStreamTransport alloc] initWithInputStream:inputStream outputStream:outputStream];
	TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
	ChatAppAPIProcessor *processor = [[ChatAppAPIProcessor alloc] initWithChatAppAPI:self];
	[self addProcessor:processor forPeer:peerID];

	@try {
		BOOL result = NO;
		do {
			@autoreleasepool {
				result = [processor processOnInputProtocol:protocol outputProtocol:protocol];
			}
		} while (result);
	}
	@catch (TTransportException *exception) {
		NSLog(@"Caught transport exception, abandoning client connection: %@", exception);
	}
}

@end
