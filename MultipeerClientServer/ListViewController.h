//
//  ListViewController.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import UIKit;

#import "ListAppAsyncAPI.h"

@interface ListViewController : UIViewController

@property (nonatomic, strong) List *list;
@property (nonatomic, strong) id<ListAppAsyncAPI> listAppAPI;

@end
