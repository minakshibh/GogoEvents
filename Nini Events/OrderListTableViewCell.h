//
//  OrderListTableViewCell.h
//  Nini Events
//
//  Created by Br@R on 09/02/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderNumLbl;
@property (strong, nonatomic) IBOutlet UILabel *orderStatusLbl;
@property (strong, nonatomic) IBOutlet UILabel *orderTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *itemNames;

-(void)setLabelText:(NSString*)orderstatus :(NSString*)OrderTime :(NSString*)orderId :(NSString*)itemNames;
-(void)setLabelText1:(NSString*)itemName :(NSString*)quantity :(NSString*)price :(NSString*)itemNames;

@end
