//
//  AddListItemRequest.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "AddListItemRequest.h"
#import "AddListItemResponse.h"

@interface AddListItemRequest ()

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void(^completion)(BOOL success);

@end

@implementation AddListItemRequest

- (id)initWithText:(NSString *)text completion:(void(^)(BOOL success))completion;
{
	self = [super init];
	if (self) {
		self.text = text;
		self.completion = completion;
	}
	
	return self;
}

- (void)processResponse:(AddListItemResponse *)response;
{
	if (self.completion) {
		self.completion(response.success);
	}
}

+ (DCParserConfiguration *)objectMappingConfiguration
{
	DCParserConfiguration *configuration = [super objectMappingConfiguration];
	[configuration addObjectMapping:[DCObjectMapping mapKeyPath:@"text" toAttribute:@"text" onClass:[AddListItemRequest class]]];
	return configuration;
}

@end
