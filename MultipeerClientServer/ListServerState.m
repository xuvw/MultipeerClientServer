//
//  ListServerState.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/23/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListServerState.h"

@implementation ListServerState

- (id)init
{
	self = [super init];
	if (self) {
		self.listItems = [NSArray array];
	}
	
	return self;
}

@end
