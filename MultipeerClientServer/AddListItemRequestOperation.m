//
//  AddListItemRequestOperation.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "AddListItemRequestOperation.h"
#import "AddListItemRequest.h"
#import "AddListItemResponse.h"
#import "ListServer.h"
#import "DCKeyValueObjectMapping.h"

@interface AddListItemRequestOperation()

@property (nonatomic, strong) AddListItemRequest *request;
@property (nonatomic, strong) AddListItemResponse *response;
@property (nonatomic, strong) ListServer *server;
@end

@implementation AddListItemRequestOperation

- (id)initWithRequest:(id)request server:(id)server
{
	self = [super init];
	if (self) {
		self.request = request;
		self.server = server;
	}
	
	return self;
}

- (id)responseObject
{
	return self.response;
}

- (NSData *)responseData
{
	NSData *responseData = nil;
	
	DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[self.response class] andConfiguration:[[self.response class] objectMappingConfiguration]];
	NSDictionary *jsonDict = [parser serializeObject:self.response];
	if (!jsonDict) {
		NSLog(@"Error.");
	}
	else {
		NSError *error = nil;
		responseData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
		if (error) {
			NSLog(@"Error.");
		}
	}

	return responseData;
}

- (void)main
{
	[self.server addListItem:self.request.text];
	
	self.response = [[AddListItemResponse alloc] initWithRequest:self.request success:YES];
}

@end
