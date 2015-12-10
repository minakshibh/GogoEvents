//
//  menuOC.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 12/9/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface menuOC : NSObject
@property (strong,nonatomic) NSString *categoryName,* type, *imageUrl;
@property (assign, nonatomic) int categoryID,isDeleted;
@property (strong, nonatomic) NSArray *itemsList;
@end
