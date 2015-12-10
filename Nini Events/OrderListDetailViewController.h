//
//  OrderListDetailViewController.h
//  Nini Events
//
//  Created by Br@R on 09/02/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pendingOrdersOC.h"
#import "FMDatabase.h"
@interface OrderListDetailViewController : UIViewController
{
    NSMutableArray *orderListArray;
   
    IBOutlet UIButton *markDelivrdBtn;
    int webServiceCode;
    pendingOrdersOC *pendingOrderObj;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSMutableData *webData;
    UIActivityIndicatorView *activityIndicator;
    IBOutlet UILabel *currencySymbolLbl;
}
@property (strong, nonatomic) NSString*type;
@property (strong, nonatomic) IBOutlet UILabel *headrLbl;
@property (strong, nonatomic) IBOutlet UITableView *orderTableView;
@property (strong, nonatomic) pendingOrdersOC *pendingOrderObj;
- (IBAction)backBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *totalPriceLbl;
@property (strong, nonatomic) IBOutlet UILabel *noteLbl;
@property (assign, nonatomic) int flag;
- (IBAction)markDelievrdBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *disabledImgView;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;
@end
