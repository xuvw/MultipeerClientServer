//
//  Util.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/16/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

@interface Util : NSObject

+ (NSString *)stringForSessionState:(MCSessionState)state;

@end
