//
//  Utility.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/07.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
{
}

+ (double) get1Rm :(double)weight :(NSInteger)reps;
+ (NSArray *) getZenkaiTrDtKey :(NSInteger) keyTrId :(NSInteger) keyTrId2;
+ (NSString *)screenSize;
@end
