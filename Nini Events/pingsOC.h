//
//  pingsOC.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 2/24/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pingsOC : NSObject
@property (assign, nonatomic) int tableId;
@property (strong, nonatomic) NSString *tableName, *pingTime, *pingMessage;
@end
