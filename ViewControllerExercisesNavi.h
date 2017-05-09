//
//  ViewControllerExercisesNavi.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/31.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrExercisesData.h"

@protocol ViewControllerExercisesNaviDelegate <UINavigationControllerDelegate>
// デリゲートメソッドを宣言
// （宣言だけしておいて，実装はデリゲート先でしてもらう）
- (void)trExerciesesData :(NSInteger)buiId :(NSInteger)syumokuId;
- (void)trExerciesesData2 :(NSInteger)buiId :(NSString *)buiName
                          :(NSInteger)syumokuId :(NSString *)syumokuName;
@end

@interface ViewControllerExercisesNavi : UINavigationController
{
    //選択データ
    TrExercisesData * _trExercisesData;
}
@property (nonatomic, assign) id<ViewControllerExercisesNaviDelegate> delegate;

//@property (nonatomic) NSString* testP1;
@property (nonatomic) NSInteger runMode; //1:部位のみ
@end
