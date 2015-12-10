//
//  cell2TableViewCell.h
//  Nini Events
//
//  Created by Krishna Mac Mini 2 on 19/11/15.
//  Copyright © 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cell2TableViewCell : UITableViewCell
{
    IBOutlet UILabel *lblEventName;
   
    IBOutlet UITextView *lblEventDescription;
    IBOutlet UILabel *lblEventTime;
    
}

-(void)setLabelText:(NSString*)eventName :(NSString*)eventBy : (NSString*)startDate : (NSString*)endDate :(NSString*)eventDescription;
@end
