//
//  ListViewController.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/22/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import UIKit;

@class ListServerState;
@class ListAppAPI;

@interface ListViewController : UIViewController

@property (nonatomic, strong) ListServerState *state;
@property (nonatomic, strong) ListAppAPI *listAppAPI;

@end
