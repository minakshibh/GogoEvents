
#import "AppDelegate.h"
#import "splashScreenViewController.h"
#import "serviceProviderHomeViewController.h"
#import "loginViewController.h"
#import "homeViewController.h"
#import "OrdersListViewController.h"
#import "requestAssistanceViewController.h"
#import "spRequestAssistanceViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "NSData+Base64.h"
#import "Base64.h"
#import "appHomeViewController.h"

#define kMaxIdleTimeSeconds 60.0

@interface AppDelegate () <UISplitViewControllerDelegate>
{
    NSTimer *idleTimer, *resetEventTimer;
    
}
@end

@implementation AppDelegate
@synthesize currencySymbol;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    currencySymbol=@"";
    appHomeView = [[appHomeViewController alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults valueForKey:@"isLogedOut"]);
    NSString *isLogedOut;
    if ([defaults valueForKey:@"isLogedOut"] == NULL ) {
        isLogedOut =[NSString stringWithFormat:@"YES"];
    }else{
        isLogedOut =[NSString stringWithFormat:@"%@",[defaults valueForKey:@"isLogedOut"]];
    }
    NSLog(@"ROLE... %@",[defaults valueForKey:@"Role"]);
    if (![isLogedOut isEqualToString:@"YES"]) {
        [self fetchEventDetails];
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self createCopyOfDatabaseIfNeeded];
    splashScreenViewController *splashVC = [[splashScreenViewController alloc]initWithNibName:@"splashScreenViewController" bundle:nil];
    self.navigator = [[UINavigationController alloc] initWithRootViewController:splashVC];
    self.window.rootViewController = self.navigator;
    [self.window makeKeyAndVisible];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"yes" forKey:@"statValue"];
    
    return YES;
}
- (void)resetIdleTimer {
    if (!idleTimer) {
        idleTimer = [NSTimer scheduledTimerWithTimeInterval:kMaxIdleTimeSeconds
                                                     target:self
                                                   selector:@selector(idleTimerExceeded)
                                                   userInfo:nil
                                                    repeats:NO];
    }
    else {
        if (fabs([idleTimer.fireDate timeIntervalSinceNow]) < kMaxIdleTimeSeconds-1.0) {
            [idleTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kMaxIdleTimeSeconds]];
        }
    }
}

- (void)idleTimerExceeded {
    idleTimer = nil;
    NSString*isLogedOut=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogedOut"]];
    
    if ([isLogedOut isEqualToString:@"YES"]) {
        return;
    }
    
    screenSaverViewController *controller = [[screenSaverViewController alloc] initWithNibName:@"screenSaverViewController" bundle:nil] ;
    
    [self.window.rootViewController presentViewController:controller animated:NO completion:nil];
    
    [self.window makeKeyAndVisible];
    
}

