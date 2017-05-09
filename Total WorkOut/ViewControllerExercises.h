//
//  ViewControllerExercises.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrSettings.h"
#import "DBConnector.h"
#import "TrExercisesData.h"

@protocol ViewControllerExercisesDelegate <NSObject>
// デリゲートメソッドを宣言
// （宣言だけしておいて，実装はデリゲート先でしてもらう）
- (void)testA :(NSString *)buiId :(NSString*)syumokuId;

@end

@interface ViewControllerExercises : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    TrSettings      * _trSettings;
    DBConnector     * _db;
    TrExercisesData *_trExercisesData;
    NSMutableArray * _tableSection;
    NSMutableArray * _tableKey;
    NSMutableArray * _tableVal;
    NSInteger _buiID;
    NSString *_buiName;
}
// デリゲート先で参照できるようにするためプロパティを定義しておく
@property (nonatomic, assign) id<ViewControllerExercisesDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) bool isEdit; //1:エディット
@end
