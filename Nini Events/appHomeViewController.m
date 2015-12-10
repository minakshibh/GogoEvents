//
//  appHomeViewController.m
//  Nini Events
//
//  Created by Krishna_Mac_1 on 2/10/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "appHomeViewController.h"
#import "OrdersListViewController.h"
#import "homeViewController.h"
#import "requestAssistanceViewController.h"
#import "loginViewController.h"
#import "CheckOutViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "eventDetailViewController.h"
#import "eventImagesSlideViewViewController.h"
#import "menuStateViewController.h"
#import "cell2TableViewCell.h"
#import "cell1TableViewCell.h"
#import "appHomeViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface appHomeViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *bottomMenuImg;
@property (strong, nonatomic) IBOutlet UIView *bottomMenuView;
@property (strong, nonatomic) IBOutlet UIView *ophemyLogoView;
@property (strong, nonatomic) IBOutlet UIButton *slideMenuBtn;
@property (strong, nonatomic) IBOutlet UILabel *selctDocLabel;
@property (strong, nonatomic) IBOutlet UIButton *pingBtn;
@property (strong, nonatomic) IBOutlet UIView *timerCountDown;
@property (strong, nonatomic) IBOutlet UIView *daysCountDown;
@end

@implementation appHomeViewController
NSArray *urlLinks;

