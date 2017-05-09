//
//  ViewControllerHistory2.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/06.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrSettings.h"
#import "DBConnector.h"

@interface ViewControllerHistory2 : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    TrSettings     * _trSettings;
    DBConnector    * _db;
    NSMutableArray * _tableSection;
    NSMutableArray * _tableKey;
    NSMutableArray * _tableVal;
    NSInteger        _selectedKeyTrHd;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) bool      isEdit;
@property (nonatomic) NSInteger serchMode; // 1:日付 //2：TrId // 3:Search
@property (nonatomic) NSString *keyTrDateMonth;
@property (nonatomic) NSString *titleString;
@property (nonatomic) NSInteger keyTrHd;
@property (nonatomic) NSString *keyDateSt;
@property (nonatomic) NSString *keyDateEd;
@property (nonatomic) NSInteger keyBuiId;
@property (nonatomic) NSInteger keySyumokuId;
@end
