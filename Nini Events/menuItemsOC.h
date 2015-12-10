//
//  menuItemsOC.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 12/9/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface menuItemsOC : NSObject
@property (strong,nonatomic) NSString *ItemName,* Cuisine, *type, *Image,*Price;
@property (assign, nonatomic) int ItemId,Quantity,IsDeletedItem,categoryId;
@end
