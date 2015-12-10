//
//  pingsAssistanceTableViewCell.m
//  Nini Events
//
//  Created by Krishna_Mac_1 on 2/24/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "pingsAssistanceTableViewCell.h"

@implementation pingsAssistanceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setLabelText:(NSString*)tableName :(NSString*)pingTime :(NSString*)pingMessage
{

    self.TableNameLbl.text = [NSString stringWithFormat:@"%@",tableName];
    self.pingTimeLbl.text = [NSString stringWithFormat:@"%@",pingTime];
    self.pingMessageLbl.text = [NSString stringWithFormat:@"%@",pingMessage];
}

@end