- (void)viewDidLoad {
    [self tick];
    [self createMenu];
    
    tableView.backgroundColor = [UIColor clearColor];
    value = false;
    
    [super viewDidLoad];
    tableView.separatorColor = [UIColor clearColor];
    //------timer section
    lblTimerbackground.layer.cornerRadius = 5.0;  [lblTimerbackground setClipsToBounds:YES];
    lblTimerheaderbackground.layer.cornerRadius = 5.0;  [lblTimerheaderbackground setClipsToBounds:YES];
    
    cal = [NSCalendar currentCalendar] ;
    components = [[NSDateComponents alloc] init];
    
    //----
    
    lblEventBackground.layer.cornerRadius = 5.0;  [lblTimerbackground setClipsToBounds:YES];
    lblEventBackground.alpha = 0.9;
    
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bulb"] isEqualToString:@"ON"]) {
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
    }
    else{
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int chatCount = [[defaults valueForKey:@"Chat Count"] intValue];
    if (chatCount != 0) {
        self.assisstanceNotificationBadgeImg.hidden = NO;
        self.assisstanceNotificationBadgeLbl.hidden = NO;
        self.assisstanceNotificationBadgeLbl.text = [NSString stringWithFormat:@"%d",chatCount];
    }else{
        self.assisstanceNotificationBadgeImg.hidden = YES;
        self.assisstanceNotificationBadgeLbl.hidden = YES;
    }
    
    NSArray *tempEvntArray=[defaults valueForKey:@"ListEventDetails"];
    eventDetailArray=[[NSMutableArray alloc]init];
    eventNameArray = [[NSMutableArray alloc] init] ;
    EventDetailsStartTime=[[NSMutableArray alloc]init];
    EventDetailsEndTime = [[NSMutableArray alloc] init] ;
    EventDetailsBy = [[NSMutableArray alloc] init] ;
    for (int i=0; i<tempEvntArray.count; i++)
    {
        NSDictionary *tempEventNAmeDict=[tempEvntArray objectAtIndex:i];
        [eventNameArray addObject: [tempEventNAmeDict valueForKey:@"EventDetailsHeading"]];
        [eventDetailArray addObject: [tempEventNAmeDict valueForKey:@"EventDetailsDescription"]];
        [EventDetailsStartTime addObject: [NSString stringWithFormat:@"%@",[tempEventNAmeDict valueForKey:@"EventDetailsStartTime"]]];
        [EventDetailsEndTime addObject: [NSString stringWithFormat:@"%@",[tempEventNAmeDict valueForKey:@"EventDetailsEndTime"]]];
        [EventDetailsBy addObject: [tempEventNAmeDict valueForKey:@"EventDetailsBy"]];
        NSLog(@"%@,%@,%@,%@",eventNameArray,eventDetailArray,EventDetailsStartTime,EventDetailsEndTime);
    }
    NSArray *tempEventDetails = [defaults valueForKey:@"EventDocuments"];
    EventDocumentTitleArray = [[NSMutableArray alloc] init];
    EventDocumentUrlsArray = [[NSMutableArray alloc] init];
    for (int i = 0;i < tempEventDetails.count; i++) {
        NSDictionary *tempEventDocumentDict=[tempEventDetails objectAtIndex:i];
        [EventDocumentUrlsArray addObject:[tempEventDocumentDict valueForKey:@"Url"]];
        [EventDocumentTitleArray addObject:[tempEventDocumentDict valueForKey:@"Title"]];
    }
    
    NSString *DLImageUrl=[defaults valueForKey:@"EventPictureUrl"];
    
    if ([DLImageUrl isEqualToString:@"(null)"]) {
        
    }
    else if (DLImageUrl.length!=0 )
    {
        NSData* data = [[NSData alloc] initWithBase64EncodedString:DLImageUrl options:0];
        // UIImage* img1 = [UIImage imageWithData:data];
        eventImageView.image = [UIImage imageWithData:data];
        
        
        //        UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //        objactivityindicator.center = CGPointMake((eventImageView.frame.size.width/2),(eventImageView.frame.size.height/2));
        //        [eventImageView addSubview:objactivityindicator];
        //        [objactivityindicator startAnimating];
        //
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        //            NSURL *imageURL=[NSURL URLWithString:[DLImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //            NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
        //            UIImage *imgData=[UIImage imageWithData:tempData];
        //            dispatch_async(dispatch_get_main_queue(), ^
        //                           {
        //                               if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
        //                               {
        //                                   [eventImageView setImage:imgData];
        //                                   [objactivityindicator stopAnimating];
        //
        //                               }
        //                               else
        //                               {
        //                                   [objactivityindicator stopAnimating];
        //
        //                               }
        //                           });
        //        });
    }
    appFonts = [[NSMutableArray alloc] init];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"Info.plist"];
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    
    fontFamilyNames = [plistData valueForKey:@"UIAppFonts"];
    
    NSLog(@"%@",fontFamilyNames);
    for (int i =0; i < [fontFamilyNames count]; i++) {
        NSArray *fontString = [[fontFamilyNames objectAtIndex:i] componentsSeparatedByString:@"."];
        [appFonts addObject:[fontString objectAtIndex:0]];
    }
    //   NSLog(@"%@",appFonts);
    // eventNameArray = [[NSMutableArray alloc] initWithObjects:@"Samantha Weds Eric",@"Sam Weds Julia",@"Joi Weds Jaz", nil];
    
    
    [self fetchOrders];
    
    
    
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:178/255.0f green:38/255.0f blue:12/255.0f alpha:1.0f];
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        toolBar.barTintColor = [UIColor colorWithRed:178/255.0f green:38/255.0f blue:12/255.0f alpha:1.0f];
        toolBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        toolBar.tintColor = [UIColor colorWithRed:178/255.0f green:38/255.0f blue:12/255.0f alpha:1.0f];
    }
    
    
    
    
    // [slideShow removeFromSuperview];
    //    [self fetchEventDetails];
    // Do any additional setup after loading the view from its nib.
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    NSString *docTitleStr =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Document Name"]];
    if (![docTitleStr isEqualToString:@"(null)"]) {
         btnselecteventdetail.titleLabel.text = docTitleStr;
    }else{
        btnselecteventdetail.titleLabel.text = @"   Select Docs";
    }
   
}

