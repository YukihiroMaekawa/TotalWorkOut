//
//  ViewControllerSetthings.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/03.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrMaster.h"
#import "TrSettings.h"

@interface ViewControllerSetthings : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    TrMaster *_trMaster;
    TrSettings * _trSettings;
    
    NSMutableArray * _tableSection;
    NSMutableArray * _tableValLanguage;
    NSMutableArray * _tableValUnitWeight;
    NSMutableArray * _tableValUnitDistance;

    NSMutableArray * _tableVal3;
    NSMutableArray * _tableVal4;
    NSMutableArray * _tableVal5;
    
    NSInteger _runMode;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
