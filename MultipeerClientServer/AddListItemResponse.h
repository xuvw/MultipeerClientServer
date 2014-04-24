//
//  AddListItemResponse.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "MCSResponse.h"

@interface AddListItemResponse : MCSResponse

@property (nonatomic, assign, readonly) BOOL success;

- (id)initWithRequest:(MCSRequest *)request success:(BOOL)success;

@end
