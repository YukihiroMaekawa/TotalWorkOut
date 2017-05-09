//
//  TrSettings.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/03.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "TrSettings.h"

@implementation TrSettings
// 初期化

- (id)init
{
    if (self = [super init])
    {
        [self loadAppVersion];
        [self loadLanguage];
        [self loadUnitWeight];
        [self loadUnitDistance];
    }
    return self;
}

- (void) resetAllData{
    
    //選択可能な言語設定の配列を取得
    NSArray *langs = [NSLocale preferredLanguages];
    
    //取得した配列から先頭の文字列を取得（先頭が現在の設定言語）
    NSString *currentLanguage = [langs objectAtIndex:0];
    
    self.appVersion      = @"0.01";
    if([currentLanguage compare:@"ja"] == NSOrderedSame) {
        self.defaultLanguage = 1;
    }else{
        self.defaultLanguage = 0;
        }
    self.unitWeight      = 0;
    self.unitDistance    = 0;
    [self saveAll];
}

- (void) saveAll{
    [self saveAppVersion];
    [self saveLanguage];
    [self saveUnitWeight];
    [self saveUnitDistance];
}

- (void) loadAppVersion{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.appVersion = [defaults stringForKey:@"appVersion"];
}
- (void) saveAppVersion{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.appVersion forKey:@"appVersion"];
    if ( ![defaults synchronize] ) {NSLog( @"failed ..." );}
}

- (void) loadLanguage{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.defaultLanguage = [defaults integerForKey:@"defaultLanguage"];
}
- (void) saveLanguage{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.defaultLanguage forKey:@"defaultLanguage"];
    if ( ![defaults synchronize] ) {NSLog( @"failed ..." );}
}

- (void) loadUnitWeight{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.unitWeight = [defaults integerForKey:@"unitWeight"];
}
- (void) saveUnitWeight{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.unitWeight forKey:@"unitWeight"];
    if ( ![defaults synchronize] ) {NSLog( @"failed ..." );}
}

- (void) loadUnitDistance{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.unitDistance = [defaults integerForKey:@"unitDistance"];
}
- (void) saveUnitDistance{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.unitDistance forKey:@"unitDistance"];
    if ( ![defaults synchronize] ) {NSLog( @"failed ..." );}
}

- (NSString*) getUnitWeightName{
    NSArray * setArr = [[NSArray alloc]initWithObjects:@"Kg",@"Lb", nil];
    return [setArr objectAtIndex:self.unitWeight];
}

- (NSString*) getUnitDistanceName{
    NSArray * setArr = [[NSArray alloc]initWithObjects:@"Mi",@"Km", nil];
    return [setArr objectAtIndex:self.unitDistance];
}

@end