- (UIResponder *)nextResponder {
    if (self.startIdleTimmer) {
        [self resetIdleTimer];
    }
    return [super nextResponder];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - Defined Functions

// Function to Create a writable copy of the bundled default database in the application Documents directory.
- (void)createCopyOfDatabaseIfNeeded {
    // First, test for existence.
    // NSString *path = [[NSBundle mainBundle] pathForResource:@"shed_db" ofType:@"sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"niniEvents.sqlite"];
    NSLog(@"db path %@", dbPath);
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if (!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"niniEvents.sqlite"];
        NSLog(@"default DB path %@", defaultDBPath);
        //NSLog(@"File exist is %hhd", [fileManager fileExistsAtPath:defaultDBPath]);
        
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success) {
            NSLog(@"Failed to create writable DB. Error '%@'.", [error localizedDescription]);
        } else {
            NSLog(@"DB copied.");
        }
    }else {
        NSLog(@"DB exists, no need to copy.");
    }
    
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken1
{
    NSLog(@"My token is: %@", deviceToken1);
    
    NSString *str=[NSString stringWithFormat:@"%@",deviceToken1];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Token without space %@",str);
    str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"Token without <> %@",str);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:str forKey:@"DeviceToken"];
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"Notification Popup Tapped.... %@",userInfo);
    NSString *messageStr = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    NSArray* TimeFromArray = [messageStr componentsSeparatedByString: @":"];
    messageStr = [NSString stringWithFormat:@"%@",[TimeFromArray objectAtIndex:0]];
    if ([[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Role"]] isEqualToString:@"ServiceProvider"]) {
        if ([messageStr isEqualToString:@"Order Status"]) {
            serviceProviderHomeViewController *spRequestVC = [[serviceProviderHomeViewController alloc] initWithNibName:@"serviceProviderHomeViewController" bundle:nil];
            [self.navigator pushViewController:spRequestVC animated:NO];
        }else{
            spRequestAssistanceViewController *requestVC = [[spRequestAssistanceViewController alloc] initWithNibName:@"spRequestAssistanceViewController" bundle:nil];
            [self.navigator pushViewController:requestVC animated:NO];
        }
    }else{
        if ([messageStr isEqualToString:@"Order Status"]) {
            OrdersListViewController*ordrVc=[[OrdersListViewController alloc]initWithNibName:@"OrdersListViewController" bundle:nil];
            ordrVc.flagValue = 2;
            [self.navigator pushViewController:ordrVc animated:YES];
        }else{
            requestAssistanceViewController *requestVC = [[requestAssistanceViewController alloc] initWithNibName:@"requestAssistanceViewController" bundle:nil];
            [self.navigator pushViewController:requestVC animated:NO];
        }
    }
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

-(void)fetchEventDetails
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[defaults valueForKey:@"Event ID"],@"EventId", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchBasicEventDetails",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        
        NSLog(@"server connection made");
    }
    
    else
    {
        NSLog(@"connection is NULL");
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [webData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [webData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    webData = nil;
}

#pragma mark -
#pragma mark Process loan data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        NSError *error;
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
    NSString *resultStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"result"]];
    if([resultStr isEqualToString:@"0"])
    {
        NSString *pdfUrl = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"EventPdfUrl"]];
        NSString *eventStatus = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"EventTabVisiblity"]];
        NSString *PingAssistance = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"PingAssistance"]];
        NSString *SlideShow = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"SlideShow"]];
        
        
        
        
        NSString *eventChatSupport = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"EventChatSupportAvailability"]];
        [defaults setValue:pdfUrl forKey:@"PDF"];
        
        [defaults setValue:eventStatus forKey:@"Event Status"];
        [defaults setValue:PingAssistance forKey:@"PingAssistance"];
        [defaults setValue:SlideShow forKey:@"SlideShow"];
        [defaults setValue:[userDetailDict valueForKey:@"EventDocuments"] forKey:@"EventDocuments"];
        [defaults setValue:eventChatSupport forKey:@"Event Chat Support"];
        [defaults setValue:[userDetailDict valueForKey:@"EventName"] forKey:@"EventName"];
        [defaults setValue:[userDetailDict valueForKey:@"ListEventDetails"] forKey:@"ListEventDetails"];
        [defaults setValue:[userDetailDict valueForKey:@"IsfreeEvent"] forKey:@"Is Paid"];
        [defaults setValue:[userDetailDict valueForKey:@"EventCurrencySymbol"] forKey:@"EventCurrencySymbol"];
        [defaults setValue:[userDetailDict valueForKey:@"EventStartDate"] forKey:@"EventStartDate"];
        [defaults setValue:[userDetailDict valueForKey:@"EventEndDate"] forKey:@"EventEndDate"];
        [defaults setValue:[userDetailDict valueForKey:@"HoldEvent"] forKey:@"HoldEvent"];
        
        NSString*currencyStr=[userDetailDict valueForKey:@"EventCurrencySymbol"];
    NSLog(@"%@",currencyStr);
    NSString *substring;
    if (![currencyStr isEqualToString:@""]) {
        NSRange range = [currencyStr rangeOfString:@"("];
        substring = [[currencyStr substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        substring = [substring substringToIndex:1];
    }else{
        substring = @"";
    }
    
    
        self.currencySymbol=substring;
        [defaults setValue:substring forKey:@"Currency Value"];
//        if ([userDetailDict valueForKey:@"EventPictureUrl"] !=[NSNull null]) {
//            
//            NSString *eventImageStr = [userDetailDict valueForKey:@"EventPictureUrl"];
//            NSString *eventID = [userDetailDict valueForKey:@"EventName"];
//            
//            [self imageDownloading:eventImageStr :eventID];
//            
//            eventImageStr = [NSString stringWithFormat:@"%@.png",eventID];
//            
//            [defaults setValue:eventImageStr forKey:@"EventImage"];
//            
//        }
//        else{
//            [defaults setValue:@"" forKey:@"EventPictureUrl"];
//        }
        
        _startIdleTimmer = YES;
        [self resetIdleTimer];
        [appHomeView tick];
    }else{
       
    }
}

