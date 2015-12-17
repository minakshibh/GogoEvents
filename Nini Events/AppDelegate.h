
#import <UIKit/UIKit.h>
#import "screenSaverViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableData *webData;
    int webServiceCode;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) bool *startIdleTimmer;
@property (nonatomic, retain) screenSaverViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigator;
@property (strong ,nonatomic) NSString*currencySymbol;
- (void)resetIdleTimer;
@end

