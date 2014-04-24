//
//  AddListItemRequest.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSRequest.h"

@interface AddListItemRequest : MCSRequest

@property (nonatomic, copy, readonly) NSString *text;

- (id)initWithText:(NSString *)text completion:(void(^)(BOOL success))completion;

@end
