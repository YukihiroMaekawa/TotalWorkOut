//
//  ViewControllerExercisesNavi.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/31.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerExercisesNavi.h"

@interface ViewControllerExercisesNavi ()

@end

@implementation ViewControllerExercisesNavi

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _trExercisesData = [TrExercisesData sharedManager];
    _trExercisesData.buiId       = 0;
    _trExercisesData.buiName     = @"";
    _trExercisesData.syumokuId   = 0;
    _trExercisesData.syumokuName = @"";
    _trExercisesData.runMode     = self.runMode;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    }
    [super viewWillDisappear:animated];

    _trExercisesData.runMode = 0;
    if ([self.delegate respondsToSelector:@selector(trExerciesesData::)]) {
        [self.delegate trExerciesesData:_trExercisesData.buiId:_trExercisesData.syumokuId];
    }
    if([self.delegate respondsToSelector:@selector(trExerciesesData2::::)]) {
        [self.delegate trExerciesesData2:_trExercisesData.buiId :_trExercisesData.buiName
                                        :_trExercisesData.syumokuId :_trExercisesData.syumokuName
         ];
    }
}

@end