- (void)imageDownloading:(NSString *) imageUrl : (NSString *) imageName
{
    ASIHTTPRequest *request;
    
    NSLog(@"%@.png",imageName);
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrl]]];
    
    [request setDownloadDestinationPath:[[NSHomeDirectory()
                                          stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]]];
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        
        
    }];
    
    
    
    [request setDelegate:self];
    [request startSynchronous];
    
}

//- (void)tick {
//    
//    NSString *EndTime = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"EventEndDate"]];
//    
//    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
//    
//    [dateFormat1 setDateFormat:@"M/dd/yyyy hh:mm:ss a"];
//    
//    NSString *currentDateStr = [dateFormat1 stringFromDate:[NSDate date]];
//    NSDate *sDate = [dateFormat1 dateFromString:currentDateStr];
//    NSDate *eDate = [dateFormat1 dateFromString:EndTime];
//    
//    
//    NSLog(@"End Date = %@, Current Date = %@",eDate , sDate);
//    
//    NSInteger hours, minutes, seconds, days;
//    
//    components = [[NSCalendar currentCalendar] components: NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate: [NSDate date] toDate: eDate options: 0];
//    days = [components day];
//    hours = [components hour];
//    minutes = [components minute];
//    seconds = [components second];
//    if (seconds <= 0 && hours <= 0 && minutes <= 0) {
//        //Checks if the countdown completed
////        lblTimerHour.text = [NSString stringWithFormat:@"00"];
////        lblTimermin.text = [NSString stringWithFormat:@"00"];
////        lblTimerSec.text = [NSString stringWithFormat:@"00"];
//        [timer invalidate];
//        
//        
////        lbleventtimeout.hidden = NO;
////        self.timerCountDown.hidden = YES;
////        self.daysCountDown.hidden = YES;
//        
//        [[NSUserDefaults standardUserDefaults]setObject:@"end" forKey:@"evenStatus"];
//        
//        
//        return;
//    }
//    
//    NSString *hoursStr,*minutesStr,*secondsStr;
//    
//    if (hours < 10) {
//        hoursStr =[NSString stringWithFormat:@"0%li", (long)hours];
//    }else{
//        hoursStr = [NSString stringWithFormat:@"%li",(long)hours];
//    }
//    
//    if (minutes < 10) {
//        minutesStr =[NSString stringWithFormat:@"0%li", (long)minutes];
//    }else{
//        minutesStr = [NSString stringWithFormat:@"%li",(long)minutes];
//    }
//    
//    if (seconds < 10) {
//        secondsStr =[NSString stringWithFormat:@"0%li",(long)seconds];
//    }else{
//        secondsStr = [NSString stringWithFormat:@"%li",(long)seconds];
//    }
//    
//    
//    if (days <= 0) {
////        self.timerCountDown.hidden = NO;
////        self.daysCountDown.hidden = YES;
////        lblTimerHour.text = hoursStr;
////        lblTimermin.text = minutesStr;
////        lblTimerSec.text = secondsStr;
//    }else{
////        self.timerCountDown.hidden = YES;
////        self.daysCountDown.hidden = NO;
////        if (days > 1) {
////            lblTimerDays.text = [NSString stringWithFormat:@"%i Days", days];
////        }else{
////            lblTimerDays.text = [NSString stringWithFormat:@"%i Day", days];
////        }
//        
////        dayCountDownHourLbl.text = hoursStr;
////        dayCountDownMinLbl.text = minutesStr;
////        dayCountDownSecLbl.text = secondsStr;
//    }
//    if (timer == nil) {
//        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
//    }
//    [[NSUserDefaults standardUserDefaults]setObject:@"running" forKey:@"evenStatus"];
//    
//}

@end
