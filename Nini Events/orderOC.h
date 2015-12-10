//
//  orderOC.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 11/21/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderOC : NSObject
@property (strong,nonatomic) NSString *orderItemName,* oredercuisine,*orderType,*orderImage;
@property (assign, nonatomic) int orderPrice,orderID,orderItemID,orderQuantity;
@end
