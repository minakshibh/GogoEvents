//
//  screenSaverViewController.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 12/24/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface screenSaverViewController : UIViewController
{
    UIImageView * mainImageView;
    NSMutableData *webData;
    UIActivityIndicatorView *activityIndicator;
    int webServiceCode;
    NSMutableArray *imagesUrlArray, *screenSaverImages, *imageNameStringsArray;
    UIScrollView *scr;
    UIPageControl *pgCtr;
}
@property (strong, nonatomic) IBOutlet UIImageView *image1;

@end
