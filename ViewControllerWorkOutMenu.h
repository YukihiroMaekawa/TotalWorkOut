//
//  ViewControllerWorkOutMenu.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/30.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrSettings.h"
#import "DBConnector.h"

@interface ViewControllerWorkOutMenu : UIViewController<UITableViewDelegate, UITableViewDataSource,UITextViewDelegate>
{
    TrSettings     * _trSettings;
    DBConnector    * _db;
    NSMutableArray * _tableSection;
    NSMutableArray * _tableKey;
    NSMutableArray * _tableVal;
    NSMutableArray * _tableVal2;
    NSMutableArray * _tableRoutineKey;
    NSMutableArray * _tableRoutineVal;
    NSMutableArray * _tableResultKey;
    NSMutableArray * _tableResultVal;
    NSMutableArray * _tableBackKey;
    NSMutableArray * _tableBackVal;

    NSInteger _runMode; // 1：マスター追加 2：マスター変更
    NSInteger  _keyTrDt;
    NSInteger  _keyBuiId;
    
    NSString  *_syumokuName;
    
    NSInteger _keyTrRoutineId;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger keyTrHd;
@property (nonatomic) NSString *navigationBarTitle;
@end
