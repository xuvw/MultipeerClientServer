//
//  MCSResponse.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/23/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSResponse.h"

@implementation MCSResponse

- (id)initWithRequest:(MCSRequest *)request
{
	self = [super init];
	if (self) {
		self.__uuid = request.__uuid;
		self.__class = NSStringFromClass([self class]);
	}
	
	return self;
}

+ (DCParserConfiguration *)objectMappingConfiguration
{
	DCParserConfiguration *configuration = [DCParserConfiguration configuration];
	[configuration addObjectMapping:[DCObjectMapping mapKeyPath:@"__uuid" toAttribute:@"__uuid" onClass:[MCSResponse class]]];
	[configuration addObjectMapping:[DCObjectMapping mapKeyPath:@"__class" toAttribute:@"__class" onClass:[self class]]];
	return configuration;
}

@end
