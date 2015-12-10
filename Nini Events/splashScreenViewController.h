//
//  splashScreenViewController.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 12/8/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "menuOC.h"
#import "FMDatabase.h"
#import <MediaPlayer/MediaPlayer.h>
#import "menuOC.h"
#import "menuItemsOC.h"
@interface splashScreenViewController : UIViewController
{
    NSMutableData *webData;
    UIActivityIndicatorView *activityIndicator;
    NSString *result, *message, *lastUpdatedCities, *supportEmail, *categoryType;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    int webServiceCode;
    NSMutableArray *menuDetails, *menuCategoryIdsArray;
    FMDatabase *database;
    menuOC * menuObj;
    menuItemsOC *menuItemsObj;
     NSMutableArray  *menuItemsDetail, *itemsIdsArray;
}
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIImageView *disabledImgView;
@end
