//
//  ViewControllerExercises2.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrSettings.h"
#import "DBConnector.h"
#import "ViewControllerCommonInput.h"
#import "TrExercisesData.h"

@protocol ViewControllerExercises2Delegate <NSObject>
// デリゲートメソッドを宣言
// （宣言だけしておいて，実装はデリゲート先でしてもらう）
- (void)retExercieseId :(NSString *)buiId :(NSString*)syumokuId;
@end


@interface ViewControllerExercises2 : UIViewController
<ViewControllerCommonInputDelegate,UITableViewDelegate, UITableViewDataSource>
{
    TrSettings     * _trSettings;
    DBConnector    * _db;
    NSMutableArray * _tableSection;
    NSMutableArray * _tableKey;
    NSMutableArray * _tableVal;
    NSInteger _syumokuID;
    NSInteger _runMode; // 1:マスター追加
    NSString * _inputValue;
    //選択データ
    TrExercisesData * _trExercisesData;

}

// デリゲート先で参照できるようにするためプロパティを定義しておく
@property (nonatomic, assign) id<ViewControllerExercises2Delegate> delegate;

@property (nonatomic) NSInteger buiID;
@property (nonatomic) NSString *buiName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger runMode;
@property (nonatomic) bool isEdit;
@end
