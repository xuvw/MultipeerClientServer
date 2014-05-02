//
//  ListAppAsyncAPI.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 5/1/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "ListAppAPI.h"

@protocol ListAppAsyncAPI <NSObject>

- (void)addListItem:(ListItem *)listItem withCompletion:(void(^)(BOOL success))completion;

@end
