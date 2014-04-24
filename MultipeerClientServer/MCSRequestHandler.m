//
//  MCSRequestHandler.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSRequestHandler.h"
#import "MCSServer.h"
#import "MCSRequest.h"
#import "MCSRequestOperation.h"
#import "DCKeyValueObjectMapping.h"

@interface MCSRequestHandler ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSDictionary *requestMap;
@property (nonatomic, strong) NSDictionary *requestOperationMap;
@end

@implementation MCSRequestHandler

- (id)init
{
	self = [super init];
	if (self) {
		self.operationQueue = [[NSOperationQueue alloc] init];
		self.operationQueue.maxConcurrentOperationCount = 2;
	}
	
	return self;
}

- (void)registerRequestOperationClass:(Class)requestOperationClass forRequestClass:(Class)requestClass
{
	if ([requestClass isSubclassOfClass:[MCSRequest class]]) {
		NSString *className = NSStringFromClass(requestClass);
		if (className) {
			NSMutableDictionary *mutableRequestMap = [NSMutableDictionary dictionaryWithDictionary:self.requestMap];
			mutableRequestMap[ className ] = requestClass;
			self.requestMap = [NSDictionary dictionaryWithDictionary:mutableRequestMap];
			
			NSMutableDictionary *mutableRequestOperationMap = [NSMutableDictionary dictionaryWithDictionary:self.requestOperationMap];
			mutableRequestOperationMap[ className ] = requestOperationClass;
			self.requestOperationMap = [NSDictionary dictionaryWithDictionary:mutableRequestOperationMap];
		}
	}
}

- (void)handleRequestData:(NSData *)data fromPeer:(MCPeerID *)peerID withServer:(MCSServer *)server
{
	NSError *error = nil;
	NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	if (error) {
		NSLog( @"MCSRequestHandler was unable to process request data. Error: %@", error.localizedDescription);
	}
	else {
		NSString *__uuid = jsonDict[ @"__uuid" ];
		NSString *__class = jsonDict[ @"__class" ];
		
		if (!__uuid || !__class) {
			NSLog(@"Error.");
			return;
		}
		else {
			Class requestClass = self.requestMap[ __class ];
			DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:requestClass andConfiguration:[requestClass objectMappingConfiguration]];
			id request = [parser parseDictionary:jsonDict];
			
			Class requestOperationClass = self.requestOperationMap[ __class ];
			MCSRequestOperation *requestOperation = [[requestOperationClass alloc] initWithRequest:request server:server];
			__weak MCSRequestOperation *weakRequestOperation = requestOperation;
			requestOperation.completionBlock = ^{
				NSError *error = nil;
				[server.session sendData:weakRequestOperation.responseData toPeers:@[ peerID ] withMode:MCSessionSendDataReliable error:&error];
				if (error) {
					NSLog(@"Error: %@", error.localizedDescription);
				}
			};
			
			[self.operationQueue addOperation:requestOperation];
		}
	}
}

- (void)processLocalRequest:(MCSRequest *)request withServer:(MCSServer *)server
{
	NSString *className = NSStringFromClass([request class]);
	Class requestOperationClass = self.requestOperationMap[ className ];
	MCSRequestOperation *requestOperation = [[requestOperationClass alloc] initWithRequest:request server:server];
	__weak MCSRequestOperation *weakRequestOperation = requestOperation;
	requestOperation.completionBlock = ^{
		[request processResponse:weakRequestOperation.responseObject];
	};
	
	[self.operationQueue addOperation:requestOperation];
}

@end
