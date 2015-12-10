//
//  gettingCountViewController.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 3/10/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tableAllotedOC.h"

@interface gettingCountViewController : UIViewController
{
    NSMutableData *webData;
    tableAllotedOC *tableAllotedObj;
     NSMutableArray *pingsList, *tableNameArray, *allChatMessages,*orderIdsArray, *tableAllotedIdsArray, *assignedTablesArray, *assignedTableTimestampsArray,*fetchedChatData, *fetchTableIdsArray,*tablesList,*fetchingChat;
     NSString *documentsDir, *dbPath,* timeStampKey, *selectedTable;
}
-(void) fetchCounts;
@property (strong, nonatomic) NSMutableArray *tablesAllotedArray;
@end
