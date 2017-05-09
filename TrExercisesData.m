//
//  ViewControllerTrExercisesData.m
//  Training Notebook
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//
#import "TrExercisesData.h"

static TrExercisesData* sharedParth = nil;

@implementation TrExercisesData

+ (TrExercisesData *)sharedManager{
    if (!sharedParth) {
        sharedParth = [TrExercisesData new];
    }
    return sharedParth;
}

- (id)init
{
    self = [super init];
    if (self) {
        //Initialization
    }
    return self;
}
@end