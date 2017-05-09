//
//  EntityMTrRoutineHd.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/05.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnector.h"

@interface EntityMTrRoutineHd : NSObject
@property NSInteger  pKeyTrRoutineId;
@property NSString * pTrRoutineName;

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trRoutineId;
-(void) doInsert:(DBConnector *)db;
-(void) doUpdate:(DBConnector *)db;
-(void) doDelete:(DBConnector *)db;
-(NSInteger) getNextKey:(DBConnector *)db;
@end
