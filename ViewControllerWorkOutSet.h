//
//  ViewControllerWorkOutSet.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/01.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrSettings.h"
#import "DBConnector.h"

@interface ViewControllerWorkOutSet : UIViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
{
    TrSettings     * _trSettings;
    DBConnector    * _db;
    NSMutableArray * _tableSection;
    NSMutableArray * _tableKey;
    NSMutableArray * _tableVal;
    NSMutableArray * _tableVal2;
    NSMutableArray * _tableVal3;
    NSMutableArray * _tableSetDataVal;
    NSMutableArray * _tablePrevKey;
    NSMutableArray * _tablePrevVal;
    NSMutableArray * _tableBackKey;
    NSMutableArray * _tableBackVal;

    NSInteger        _keyTrHd3;
    NSString       * _trDate;
    NSInteger        _keyBuiId;
    NSInteger        _keySyumokuID;
    
    NSString       * _trKb;
    NSInteger        _lastTag;
    BOOL             _isPicker;
    BOOL             _isDatePicker;
    BOOL             _isTimeHHMMSSPicker;
    NSInteger        _setUIDatePickerMode;
    NSInteger        _setUIKeyboardType;
    NSArray *        _arrPickerKey;
    NSMutableArray * _arrPickerVal;
    
    NSInteger        _keyTrHdZen;
    NSInteger        _keyTrHd2Zen;
}

@property (nonatomic) NSInteger keyTrHd;
@property (nonatomic) NSInteger keyTrHd2;
@property (nonatomic) NSString *syumokuName;
@property (nonatomic) NSString *navigationBarTitle;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
