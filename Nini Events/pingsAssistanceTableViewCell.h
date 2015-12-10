//
//  pingsAssistanceTableViewCell.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 2/24/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pingsAssistanceTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *TableNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *pingMessageLbl;
@property (strong, nonatomic) IBOutlet UILabel *pingTimeLbl;
-(void)setLabelText:(NSString*)orderstatus :(NSString*)OrderTime :(NSString*)orderId;
@end
