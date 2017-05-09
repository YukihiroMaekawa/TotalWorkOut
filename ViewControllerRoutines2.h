//
//  ViewControllerRoutines2.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/05.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrSettings.h"
#import "DBConnector.h"

@interface ViewControllerRoutines2 : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    TrSettings     * _trSettings;
    DBConnector    * _db;
    NSMutableArray * _tableSection;
    NSMutableArray * _tableKey;
    NSMutableArray * _tableVal;
    NSInteger _runMode; // 1:マスター追加
    NSString * _inputValue;
}
@property (nonatomic) NSInteger keyTrRoutineId;
@property (nonatomic) NSString *trRoutineName;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
