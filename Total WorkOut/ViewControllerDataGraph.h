//
//  ViewControllerData2.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/05/08.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewGraphLine.h"
#import "TrSettings.h"
#import "DBConnector.h"

@interface ViewControllerDataGraph : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    TrSettings     * _trSettings;
    DBConnector    * _db;
    NSMutableArray * _tableSection;
    NSMutableArray * _tableKey;
    NSMutableArray * _tableLabelVal;
    NSMutableArray * _tableDataXVal;
    NSMutableArray * _tableDataYVal;
    NSMutableArray * _tableGraphData;

    NSInteger _selectedSegment;
    
    dispatch_queue_t _main_queue;
    dispatch_queue_t _sub_queue;
    UIActivityIndicatorView *_indicator;
    BOOL    _isCancelQue;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentChenged:(id)sender;

@property (nonatomic) NSString *keyDateSt;
@property (nonatomic) NSString *keyDateEd;
@property (nonatomic) NSInteger keyBuiId;
@property (nonatomic) NSInteger keySyumokuId;
@end