- (void)tick {

    NSString *EndTime = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"EventEndDate"]];
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setLocale:[NSLocale currentLocale]];
    [dateFormat1 setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
//    NSDate *endDate = [dateFormat1 dateFromString:EndTime];
//    NSString *endDateStr = [dateFormat1 stringFromDate:endDate];

    NSString *currentDateStr = [dateFormat1 stringFromDate:[NSDate date]];
    NSDate *sDate = [dateFormat1 dateFromString:currentDateStr];
    NSDate *eDate = [dateFormat1 dateFromString:EndTime];
    
    
    NSLog(@"End Date = %@, Current Date = %@",eDate , sDate);
    int secondsBetween = [eDate timeIntervalSinceDate:sDate];
    
    if (secondsBetween <= 0) {
        //Checks if the countdown completed
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Countdown Completed" message:@"YAY! The countdown has complete" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        lblTimerHour.text = [NSString stringWithFormat:@"00"];
        lblTimermin.text = [NSString stringWithFormat:@"00"];
        lblTimerSec.text = [NSString stringWithFormat:@"00"];
        [timer invalidate];
        
        return;
    }
    NSString *hoursStr,*minutesStr,*secondsStr;
    int hours, minutes, seconds, days;
    days  = secondsBetween / 86400;
    hours = secondsBetween / 3600;
    minutes = (secondsBetween % 3600) / 60;
    seconds = (secondsBetween %3600) % 60;
    days = hours/24;
    hours = hours % 24;
    NSLog(@"%d, %d", hours,days);
    if (hours < 10) {
        hoursStr =[NSString stringWithFormat:@"0%i", hours];
    }else{
        hoursStr = [NSString stringWithFormat:@"%i",hours];
    }
    
    if (minutes < 10) {
        minutesStr =[NSString stringWithFormat:@"0%i", minutes];
    }else{
        minutesStr = [NSString stringWithFormat:@"%i",minutes];
    }
    
    if (seconds < 10) {
        secondsStr =[NSString stringWithFormat:@"0%i",seconds];
    }else{
        secondsStr = [NSString stringWithFormat:@"%i",seconds];
    }
    
    
    if (days <= 0) {
        self.timerCountDown.hidden = NO;
        self.daysCountDown.hidden = YES;
        lblTimerHour.text = hoursStr;
        lblTimermin.text = minutesStr;
        lblTimerSec.text = secondsStr;
    }else{
        self.timerCountDown.hidden = YES;
        self.daysCountDown.hidden = NO;
        if (days > 1) {
            lblTimerDays.text = [NSString stringWithFormat:@"%i Days", days];
        }else{
            lblTimerDays.text = [NSString stringWithFormat:@"%i Day", days];
        }
        
        dayCountDownHourLbl.text = hoursStr;
        dayCountDownMinLbl.text = minutesStr;
        dayCountDownSecLbl.text = secondsStr;
    }
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    }
    
}

- (IBAction)newOrderAction:(id)sender {
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = YES;
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)orderHistoryAction:(id)sender {
    OrdersListViewController*ordrVc=[[OrdersListViewController alloc]initWithNibName:@"OrdersListViewController" bundle:nil];
    ordrVc.flagValue = 1;
    [self.navigationController pushViewController:ordrVc animated:YES];
}

- (IBAction)spcornerAction:(id)sender {
    OrdersListViewController*ordrVc=[[OrdersListViewController alloc]initWithNibName:@"OrdersListViewController" bundle:nil];
    ordrVc.flagValue = 2;
    [self.navigationController pushViewController:ordrVc animated:YES];
}

- (IBAction)requestAssistanceAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"Chat Count"] ;
    self.assisstanceNotificationBadgeImg.hidden = YES;
    self.assisstanceNotificationBadgeLbl.hidden = YES;
    requestAssistanceViewController *requestVC = [[requestAssistanceViewController alloc] initWithNibName:@"requestAssistanceViewController" bundle:nil];
    [self.navigationController pushViewController:requestVC animated:NO];
}

- (IBAction)exitAction:(id)sender {
    [self.exitPopUpView setFrame:CGRectMake(0, 0, self.exitPopUpView.frame.size.width, self.exitPopUpView.frame.size.height)];
    [self.view addSubview:self.exitPopUpView];
}

- (IBAction)menuAction:(id)sender {
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = NO;
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)sideMenuAction:(id)sender {
    CGPoint pt;
    CGRect rc = [self.sideScroller bounds];
    rc = [self.sideScroller convertRect:rc toView:self.sideScroller];
    pt = rc.origin;
    if (pt.x == 0) {
        pt.x -= 265;
    }else{
        pt.x = 0;
    }
    
    pt.y =-20;
    [self.sideScroller setContentOffset:pt animated:YES];
}

