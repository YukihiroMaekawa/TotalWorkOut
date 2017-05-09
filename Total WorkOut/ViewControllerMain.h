//
//  ViewControllerMain.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrSettings.h"
#import "TrMaster.h"

@interface ViewControllerMain : UIViewController<UITableViewDelegate, UITableViewDataSource>

{
    TrSettings *_trSettings;
    TrMaster   *_trMaster;
    NSMutableArray * _tableSection;
    //セクション１
    NSMutableArray * _tableKey;
    NSMutableArray * _tableVal;
    //セクション２
    NSMutableArray * _tableDataKey;
    NSMutableArray * _tableDataVal;    
    //セクション３
    NSMutableArray * _tableSetthingKey;
    NSMutableArray * _tableSetthingVal;

    NSInteger _runModeSearch; //1 検索 2:グラフ検索
    NSString *_navigationBarTitle;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
