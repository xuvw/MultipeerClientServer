//
//  ServerBrowserViewController.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/15/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import UIKit;

@class MultipeerClient;

@interface ServerBrowserViewController : UIViewController

@property (nonatomic, strong) MultipeerClient *multipeerClient;

@end
