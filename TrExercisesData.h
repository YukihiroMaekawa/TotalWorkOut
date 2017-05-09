//
//  ViewControllerTrExercisesData.h
//  Training Notebook
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrExercisesData : NSObject{}
+ (TrExercisesData *)sharedManager;

//呼び出し時のモード
@property (nonatomic) NSInteger runMode; //1:部位のみ

@property (nonatomic)NSInteger buiId;
@property (nonatomic)NSString *buiName;
@property (nonatomic)NSInteger syumokuId;
@property (nonatomic)NSString *syumokuName;
@end
