//
//  cell1TableViewCell.m
//  Nini Events
//
//  Created by Krishna Mac Mini 2 on 19/11/15.
//  Copyright © 2015 Krishna_Mac_1. All rights reserved.
//

#import "cell1TableViewCell.h"

@implementation cell1TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)eventName :(NSString*)eventBy : (NSString*)startDate :(NSString*)endDate
{
    if ([startDate containsString:@"null"])
    {
        startDate = @"";
    }
    if ([endDate containsString:@"null"])
    {
        endDate = @"";
    }
    if ([eventBy containsString:@"null"])
    {
        eventBy = @"";
    }
    
    
  NSString *yourString = [NSString stringWithFormat:@"%@ by %@",eventName,eventBy];
  //  NSString *yourString = [NSString stringWithFormat:@"%@ by R.R. Kumar",eventName];
    NSMutableAttributedString *yourAttributedString = [[NSMutableAttributedString alloc] initWithString:yourString];
    NSString *boldString = [NSString stringWithFormat:@"%@",eventBy];
 //    NSString *boldString = [NSString stringWithFormat:@"R.R. Kumar"];
    NSRange boldRange = [yourString rangeOfString:boldString];
    [yourAttributedString addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:16] range:boldRange];
    [lblEventname setAttributedText: yourAttributedString];
    

  NSString *yourString1 = [NSString stringWithFormat:@"%@ - %@",startDate,endDate];
  //  NSString *yourString1 = [NSString stringWithFormat:@"10:00 AM - 10-15 AM"];

    NSMutableAttributedString *yourAttributedString1 = [[NSMutableAttributedString alloc] initWithString:yourString1];
    NSString *boldString1 = yourString1;
//    NSString *boldString1 = yourString1;
    NSRange boldRange1 = [yourString1 rangeOfString:boldString1];
    [yourAttributedString1 addAttribute: NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:boldRange1];
    [lblEventTime setAttributedText: yourAttributedString1];
}
@end
