//
//  MCSRequest.h
//  MultipeerClientServer
//
//  Created by Mark Stultz on 4/21/14.
//  Copyright (c) 2014 Mark Stultz. All rights reserved.
//

@import Foundation;

#import "DCParserConfiguration.h"
#import "DCObjectMapping.h"

@interface MCSRequest : NSObject

@property (nonatomic, copy) NSString *__uuid;
@property (nonatomic, copy) NSString *__class;

+ (DCParserConfiguration *)objectMappingConfiguration;

- (void)processResponse:(id)response;

@end
