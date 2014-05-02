//
//  ListAppState.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/23/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListAppState.h"

@implementation ListAppState

- (id)init
{
	self = [super init];
	if (self) {
		self.listItems = [NSArray array];
	}
	
	return self;
}

@end
