//
//  TrSettings.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/03.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrSettings : NSObject
- (void) resetAllData;
- (void) saveAll;

- (void) loadAppVersion;
- (void) saveAppVersion;
- (void) loadLanguage;
- (void) saveLanguage;
- (void) loadUnitWeight;
- (void) saveUnitWeight;
- (void) loadUnitDistance;
- (void) saveUnitDistance;

- (NSString*) getUnitWeightName;
- (NSString*) getUnitDistanceName;

@property NSString *appVersion;
@property NSInteger defaultLanguage;
@property NSInteger unitWeight;
@property NSInteger unitDistance;

@end
