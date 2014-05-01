//
//  MCSStreamRequest.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/29/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;

typedef void (^StreamRequestCompletionBlock)(NSInputStream *inputStream, NSOutputStream *outputStream);

@interface MCSStreamRequest : NSObject

@property (nonatomic, strong, readonly) NSOutputStream *outputStream;
@property (nonatomic, copy, readonly) StreamRequestCompletionBlock completion;

- (id)initWithOutputStream:(NSOutputStream *)outputStream completion:(StreamRequestCompletionBlock)completion;

@end
