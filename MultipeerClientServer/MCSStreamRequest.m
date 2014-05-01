//
//  MCSStreamRequest.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/29/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSStreamRequest.h"

@interface MCSStreamRequest ()

@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, copy) StreamRequestCompletionBlock completion;

@end

@implementation MCSStreamRequest

- (id)initWithOutputStream:(NSOutputStream *)outputStream completion:(StreamRequestCompletionBlock)completion
{
	self = [super init];
	if (self) {
		self.outputStream = outputStream;
		self.completion = completion;
	}
	
	return self;
}

@end
