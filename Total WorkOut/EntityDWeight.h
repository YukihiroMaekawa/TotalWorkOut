//
//  EntityDWeight.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/12.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnector.h"

@interface EntityDWeight : NSObject
@property (nonatomic)      NSString *pDate;
@property (nonatomic)      NSString *pWeight;
@property (nonatomic)      NSString *pFat;
@property (nonatomic)      bool isExists;
- (id)initWithSelect :(DBConnector *)db :(NSString*)date;
-(void) doInsert:(DBConnector *)db;
-(void) doUpdate:(DBConnector *)db;
-(void) doDelete:(DBConnector *)db;

@end
