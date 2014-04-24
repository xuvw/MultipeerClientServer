//
//  MCSResponse.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/23/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;

#import "MCSRequest.h"
#import "DCParserConfiguration.h"
#import "DCObjectMapping.h"

@interface MCSResponse : NSObject

@property (nonatomic, copy) NSString *__uuid;
@property (nonatomic, copy) NSString *__class;

- (id)initWithRequest:(MCSRequest *)request;

+ (DCParserConfiguration *)objectMappingConfiguration;

@end
