//
//  loginViewController.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 11/17/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "menuOC.h"
#import "menuItemsOC.h"
#import "FMDatabase.h"

@interface loginViewController : UIViewController<UITextFieldDelegate>
{
    AppDelegate *appdelegate;
    CGPoint svos;
    NSMutableData *webData;
    UIActivityIndicatorView *activityIndicator;
    NSString *result, *message, *lastUpdatedCities, *supportEmail, *categoryType;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    int webServiceCode;
    menuOC * menuObj;
    menuItemsOC *menuItemsObj;
    FMDatabase *database;
    NSMutableArray *menuDetails, *menuCategoryIdsArray, *menuItemsDetail, *itemsIdsArray, *tablesArray,*imagesUrlArray,*iPadIdsArray;
    IBOutlet UILabel *lblbackground;
}

@property (weak, nonatomic) IBOutlet UITextField *userNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTxt;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UIScrollView *loginScroller;
- (IBAction)ForgotPassword:(id)sender;
- (IBAction)Register:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *disabledImgView;
-(void)menuItems;
@end
