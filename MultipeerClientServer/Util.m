//
//  Util.m
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/16/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSString *)stringForSessionState:(MCSessionState)state
{
	switch (state) {
		case MCSessionStateNotConnected:
			return @"MCSessionStateNotConnected";
		case MCSessionStateConnecting:
			return @"MCSessionStateConnecting";
		case MCSessionStateConnected:
			return @"MCSessionStateConnected";
		default:
			return @"Invalid state";
	}
}

@end
