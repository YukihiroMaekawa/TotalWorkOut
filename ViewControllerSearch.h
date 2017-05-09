//
//  ViewControllerSearch.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/07.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrSettings.h"
#import "DBConnector.h"

@interface ViewControllerSearch : UIViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    TrSettings     * _trSettings;
    DBConnector    * _db;
    NSMutableArray * _tableSection;
    NSMutableArray * _tableKey;
    NSMutableArray * _tableVal;
    NSMutableArray * _tableKey2;
    NSMutableArray * _tableVal2;
    NSMutableArray * _tableKey3;
    NSMutableArray * _tableVal3;
    NSMutableArray * _tableKey4;
    NSMutableArray * _tableVal4;
    NSMutableArray * _tableKey5;
    NSMutableArray * _tableVal5;
    
    NSInteger        _lastTag;
    BOOL             _isPicker;
    BOOL             _isDatePicker;
    NSInteger        _setUIDatePickerMode;
    NSInteger        _setUIKeyboardType;

    NSString * _dateSt;
    NSString * _dateEd;
    NSString * _keyDateSt;
    NSString * _keyDateEd;
    NSInteger _runModeEx;

    NSInteger _buiId;
    NSString *_buiName;
    NSInteger _syumokuId;
    NSString *syumokuName;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSString * navigationBarTitle;
@property (nonatomic) NSInteger runMode; // 1:検索 2:グラフ検索
@end
