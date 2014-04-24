//
//  ListServer.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/23/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListServer.h"
#import "ListServerState.h"
#import "AddListItemRequest.h"
#import "AddListItemRequestOperation.h"

@interface ListServer ()

@property (nonatomic, strong) ListServerState *state;
@end

@implementation ListServer

- (id)initWithServiceType:(NSString *)serviceType state:(ListServerState *)state
{
	self = [super initWithServiceType:serviceType];
	if (self) {
		self.state = state;
	}
	
	return self;
}

- (void)start
{
	[super start];
	
	[self.requestHandler registerRequestOperationClass:[AddListItemRequestOperation class] forRequestClass:[AddListItemRequest class]];
}

- (void)addListItem:(NSString *)text
{
	self.state.listItems = [self.state.listItems arrayByAddingObject:text];
}

@end