- (IBAction)viewOrderNtnAction:(id)sender {
    
    CheckOutViewController*checkoutVc=[[CheckOutViewController alloc]initWithNibName:@"CheckOutViewController" bundle:nil];
    [self.navigationController pushViewController:checkoutVc animated:NO];
    
    
}

- (IBAction)eventDetailsAction:(id)sender {
    eventDetailViewController*eventDetailsVc=[[eventDetailViewController alloc]initWithNibName:@"eventDetailViewController" bundle:nil];
    [self.navigationController pushViewController:eventDetailsVc animated:NO];
}

- (IBAction)ophemyAction:(id)sender {
    
}
- (IBAction)Slideshow:(id)sender
{
    eventImagesSlideViewViewController *homeVC = [[eventImagesSlideViewViewController alloc] initWithNibName:@"eventImagesSlideViewViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
}
//- (IBAction)appHomeAction:(id)sender {
//    if (flag == 0) {
//        flag = 1;
//        [self viewDidLoad];
//    }else{
//        flag = 0;
//        [self viewDidLoad];
//    }
//}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1 && buttonIndex == 1){
        
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM orderHistory"];
        [database executeUpdate:queryString1];
        [database close];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults removeObjectForKey:@"Table ID"];
        [defaults removeObjectForKey:@"Table Name"];
        [defaults removeObjectForKey:@"Table image"];
        [defaults removeObjectForKey:@"Role"];
        
        [defaults setObject:[NSString stringWithFormat:@"YES"] forKey:@"isLogedOut"];
        loginViewController *loginVC = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
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
    
    webServiceCode =1;
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
    if (webServiceCode == 0) {
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSString *messageStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"message"]];
        
    }else{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        NSError *error;
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSString *eventStatus = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"EventTabVisiblity"]];
        NSString *PingAssistance = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"PingAssistance"]];
        NSString *SlideShow = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"SlideShow"]];
        
        
        NSString *eventChatSupport = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"EventChatSupportAvailability"]];
        [defaults setValue:eventStatus forKey:@"Event Status"];
        [defaults setValue:eventChatSupport forKey:@"Event Chat Support"];
        
        if ([eventChatSupport isEqualToString:@"False"]) {
            [self.sideMenuWithoutReqAssistance setFrame:CGRectMake(-269, 19, self.sideMenuWithoutReqAssistance.frame.size.width, self.sideMenuWithoutReqAssistance.frame.size.height)];
            [self.sideScroller addSubview:self.sideMenuWithoutReqAssistance];
            
        }else{
            [self.sideMenuWithoutReqAssistance removeFromSuperview];
            
        }
        
        
        
        //        if ([eventStatus isEqualToString:@"0"]) {
        //            [self.footerWithoutEventsDetail setFrame:CGRectMake(0, 704, self.footerWithoutEventsDetail.frame.size.width, self.footerWithoutEventsDetail.frame.size.height)];
        //            [self.sideScroller addSubview:self.footerWithoutEventsDetail];
        //        }else{
        //            [self.footerWithoutEventsDetail removeFromSuperview];
        //        }
    }
}
-(void)fetchOrders
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM orderHistory "];
    FMResultSet *results = [database executeQuery:queryString];
    
    orderList = [[NSMutableArray alloc] init];
    int k = 0 ;
    
    while([results next]) {
        
        NSString *orderItem=[results stringForColumn:@"orderItemName"];
        
        [orderList addObject:orderItem];
    }
    NSString *orderCount =[NSString stringWithFormat:@"%lu",(unsigned long)[orderList count]];
    NSLog(@"Order Count .... %@",orderCount);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:orderCount forKey:@"Order Item Count"];
    if (![orderCount isEqualToString:@"(null)"])
    {
        if (![orderCount isEqualToString:@"0"]) {
            
            self.batchLbl.hidden = NO;
            self.batchImg.hidden = NO;
            self.otherMenuBatchLbl.hidden = NO;
            self.otheMenuBatchImg.hidden = NO;
            NSLog(@"ordr count..%@",orderCount);
            self.batchLbl.text = [NSString stringWithFormat:@"%@",orderCount];
            self.otherMenuBatchLbl.text = [NSString stringWithFormat:@"%@",orderCount];
            
        }
        else{
            self.batchLbl.hidden = YES;
            self.batchImg.hidden = YES;
            self.otherMenuBatchLbl.hidden = YES;
            self.otheMenuBatchImg.hidden = YES;
        }
        
    }else{
        self.batchLbl.hidden = YES;
        self.batchImg.hidden = YES;
        self.otherMenuBatchLbl.hidden = YES;
        self.otheMenuBatchImg.hidden = YES;
    }
    
    
}

