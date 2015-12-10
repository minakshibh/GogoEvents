//
//  pendingOrdersOC.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 11/21/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pendingOrdersOC : NSObject

@property (strong, nonatomic) NSString *DateTimeOfOrder,*LastUpdate,*Status,*TimeOfDelivery,*TotalBill,*OrderId,*RestaurantId,*TableId,*lastUpdatedTime,*tableType,*note;
@property (strong, nonatomic) NSArray *pendingOrderDetails;
@property (strong, nonatomic) NSString *comments,*isCompleted,*requestid;
@property (strong, nonatomic) NSDictionary *requestData;
@end
