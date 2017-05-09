//
//  ViewControllerHistory.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/04.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrSettings.h"
#import "DBConnector.h"

@interface ViewControllerHistory : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    TrSettings     * _trSettings;
    DBConnector    * _db;
    NSMutableArray * _tableSection;
    NSMutableArray * _tableKey;
    NSMutableArray * _tableVal;
    NSMutableArray * _tableVal2;
    NSString       * _keyTrDateMonth;
    NSString       * _valTrDateMonth;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
