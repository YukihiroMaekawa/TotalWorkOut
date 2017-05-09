//
//  ViewControllerWorkOut.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/30.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrSettings.h"
#import "DBConnector.h"
#import "EntityDTrHd.h"
#import "ViewControllerCommonInput.h"

@interface ViewControllerWorkOut : UIViewController<ViewControllerCommonInputDelegate,UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource>
{
    TrSettings     * _trSettings;
    DBConnector    * _db;
    NSMutableArray * _tableSection;
    NSMutableArray * _tableValDate;
    NSMutableArray * _tableValBody;
    NSMutableArray * _tableValMemo;
    
    NSMutableArray * _tableKeyRoutine;
    NSMutableArray * _tableValRoutine;
    NSMutableArray * _tableKeyData;
    NSMutableArray * _tableValData;

   // NSInteger        _indexPath;
    NSInteger        _lastTag;
    BOOL             _isPicker;
    BOOL             _isDatePicker;
    NSInteger        _setUIDatePickerMode;
    NSInteger        _setUIKeyboardType;
    NSArray *        _arrPickerKey;
    NSMutableArray * _arrPickerVal;
    
    EntityDTrHd * _entityDTrHd;
    
    NSString *_navigationBarTitle;
    
    //Date
    enum {
        idxDate = 0
       ,idxTimeSt
    };

    //Body
    enum {
        idxWeight = 0
        ,idxFat
    };

    //Memos
    enum {
        idxMemo = 0
    };

    NSInteger _keyTrRoutineId;
}
@property (nonatomic) NSInteger keyTrHd;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
