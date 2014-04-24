//
//  MCSRequest.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/21/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSRequest.h"

@implementation MCSRequest

- (id)init
{
	self = [super init];
	if (self) {
		self.__uuid = [[NSUUID UUID] UUIDString];
		self.__class = NSStringFromClass([self class]);
	}
	
	return self;
}

+ (DCParserConfiguration *)objectMappingConfiguration
{
	DCParserConfiguration *configuration = [DCParserConfiguration configuration];
	[configuration addObjectMapping:[DCObjectMapping mapKeyPath:@"__uuid" toAttribute:@"__uuid" onClass:[MCSRequest class]]];
	[configuration addObjectMapping:[DCObjectMapping mapKeyPath:@"__class" toAttribute:@"__class" onClass:[self class]]];
	return configuration;
}

- (void)processResponse:(id)response
{
	/**/
}

@end
