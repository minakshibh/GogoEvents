//
//  placeOrderOC.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 11/21/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceOrderData : NSObject
@property (assign, nonatomic) int ItemId, Quantity, Price;
@property (strong, nonatomic) NSString * itemName;
@end
