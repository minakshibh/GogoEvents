//
//  OrderTableViewCell.h
//  Nini Events
//
//  Created by Br@R on 29/01/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
{
    IBOutlet UILabel *priceLbl;
    IBOutlet UILabel *name;
    IBOutlet UIImageView *productImageView;
    IBOutlet UILabel *quantityLbl;
    
}
-(void)setLabelText:(NSString*)name  :(int)quantity :(NSString*)price :(NSString*) imageUrl : (NSData*)imageData ;

@end
