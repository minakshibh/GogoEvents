//
//  cell1TableViewCell.h
//  Nini Events
//
//  Created by Krishna Mac Mini 2 on 19/11/15.
//  Copyright © 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cell1TableViewCell : UITableViewCell
{
    IBOutlet UILabel *lblEventname;
    IBOutlet UILabel *lblEventTime;
    
}

-(void)setLabelText:(NSString*)eventName :(NSString*)eventBy : (NSString*)startDate :(NSString*)endDate;

@end
