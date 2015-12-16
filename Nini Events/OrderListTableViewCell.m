//
//  OrderListTableViewCell.m
//  Nini Events
//
//  Created by Br@R on 09/02/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import "AppDelegate.h"

@implementation OrderListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)orderstatus :(NSString*)OrderTime :(NSString*)orderId :(NSString*)itemNames
{
    
    self.orderNumLbl.textColor=[UIColor blackColor];
    self.orderNumLbl.text = [NSString stringWithFormat:@"%@",orderId];
    self.orderStatusLbl.text = [NSString stringWithFormat:@"%@",orderstatus];
    self.orderTimeLbl.text = [NSString stringWithFormat:@"%@",OrderTime];
    self.itemNames.text = [[NSString stringWithFormat:@"%@",itemNames] uppercaseString];
}

-(void)setLabelText1:(NSString*)itemName :(NSString*)quantity :(NSString*)price :(NSString*)itemNames
{

    self.orderNumLbl.textColor=[UIColor colorWithRed:131.0/255.0  green:64.0/255.0 blue:52.0/255.0 alpha:1.0f];
    self.orderNumLbl.text = [NSString stringWithFormat:@"%@",itemName];
    self.orderStatusLbl.text = [NSString stringWithFormat:@"QUANTITY: %@",quantity];
    self.orderStatusLbl.textColor = [UIColor blackColor];
    AppDelegate*appdelegate=[[UIApplication sharedApplication]delegate];
    
    self.orderTimeLbl.text = [NSString stringWithFormat:@"%@%@",appdelegate.currencySymbol,price];
    self.itemNames.text = [[NSString stringWithFormat:@"%@",itemNames]uppercaseString];
}




@end
