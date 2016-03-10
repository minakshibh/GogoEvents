
#import "loginViewController.h"
#import "homeViewController.h"
#import "serviceProviderHomeViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "appHomeViewController.h"
#import "eventImagesSlideViewViewController.h"
#import "Base64.h"
#import "menuStateViewController.h"

@interface loginViewController ()

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *userID = [NSString stringWithFormat:@"Service@mailinator.com"]; 9882486511
//    NSString *password = [NSString stringWithFormat:@"123456"];
//    [self loginWebservice:userID :password];
    
     lblbackground.layer.cornerRadius = 4.0;  [lblbackground setClipsToBounds:YES];
    self.loginBtn.layer.cornerRadius = 4.0;  [self.loginBtn setClipsToBounds:YES];
    lblbackground.layer.borderColor= [[UIColor colorWithRed:176/255.0f green:40/255.0f blue:35/255.0f alpha:1.0f] CGColor];
    lblbackground.layer.borderWidth = 1;
    [self.userNameTxt setValue:[UIColor lightGrayColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.userPasswordTxt setValue:[UIColor lightGrayColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    
    // [self menuItems];
    [self.userPasswordTxt setDelegate:self];
    appdelegate = [[UIApplication sharedApplication] delegate];
    appdelegate.navigator.navigationBarHidden = YES;
    [self.userPasswordTxt setDelegate:self];
    [self.userNameTxt setDelegate:self];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if (IS_IPAD_Pro) {
        activityIndicator.center = CGPointMake(1366/2, 1028/2);
    }else{
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    }
    activityIndicator.color=[UIColor whiteColor];

    [self.view addSubview:activityIndicator];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)login:(id)sender {
    [self.loginScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.userPasswordTxt resignFirstResponder];
    if ([self.userNameTxt.text isEqualToString:@""] || [self.userPasswordTxt.text isEqualToString:@""]) {
        UIAlertView *registeralert = [[UIAlertView alloc] initWithTitle:@"Nini Events" message:@"Please enter the required information." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [registeralert show];
//    }
//    else if ([emailTest evaluateWithObject:self.userNameTxt.text] != YES)
//    {
//        UIAlertView *registeralert = [[UIAlertView alloc] initWithTitle:@"Nini Events" message:@"Please enter valid user email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [registeralert show];
    }else{
        [self.loginScroller setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.userPasswordTxt resignFirstResponder];
        NSString *userID = [NSString stringWithFormat:@"%@",self.userNameTxt.text];
        NSString *password = [NSString stringWithFormat:@"%@",self.userPasswordTxt.text];
        [self loginWebservice:userID :password];
        
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = self.loginScroller.contentOffset;
    
    if (textField == self.userNameTxt || textField == self.userPasswordTxt) {
        
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:self.loginScroller];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 100;
        [self.loginScroller setContentOffset:pt animated:YES];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.loginScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.loginScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
-(void)menuItems
{
    [self disabled];
    [activityIndicator startAnimating];
    NSString *timeStamp = [NSString stringWithFormat:@""];
    
     NSString *eventId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Event ID"]];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:timeStamp, @"Timestamp",eventId,@"EventId", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchCategoryItems",Kwebservices]];
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode =2;
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


-(void)loginWebservice:(NSString *) userid :(NSString *) password
{
    [self disabled];
    [activityIndicator startAnimating];
  
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"UserId",password, @"Password", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Login",Kwebservices]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode =3;
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
#pragma mark -Json Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self enable];
    [activityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Internet connection seems to be down. Application might not work properly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  
    if (webServiceCode == 1) {
        
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        [self enable];
        [activityIndicator stopAnimating];
        
        
        if ([[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Role"]] isEqualToString:@"ServiceProvider"]) {
            serviceProviderHomeViewController *serviceProviderHomeVC= [[serviceProviderHomeViewController alloc]initWithNibName:@"serviceProviderHomeViewController" bundle:nil];
            [self.navigationController pushViewController:serviceProviderHomeVC animated:YES];
        }else{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *slideShowStatus = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"SlideShow"]];
            if ([slideShowStatus isEqualToString:@"1"]) {
                eventImagesSlideViewViewController *homeVC= [[eventImagesSlideViewViewController alloc]initWithNibName:@"eventImagesSlideViewViewController" bundle:nil];
                [self.navigationController pushViewController:homeVC animated:YES];
            }else{
                menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
                homeVC.isNewOrder = NO;
                [self.navigationController pushViewController:homeVC animated:NO];
            }
            appdelegate = [[UIApplication sharedApplication] delegate];
            appdelegate.startIdleTimmer = YES;
            [appdelegate resetIdleTimer];
        }
    }
    else if (webServiceCode == 2){
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
            NSLog(@"responseString:%@",responseString);
            NSError *error;
            
            responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
            
            SBJsonParser *json = [[SBJsonParser alloc] init];
            menuDetails = [[NSMutableArray alloc]init];
            menuCategoryIdsArray = [[NSMutableArray alloc]init];
            menuItemsDetail = [[NSMutableArray alloc] init];
            itemsIdsArray = [[NSMutableArray alloc]init];
            NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
            NSLog(@"Dictionary %@",userDetailDict);
            if (userDetailDict.count != 0) {
             
            NSString *resultStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"updatedtimestamp"]];
            [defaults setObject:resultStr forKey:@"menuTimeStamp"];
            NSMutableArray *menuData = [[NSMutableArray alloc] initWithArray:[userDetailDict valueForKey:@"listCategory"]];
            for (int i =0; i < [menuData count]; i++) {
                menuObj = [[menuOC alloc]init];
                menuObj.categoryID = [[[menuData valueForKey:@"categoryId"] objectAtIndex:i] intValue];
                menuObj.categoryName = [[menuData valueForKey:@"categoryName"] objectAtIndex:i];
                menuObj.type = [[menuData valueForKey:@"type"] objectAtIndex:i];
                
                menuObj.isDeleted = [[[menuData valueForKey:@"IsDeleted"] objectAtIndex:i]intValue];
                menuObj.itemsList = [[menuData valueForKey:@"listFoodItems"] objectAtIndex:i];
                
                for (int j = 0;j<[menuObj.itemsList count]; j++) {
                    
                    menuItemsObj = [[menuItemsOC alloc]init];
                    menuItemsObj.categoryId = [[NSString stringWithFormat:@"%d",menuObj.categoryID]intValue];
                    menuItemsObj.ItemId = [[[menuObj.itemsList valueForKey:@"ItemId"] objectAtIndex:j]intValue];
                    menuItemsObj.ItemName = [[menuObj.itemsList valueForKey:@"ItemName"] objectAtIndex:j];
                    menuItemsObj.Cuisine = [[menuObj.itemsList valueForKey:@"Cuisine"] objectAtIndex:j];
                    menuItemsObj.type = [[menuObj.itemsList valueForKey:@"Type"] objectAtIndex:j];
                    menuItemsObj.Quantity = [[[menuObj.itemsList valueForKey:@"Quantity"] objectAtIndex:j] intValue];
                    menuItemsObj.Price = [[menuObj.itemsList valueForKey:@"Price"] objectAtIndex:j];
                    menuItemsObj.Image = [[menuObj.itemsList valueForKey:@"Image"] objectAtIndex:j];
                    menuItemsObj.Image = [menuItemsObj.Image stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                    
                    
                    [self imageDownloading:menuItemsObj.Image :menuItemsObj.ItemName];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", menuItemsObj.Image]];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                  //  UIImage *img = [UIImage imageWithData:data];
                    
                //    NSData* imgdata = UIImageJPEGRepresentation(img, 0.3f);
                    NSString *strEncoded = [Base64 encode:data];
                    menuItemsObj.Image = [NSString stringWithFormat:@"%@.png",menuItemsObj.ItemName];
                    
                    
                    menuObj.imageUrl = @"";
                    menuItemsObj.IsDeletedItem = [[[menuObj.itemsList valueForKey:@"IsDeleted"] objectAtIndex:j] intValue];
                    [menuItemsDetail addObject:menuItemsObj];
                    [itemsIdsArray addObject:[NSString stringWithFormat:@"%d",menuItemsObj.ItemId]];
                }
                
                [menuDetails addObject:menuObj];
                [menuCategoryIdsArray addObject:[NSString stringWithFormat:@"%d",menuObj.categoryID]];
            }
            
            docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDir = [docPaths objectAtIndex:0];
            dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
            database = [FMDatabase databaseWithPath:dbPath];
            [database open];
            
            NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM menu "];
            FMResultSet *results1 = [database executeQuery:queryString1];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            while([results1 next]) {
                [tempArray addObject:[results1 stringForColumn:@"categoryID"]];
            }
            
            
            for (int i = 0;i < [menuCategoryIdsArray count]; i++) {
                menuObj = [menuDetails objectAtIndex:i];
                if ([tempArray containsObject:[menuCategoryIdsArray objectAtIndex:i]]) {
                    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE menu SET categoryName = \"%@\" , type = \"%@\",imageUrl = \"%@\" , where categoryID = %d" ,menuObj.categoryName,menuObj.type,menuObj.imageUrl,menuObj.categoryID];
                    [database executeUpdate:updateSQL];
                }else{
                    NSString *insert = [NSString stringWithFormat:@"INSERT INTO menu (categoryID, categoryName, type, imageUrl) VALUES (%d, \"%@\", \"%@\", \"%@\")",menuObj.categoryID,menuObj.categoryName,menuObj.type,menuObj.imageUrl];
                    [database executeUpdate:insert];
                }
                
            }
            //
            //
            //
            //            NSString *queryString = [NSString stringWithFormat:@"Select * FROM menu where type = \"%@\"", [NSString stringWithFormat:@"Food"]];
            //            FMResultSet *results = [database executeQuery:queryString];
            //
            //
            //            while([results next]) {
            //                menuObj = [[menuOC alloc] init];
            //                menuObj.categoryID = [results intForColumn:@"categoryID"];
            //                menuObj.categoryName = [results stringForColumn:@"categoryName"];
            //                menuObj.type = [results stringForColumn:@"type"];
            //            }
            
            NSString *itemsQueryString = [NSString stringWithFormat:@"Select * FROM categoryItems "];
            FMResultSet *itemsResults = [database executeQuery:itemsQueryString];
            NSMutableArray *itemsTempArray = [[NSMutableArray alloc] init];
            while([itemsResults next]) {
                [itemsTempArray addObject:[itemsResults stringForColumn:@"itemID"]];
            }
            for (int i = 0;i < [itemsIdsArray count]; i++) {
                
                menuItemsObj = [menuItemsDetail objectAtIndex:i];
                if ([itemsTempArray containsObject:[itemsIdsArray objectAtIndex:i]]) {
                    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE categoryItems SET itemName = \"%@\" , cuisine = \"%@\", categoryID = %d, typeID=\"%@\" ,quantity=%d ,itemPrice=\"%@\" ,itemImage=\"%@\" where itemID = %d" ,menuItemsObj.ItemName,menuItemsObj.Cuisine,menuItemsObj.categoryId,menuItemsObj.type,menuItemsObj.Quantity,menuItemsObj.Price,menuItemsObj.Image,menuItemsObj.ItemId];
                    [database executeUpdate:updateSQL];
                }else{
                    
                    NSString *insert = [NSString stringWithFormat:@"INSERT INTO categoryItems (itemID, itemName, cuisine, categoryID, typeID, quantity,itemPrice, itemImage) VALUES (%d, \"%@\", \"%@\",%d,\"%@\",%d,\"%@\",\"%@\")",menuItemsObj.ItemId,menuItemsObj.ItemName,menuItemsObj.Cuisine,menuItemsObj.categoryId,menuItemsObj.type,menuItemsObj.Quantity,menuItemsObj.Price,menuItemsObj.Image];
                    [database executeUpdate:insert];
                }
                
            }
            [database close];
            //[self loginWebservice:[NSString stringWithFormat:@"table3@test.com"] :[NSString stringWithFormat:@"table3"]];
                
        }
        }
        
//        [self registerDevice];

        [self fetchBannerImages];
        
    }
    
    else if(webServiceCode == 3){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSString *resultStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"result"]];
       
        [defaults setObject:[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"role"]] forKey:@"Role"];
        if ([resultStr isEqualToString:@"0"]) {
            if ([[userDetailDict valueForKey:@"role"] isEqualToString:@"ServiceProvider"]) {
               
                iPadIdsArray=[[NSMutableArray alloc]init];
                tablesArray=[[NSMutableArray alloc]init];
                tablesArray = [[userDetailDict valueForKey:@"listTables"]mutableCopy];
//                iPadIdsArray = [[tablesArray valueForKey:@"id"] mutableCopy];

                
                [defaults setObject:tablesArray forKey:@"Alloted Tables"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [defaults setValue:[userDetailDict valueForKey:@"id"] forKey:@"Service Provider ID"];
                [defaults setValue:[userDetailDict valueForKey:@"name"] forKey:@"Service Provider Name"];
                [defaults setValue:[userDetailDict valueForKey:@"image"] forKey:@"Service Provider image"];
                [defaults removeObjectForKey:@"userImage"];
                NSString*picUrl=[userDetailDict valueForKey:@"image"];
                if (picUrl.length==0) {
                    [defaults setValue:@"" forKey:@"userImage"];
                }
                else{
                    NSURL *imageURL=[NSURL URLWithString:[picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                    [defaults setValue:tempData forKey:@"userImage"];

                }
                
                
                [defaults setValue:[userDetailDict valueForKey:@"eventId"] forKey:@"Event ID"];
                [self registerDevice];
                
            }else{
                tablesArray = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"listTables"]];
                [defaults setObject:tablesArray forKey:@"Alloted Service Provider"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [defaults setValue:[userDetailDict valueForKey:@"id"] forKey:@"Table ID"];
                [defaults setValue:[userDetailDict valueForKey:@"name"] forKey:@"Table Name"];
                [defaults setValue:[userDetailDict valueForKey:@"image"] forKey:@"Table image"];
                [defaults setValue:[userDetailDict valueForKey:@"eventId"] forKey:@"Event ID"];
                [defaults removeObjectForKey:@"userImage"];
                [defaults setValue:[userDetailDict valueForKey:@"id"] forKey:@"Ipad ID"];
                
                
                
//                if (![prevEventIdStr isEqualToString:newEventIdStr]) {
                    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    documentsDir = [docPaths objectAtIndex:0];
                    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
                    database = [FMDatabase databaseWithPath:dbPath];
                    [database open];
                    
                    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM categoryItems"];
                    [database executeUpdate:queryString1];
                    NSString *queryString2 = [NSString stringWithFormat:@"Delete FROM menu"];
                    [database executeUpdate:queryString2];
                    
                    [database close];
                
//                }
                [self menuItems];
                
            }
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"NO"] forKey:@"isLogedOut"];
            
        }else{
            [self enable];
            [activityIndicator stopAnimating];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OPHEMY" message:[userDetailDict valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else if (webServiceCode == 4)
    {
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSMutableArray *fetchingImages = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"ListBanner"]];
        imagesUrlArray = [[NSMutableArray alloc]init];
        
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM banner"];
        [database executeUpdate:queryString1];
        [database close];
        
        for (int i = 0; i < [fetchingImages count]; i++) {
            
            NSString *bannerImage = [NSString stringWithFormat:@"%@",[[fetchingImages valueForKey:@"URL"] objectAtIndex:i]];
            NSString *BannerId= [NSString stringWithFormat:@"banner%@",[[fetchingImages valueForKey:@"BannerId"] objectAtIndex:i]];
            NSString *descriptionStr = [NSString stringWithFormat:@"%@",[[fetchingImages valueForKey:@"Description"] objectAtIndex:i]];

            [self imageDownloading:bannerImage :BannerId];
            
            bannerImage = [NSString stringWithFormat:@"%@.png",BannerId];
            
            docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDir = [docPaths objectAtIndex:0];
            dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
            database = [FMDatabase databaseWithPath:dbPath];
            [database open];
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO banner (bannerId, bannerData, bannerDescription) VALUES ( \"%@\", \"%@\", \"%@\")",BannerId,bannerImage,descriptionStr];
            [database executeUpdate:insert];
            
            [database close];

            
            
            
          //  [imagesUrlArray addObject:urlStr];
        }
      //  [defaults setObject:imagesUrlArray forKey:@"ImageArray"];
        [self fetchEventDetails];
    }else if (webServiceCode == 5) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        NSError *error;
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        int result1=[[userDetailDict valueForKey:@"result"]intValue];
        if (result1 !=1)
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
            
            [defaults setValue:eventChatSupport forKey:@"Event Chat Support"];
            [defaults setValue:[userDetailDict valueForKey:@"EventName"] forKey:@"EventName"];
            [defaults setValue:[userDetailDict valueForKey:@"ListEventDetails"] forKey:@"ListEventDetails"];
            [defaults setValue:[userDetailDict valueForKey:@"IsfreeEvent"] forKey:@"Is Paid"];
            [defaults setValue:[userDetailDict valueForKey:@"EventCurrencySymbol"] forKey:@"EventCurrencySymbol"];
            appdelegate=[[UIApplication sharedApplication]delegate];
            NSString*currencyStr=[userDetailDict valueForKey:@"EventCurrencySymbol"];
            NSString *substring;
            NSLog(@"%@",currencyStr);
            if (![currencyStr isEqualToString:@""]) {
                NSRange range = [currencyStr rangeOfString:@"("];
                substring = [[currencyStr substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                substring = [substring substringToIndex:1];
            }else{
                substring = @"";
            }
            
            
            
            appdelegate.currencySymbol=substring;
            [[NSUserDefaults standardUserDefaults] setValue:substring forKey:@"Currency Value"];
            if ([userDetailDict valueForKey:@"EventPictureUrl"] !=[NSNull null]) {
                
                NSString *eventImageStr = [userDetailDict valueForKey:@"EventPictureUrl"];
                NSString *eventID = [userDetailDict valueForKey:@"EventName"];
                
                [self imageDownloading:eventImageStr :eventID];
                
                eventImageStr = [NSString stringWithFormat:@"%@.png",eventID];
                
                [defaults setValue:eventImageStr forKey:@"EventImage"];
                
            }
        }
        [self registerDevice];
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
    
    webServiceCode = 5;
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

-(void)registerDevice
{
    [self disabled];
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *role;
    NSString *deviceUDID;
    NSString *tokenId;
    NSString *triggerValue;
    NSString *tableID;
    NSString *serviceProviderID;
    NSUUID *myDevice1 = [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"udid is %@",myDevice1.UUIDString);
    NSString *deviceUdid=myDevice1.UUIDString;
    NSLog(@"Device Tocken is %@",[defaults valueForKey:@"DeviceToken"]);
    NSString *user_UDID_Str=[NSString stringWithString:deviceUdid];
    if (role == nil) {
        role =[NSString stringWithFormat:@"%@",[defaults valueForKey:@"Role"]];
    }
    if (deviceUDID == nil) {
        deviceUDID = [NSString stringWithFormat:@"%@",user_UDID_Str];
    }
    if (tokenId == nil) {
        tokenId = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"DeviceToken"]];
    }
    if (triggerValue == nil) {
        triggerValue = [NSString stringWithFormat:@"ios"];
    }
    if (tableID == nil) {
        if ([role isEqualToString:@"Customer"]) {
            tableID = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Ipad ID"]];
        }else{
            tableID = [NSString stringWithFormat:@"0"];
        }
    }
    if (serviceProviderID == nil) {
        if ([role isEqualToString:@"ServiceProvider"]) {
            serviceProviderID = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Service Provider ID"]];
        }else{
            NSArray *serviceproviderArray = [[[NSMutableArray alloc]initWithObjects:[defaults valueForKey:@"Alloted Service Provider"], nil] objectAtIndex:0];
            NSLog(@"Tables... %@",serviceproviderArray);
            for (int i =0 ; i <[serviceproviderArray count] ; i++) {
                
                NSString *seriveProviderId = [[serviceproviderArray valueForKey:@"id"]objectAtIndex:i];
                [defaults setValue:seriveProviderId forKey:@"AllotedServiceProviderId"];
                serviceProviderID = [NSString stringWithFormat:@"%@",seriveProviderId];
            }
        }
    }
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:role,@"Role",[NSString stringWithFormat:@"1"], @"RestaurantId",tableID,@"TableId",serviceProviderID,@"StaffId",deviceUDID, @"DeviceUDId",tokenId,@"TokenID",triggerValue, @"Trigger", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RegisterDevice",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    webServiceCode = 1;
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
-(void) fetchBannerImages
{
    [activityIndicator startAnimating];
    NSString *eventId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Event ID"]];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:eventId,@"EventId", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetBanners",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"Post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode = 4;
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
- (void) disabled
{
    self.view.userInteractionEnabled = NO;
    self.disabledImgView.hidden = NO;
}
- (void) enable
{
    self.view.userInteractionEnabled = YES;
    self.disabledImgView.hidden = YES;
}
- (IBAction)ForgotPassword:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://112.196.24.205:815/ForgotPassword.aspx"]];

}
- (IBAction)Register:(id)sender {
    
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://112.196.24.205:815/RegisterAdmin.aspx"]];
    
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
    [request startAsynchronous];
    
}

@end
