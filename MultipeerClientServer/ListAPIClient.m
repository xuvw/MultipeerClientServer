//
//  ListAPIClient.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/21/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListAPIClient.h"
#import "AddListItemRequest.h"

@interface ListAPIClient ()

@property (nonatomic, strong) MCSPeer *peer;

@end

@implementation ListAPIClient

- (id)initWithPeer:(MCSPeer *)peer
{
	self = [super init];
	if (self) {
		self.peer = peer;
	}
	
	return self;
}

- (void)addListItem:(NSString *)text withCompletion:(void(^)(BOOL success))completion;
{
	AddListItemRequest *request = [[AddListItemRequest alloc] initWithText:text completion:completion];
	[self.peer sendRequest:request];
}

@end
