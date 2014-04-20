//
//  ConnectedViewController.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/17/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import UIKit;

@class MCSPeer;

@interface ConnectedViewController : UIViewController

@property (nonatomic, strong) MCSPeer *peer;

@end
