

#import <UIKit/UIKit.h>

@interface cell2TableViewCell : UITableViewCell
{
    IBOutlet UILabel *lblEventName;
   
    IBOutlet UITextView *lblEventDescription;
    IBOutlet UILabel *lblEventTime;
    
}

-(void)setLabelText:(NSString*)eventName :(NSString*)eventBy : (NSString*)startDate : (NSString*)endDate :(NSString*)eventDescription;
@end
