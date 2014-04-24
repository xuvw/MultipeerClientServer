//
//  MCSRequestController.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSRequestController.h"
#import "DCKeyValueObjectMapping.h"

@interface MCSRequestController ()

@property (nonatomic, strong) NSMutableDictionary *requests;

@end

@implementation MCSRequestController

- (id)init
{
	self = [super init];
	if (self) {
		self.requests = [NSMutableDictionary dictionary];
	}
	
	return self;
}

- (void)sendRequest:(MCSRequest *)request toPeer:(MCPeerID *)peerID withSession:(MCSession *)session
{
	if (!request.__uuid
		 || (request.__uuid.length == 0)
		 || self.requests[ request.__uuid ]) {
		const int maxRetry = 10;
		for (int i = 0; i < maxRetry; ++i) {
			NSString *uuid = [[NSUUID UUID] UUIDString];
			if (!self.requests[ request.__uuid]) {
				request.__uuid = uuid;
				break;
			}
		}
		
		NSLog(@"MCSRequestController was (somehow) unable to create a UUID for request: %@", NSStringFromClass([request class]));
		return;
	}
	
	self.requests[ request.__uuid ] = request;
	
	DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[request class] andConfiguration:[[request class] objectMappingConfiguration]];
	NSDictionary *jsonDict = [parser serializeObject:request];
	if (!jsonDict) {
		NSLog(@"MCSRequestController was unable to serialize JSON object");
	}
	else {
		NSLog(@"dict: %@", jsonDict);
		
		NSError *error = nil;
		NSData *data = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
		if (error) {
			NSLog(@"MCSRequestController was unable to serialize request to JSON data object: %@", error.localizedDescription);
		}
		else {
			error = nil;
			[session sendData:data toPeers:@[ peerID ] withMode:MCSessionSendDataReliable error:&error];
			if (error) {
				NSLog(@"MCSRequestController was unable to send request with MultipeerConnectivity. Error: %@", error.localizedDescription);
			}
		}
	}
}

- (void)processResponseData:(NSData *)responseData
{
	if (!responseData) {
		NSLog(@"MCSRequestController was unable to process a nil response data");
	}
	else {
		NSError *error = nil;
		NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
		if (error) {
			NSLog( @"MCSRequestController was unable to process response data. Error: %@", error.localizedDescription);
		}
		else {
			NSString *uuid = jsonDict[ @"__uuid" ];
			NSString *className = jsonDict[ @"__class" ];
			
			if (!uuid || !className) {
				NSLog( @"MCSRequestController was unable to create a response for JSON data: %@", jsonDict);
			}
			else {
				MCSRequest *request = self.requests[ uuid ];
				if (!request) {
					NSLog( @"MCSRequestController couldn't find request for: %@", uuid);
				}
				else {
					Class responseClass = NSClassFromString(className);
					DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:responseClass andConfiguration:[responseClass objectMappingConfiguration]];
					id response = [parser parseDictionary:jsonDict];
					[request processResponse:response];
				}
			}
		}
	}
}

@end