- (IBAction)pingBtnAction:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bulb"] isEqualToString:@"OFF"]) {
        [self sendHelpMessage];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"ON" forKey:@"bulb"];
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        self.pingMessageView.hidden = NO;
        [self.pingMessageView setFrame:CGRectMake(52, 585, self.pingMessageView.frame.size.width, self.pingMessageView.frame.size.height)];
        self.pingMessageView.alpha= 1.0;
        [self.sideScroller addSubview:self.pingMessageView];
        [self.sideScroller bringSubviewToFront:self.pingMessageView];
        hideTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(FadeView) userInfo:nil repeats:NO];
    }
    else{
        
        self.pingMessageView.hidden = YES;
        [hideTimer invalidate];
        [[NSUserDefaults standardUserDefaults] setValue:@"OFF" forKey:@"bulb"];
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
    }
    
}
-(void) sendHelpMessage
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tableID = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Ipad ID"]];
    NSString *serviceProviderId = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"AllotedServiceProviderId"]];
    serviceProviderId = [serviceProviderId stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    serviceProviderId = [serviceProviderId stringByReplacingOccurrencesOfString:@"(" withString:@""];
    serviceProviderId = [serviceProviderId stringByReplacingOccurrencesOfString:@")" withString:@""];
    serviceProviderId = [serviceProviderId stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *tableName = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table Name"]];
    tableName = [tableName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tableName = [tableName stringByReplacingOccurrencesOfString:@"(" withString:@""];
    tableName = [tableName stringByReplacingOccurrencesOfString:@")" withString:@""];
    tableName = [tableName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *chatMessage;
    NSString *chatTrigger;
    chatTrigger = [NSString stringWithFormat:@"ping"];
    chatMessage = [NSString stringWithFormat:@"%@ is requesting Assistance.",tableName];
    NSString *sender = [NSString stringWithFormat:@"table"];
    
    
    //     NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:tableID,@"tableId",serviceProviderId,@"serviceproviderId",chatMessage,@"message",sender, @"sender",[NSString stringWithFormat:@"1"],@"restaurantId",chatTrigger,@"trigger"  ,[[NSUserDefaults standardUserDefaults] valueForKey:@"Table Name"],@"sendername", nil];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:tableID,@"tableId",serviceProviderId,@"serviceproviderId",chatMessage,@"message",sender, @"sender",[NSString stringWithFormat:@"1"],@"restaurantId",chatTrigger,@"trigger"  ,[[NSUserDefaults standardUserDefaults] valueForKey:@"Table Name"],@"sendername", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/SendHelpMessages",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode =0;
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
-(void) FadeView
{
    [UIView animateWithDuration:0.9
                     animations:^{self.pingMessageView.alpha = 0.0;}
                     completion:^(BOOL finished){self.pingMessageView.hidden = YES;}];
}

- (IBAction)exitYesAction:(id)sender {
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM orderHistory"];
    [database executeUpdate:queryString1];
    
    [database close];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"Table ID"];
    [defaults removeObjectForKey:@"Table Name"];
    [defaults removeObjectForKey:@"Table image"];
    [defaults removeObjectForKey:@"Role"];
    
    [defaults setObject:[NSString stringWithFormat:@"YES"] forKey:@"isLogedOut"];
    loginViewController *loginVC = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:NO];
}

- (IBAction)exitNoAction:(id)sender {
    [self.exitPopUpView removeFromSuperview];
}
#pragma mark - Tableview delegates
- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    if (atableView==tableviewpdf)
    {
        [tableviewpdf setFrame:CGRectMake(tableviewpdf.frame.origin.x, self.selctDocLabel.frame.origin.y - EventDocumentTitleArray.count*45, tableviewpdf.frame.size.width, EventDocumentTitleArray.count*45)];
        return EventDocumentTitleArray.count;
        
    }
    
    return eventNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (atableView==tableviewpdf)
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[EventDocumentTitleArray objectAtIndex:indexPath.row]];
        cell.backgroundColor = [UIColor clearColor];
        return  cell;
    }
    
    if ([indexPath isEqual:self.expandedIndexPath])
    {
        static NSString *simpleTableIdentifier = @"ArticleCellID";
        
        cell2TableViewCell *cell = (cell2TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"cell2TableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSString *eventNameStr = [NSString stringWithFormat:@"%@",[eventNameArray objectAtIndex:indexPath.row]];
        NSString *eventDetailStr = [NSString stringWithFormat:@"%@",[eventDetailArray objectAtIndex:indexPath.row]];
        content = eventDetailStr.length;
        
        NSString *eventDetailsStartTimeStr = [NSString stringWithFormat:@"%@",[EventDetailsStartTime objectAtIndex:indexPath.row]];
        NSString *eventDetailsEndTimeStr = [NSString stringWithFormat:@"%@",[EventDetailsEndTime objectAtIndex:indexPath.row]];
        NSString *eventDetailsByStr = [NSString stringWithFormat:@"%@",[EventDetailsBy objectAtIndex:indexPath.row]];
        
        [cell setLabelText:eventNameStr :eventDetailsByStr :eventDetailsStartTimeStr :eventDetailsEndTimeStr :eventDetailStr];
        
        return cell;
    }else{
        
        static NSString *simpleTableIdentifier = @"ArticleCellID";
        
        cell1TableViewCell *cell = (cell1TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"cell1TableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSString *eventNameStr = [NSString stringWithFormat:@"%@",[eventNameArray   objectAtIndex:indexPath.row]];
        NSString *eventDetailsStartTimeStr = [NSString stringWithFormat:@"%@",[EventDetailsStartTime objectAtIndex:indexPath.row]];
        NSString *eventDetailsEndTimeStr = [NSString stringWithFormat:@"%@",[EventDetailsEndTime objectAtIndex:indexPath.row]];
        NSString *eventDetailsByStr = [NSString stringWithFormat:@"%@",[EventDetailsBy objectAtIndex:indexPath.row]];
        
        [cell setLabelText:eventNameStr :eventDetailsByStr :eventDetailsStartTimeStr :  eventDetailsEndTimeStr];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(atableView==tableviewpdf)
    {
        return  45;
    }
    
    if ([indexPath isEqual:self.expandedIndexPath])
    {
        if(content <151)
        {
            return 80;
        }else{
            return 90;
        }
    }
    return 43;
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(atableView==tableView)
    {
        
        
        NSMutableArray *modifiedRows = [NSMutableArray array];
        if ([indexPath isEqual:self.expandedIndexPath]) {
            [modifiedRows addObject:self.expandedIndexPath];
            self.expandedIndexPath = nil;
        } else {
            if (self.expandedIndexPath)
                [modifiedRows addObject:self.expandedIndexPath];
            
            self.expandedIndexPath = indexPath;
            [modifiedRows addObject:indexPath];
        }
        
        // This will animate updating the row sizes
        [tableView reloadRowsAtIndexPaths:modifiedRows withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // Preserve the deselection animation (if desired)
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else if(atableView==tableviewpdf)
    {
        btnselecteventdetail.titleLabel.text = [NSString stringWithFormat:@"%@",[EventDocumentTitleArray objectAtIndex:indexPath.row]];
        tableviewpdf.hidden = YES;
        value = false;
        imageViewDropdownPDF.image = [UIImage imageNamed:@"dropdown-down.png"];
    }
}

- (IBAction)btnselecteventdetail:(id)sender {
    
    if(value==true)
    {
        tableviewpdf.hidden=YES;
        value=false;
        imageViewDropdownPDF.image = [UIImage imageNamed:@"dropdown-down.png"];
        return;
    }
    
    tableviewpdf.hidden = NO;
    value = true;
    imageViewDropdownPDF.image = [UIImage imageNamed:@"dropdown-up.png"];
    
    
    
    
    
    
}

- (IBAction)btnViewPDF:(id)sender {
    
       NSString *abc = btnselecteventdetail.titleLabel.text;
    

    if([abc isEqualToString:@"   Select Docs"])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Kindly select a document first." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    NSUInteger index = [EventDocumentTitleArray indexOfObject:abc];
    NSString *UrlStr = [EventDocumentUrlsArray objectAtIndex:index];
    [[NSUserDefaults standardUserDefaults] setValue:abc forKey:@"Document Name"];
    eventDetailViewController*eventDetailsVc=[[eventDetailViewController alloc]initWithNibName:@"eventDetailViewController" bundle:nil];
    eventDetailsVc.pdfURL = UrlStr;
    [self.navigationController pushViewController:eventDetailsVc animated:NO];
}

-(void)createMenu{
    BOOL isEventDetailActive;
    BOOL isPingActive;
    BOOL isSlideShowActive;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *eventStatus =[NSString stringWithFormat:@"%@",[defaults valueForKey:@"Event Status"]];
    NSString *pingAssistanceStatus = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"PingAssistance"]];
    NSString *slideShowStatus = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"SlideShow"]];
    
    if ([eventStatus isEqualToString:@"1"]) {
        isEventDetailActive = YES;
    }else{
        isEventDetailActive = NO;
    }
    
    if ([pingAssistanceStatus isEqualToString:@"1"]) {
        isPingActive = YES;
    }else{
        isPingActive = NO;
    }
    
    if ([slideShowStatus isEqualToString:@"1"]) {
        isSlideShowActive = YES;
    }else{
        isSlideShowActive = NO;
    }
    
    
    // Menu Bar...............
    [self.bottomMenuView setFrame:CGRectMake(0, self.sideScroller.frame.size.height - self.bottomMenuView.frame.size.height-20, self.bottomMenuView.frame.size.width, self.bottomMenuView.frame.size.height)];
    [self.sideScroller addSubview:self.bottomMenuView];
    
    if (isPingActive) {
        //Ping Button...............
        [self.pingBtn setFrame:CGRectMake(self.slideMenuBtn.frame.size.width, 2, self.pingBtn.frame.size.width, self.pingBtn.frame.size.height)];
        [self.bottomMenuView addSubview:self.pingBtn];
        
        //Ping Button Image...............
        [self.otherMenuPingBulbImg setFrame:CGRectMake(self.pingBtn.frame.size.width/4, self.pingBtn.frame.size.height/4-4, self.otherMenuPingBulbImg.frame.size.width, self.otherMenuPingBulbImg.frame.size.height)];
        [self.pingBtn addSubview:self.otherMenuPingBulbImg];
        
        UIImageView *seperatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.pingBtn.frame.origin.x+self.pingBtn.frame.size.width+1,0,2,self.bottomMenuView.frame.size.height)];
        seperatorImg.image = [UIImage imageNamed:@"stroke_13.png"];
        [self.bottomMenuView addSubview:seperatorImg];
        
        //OphemyLogo View.....
        [self.ophemyLogoView setFrame:CGRectMake(self.pingBtn.frame.origin.x + self.pingBtn.frame.size.width+1, 4, self.ophemyLogoView.frame.size.width, self.ophemyLogoView.frame.size.height)];
        [self.bottomMenuView addSubview:self.ophemyLogoView];
    }else{
        self.pingBtn.hidden = YES;
        self.otherMenuPingBulbImg.hidden = YES;
        //OphemyLogo View.....
        [self.ophemyLogoView setFrame:CGRectMake(self.slideMenuBtn.frame.size.width+1, 4, self.ophemyLogoView.frame.size.width, self.ophemyLogoView.frame.size.height)];
        [self.bottomMenuView addSubview:self.ophemyLogoView];
    }
    
    int leftWidth = self.bottomMenuView.frame.size.width - (self.ophemyLogoView.frame.origin.x + self.ophemyLogoView.frame.size.width);
    NSLog(@"Left Width = %d",leftWidth);
    
    NSMutableArray *buttonsArray = [[NSMutableArray alloc] initWithObjects:@"Slide Show",@"Event Detail",@"Menu",@"View Order", nil];
    if (!isSlideShowActive) {
        [buttonsArray removeObject:@"Slide Show"];
    }
    
    if (!isEventDetailActive) {
        [buttonsArray removeObject:@"Event Detail"];
    }
    //    UIButton *bottomBarBtn;
    for (int j = 0; j < buttonsArray.count; j++) {
        
        NSLog(@"Value of i ...... %d",j);
        UIButton *bottomBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(j *leftWidth/buttonsArray.count+(self.ophemyLogoView.frame.origin.x + self.ophemyLogoView.frame.size.width)+2,2,leftWidth/buttonsArray.count, self.bottomMenuView.frame.size.height)];
        
        NSString * title = [NSString stringWithFormat:@"%@",[buttonsArray objectAtIndex:j]];
        [bottomBarBtn setTitle:[title uppercaseString] forState:UIControlStateNormal];
        [bottomBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        [bottomBarBtn setUserInteractionEnabled:YES];
        [bottomBarBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        bottomBarBtn.titleLabel.font =[UIFont fontWithName:@"Helvetica-Condensed" size:20];
        [bottomBarBtn setImageEdgeInsets:UIEdgeInsetsMake(0, bottomBarBtn.titleLabel.bounds.size.width-10, 0, 0)];
        if ([title isEqualToString:@"Event Detail"]) {
            [bottomBarBtn setBackgroundColor:[UIColor colorWithRed:194/255.0f green:57/255.0f blue:11/255.0f alpha:1.0]];
        }
        if ([title isEqualToString:@"View Order"]) {
            [bottomBarBtn setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
            CGRect frameIcon = bottomBarBtn.imageView.frame;
            NSLog(@"%f , %f , %f ,%f",frameIcon.origin.x,frameIcon.origin.y,frameIcon.size.width,frameIcon.size.height);
            [self.otheMenuBatchImg setFrame:CGRectMake(frameIcon.origin.x + frameIcon.size.width/2.5,0, 20, 20)];
            [bottomBarBtn addSubview:self.otheMenuBatchImg];
            [bottomBarBtn bringSubviewToFront:self.otheMenuBatchImg];
            
            [self.otherMenuBatchLbl setFrame:CGRectMake(frameIcon.origin.x + frameIcon.size.width/2.5,0, 20, 20)];
            [bottomBarBtn addSubview:self.otherMenuBatchLbl];
            [bottomBarBtn bringSubviewToFront:self.otherMenuBatchLbl];
            
        }
        //        [bottomBarBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [bottomBarBtn addTarget:self action:@selector(bottomBarBtns:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomMenuView addSubview:bottomBarBtn];
        
        UIImageView *seperatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(j *leftWidth/buttonsArray.count+(self.ophemyLogoView.frame.origin.x + self.ophemyLogoView.frame.size.width),0,2,self.bottomMenuView.frame.size.height)];
        seperatorImg.image = [UIImage imageNamed:@"stroke_13.png"];
        [self.bottomMenuView addSubview:seperatorImg];
        
        
    }
}

-(IBAction)bottomBarBtns:(UIButton*)sender{
    NSLog(@"%@",sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:@"MENU"]){
        menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
        homeVC.isNewOrder = NO;
        [self.navigationController pushViewController:homeVC animated:NO];
    }else if ([sender.titleLabel.text isEqualToString:@"SLIDE SHOW"]){
        eventImagesSlideViewViewController *homeVC = [[eventImagesSlideViewViewController alloc] initWithNibName:@"eventImagesSlideViewViewController" bundle:nil];
        [self.navigationController pushViewController:homeVC animated:NO];
    }else if ([sender.titleLabel.text isEqualToString:@"VIEW ORDER"]){
        CheckOutViewController *homeVC = [[CheckOutViewController alloc] initWithNibName:@"CheckOutViewController" bundle:nil];
        [self.navigationController pushViewController:homeVC animated:NO];
    }
    
}
@end
