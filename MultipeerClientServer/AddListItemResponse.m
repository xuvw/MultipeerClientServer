//
//  AddListItemResponse.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "AddListItemResponse.h"
#import "DCParserConfiguration.h"
#import "DCObjectMapping.h"

@interface AddListItemResponse ()

@property (nonatomic, assign) BOOL success;

@end

@implementation AddListItemResponse

- (id)initWithRequest:(MCSRequest *)request success:(BOOL)success
{
	self = [super initWithRequest:request];
	if (self) {
		self.success = success;
	}
	
	return self;
}

+ (DCParserConfiguration *)objectMappingConfiguration
{
	DCParserConfiguration *configuration = [super objectMappingConfiguration];
	[configuration addObjectMapping:[DCObjectMapping mapKeyPath:@"success" toAttribute:@"success" onClass:[AddListItemResponse class]]];
	return configuration;
}

@end
