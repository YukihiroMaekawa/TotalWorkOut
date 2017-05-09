//
//  EntityMTrRoutineDt.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/05.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnector.h"

@interface EntityMTrRoutineDt : NSObject
@property NSInteger  pKeyTrRoutineId;
@property NSInteger  pKeyTrRoutineId2;
@property NSInteger  pTrBuiId;
@property NSInteger  pTrSyumokuId;

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trRoutineId :(NSInteger)trRoutineId2;
-(void) doInsert:(DBConnector *)db;
-(void) doUpdate:(DBConnector *)db;
-(void) doDelete:(DBConnector *)db;
-(NSInteger) getNextKey:(DBConnector *)db :(NSInteger)trRoutineId;
@end
