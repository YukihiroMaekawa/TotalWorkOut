//
//  EntityMTrRoutineDt.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/05.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "EntityMTrRoutineDt.h"
#import "DBConnector.h"

@implementation EntityMTrRoutineDt

// 初期化
- (id)init
{
    if (self = [super init])
    {
        [self initProperty];
    }
    return self;
}

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trRoutineId :(NSInteger)trRoutineId2
{
    if (self = [super init])
    {
        [self initProperty];
        self.pKeyTrRoutineId  = trRoutineId;
        self.pKeyTrRoutineId2 = trRoutineId2;
        
        //データ取得
        [self doSelect:db];
    }
    return self;
}

-(void) initProperty{
    self.pKeyTrRoutineId  = 0;
    self.pKeyTrRoutineId2 = 0;
    self.pTrBuiId         = 0;
    self.pTrSyumokuId     = 0;
}

-(NSInteger) getNextKey:(DBConnector *)db :(NSInteger)trRoutineId
{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT IFNULL(MAX(tr_routine_id2) ,0) + 1 AS tr_routine_id2"
           "  FROM m_tr_routine_dt"
           " WHERE tr_routine_id = %d"
           ,(int)trRoutineId
           ];
    
    [db executeQuery:sql];
    
    NSInteger keyValue = 0;
    
    while ([db.results next]) {
        keyValue = [db.results intForColumn:@"tr_routine_id2"];
    }
    
    return (int) keyValue;
}

-(void) doSelect:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT "
           " tr_routine_id"
           ",tr_routine_id2"
           ",tr_bui_id"
           ",tr_syumoku_id"
           "    FROM m_tr_routine_dt"
           "   WHERE tr_routine_id  = %d"
           "     AND tr_routine_id2 = %d"
           ,(int)self.pKeyTrRoutineId
           ,(int)self.pKeyTrRoutineId2
           ];
    
    [db executeQuery:sql];
    
    while ([db.results next]) {
        self.pTrBuiId     = [db.results intForColumn:@"tr_bui_id"];
        self.pTrSyumokuId = [db.results intForColumn:@"tr_syumoku_id"];
    }
}

-(void) doInsert:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"INSERT INTO m_tr_routine_dt"
           "("
           " tr_routine_id"
           ",tr_routine_id2"
           ",tr_bui_id"
           ",tr_syumoku_id"
           ")"
           " SELECT"
           "  %d"
           " ,%d"
           " ,%d"
           " ,%d"
           ,(int)self.pKeyTrRoutineId
           ,(int)self.pKeyTrRoutineId2
           ,(int)self.pTrBuiId
           ,(int)self.pTrSyumokuId
           ];
    [db executeUpdate:sql];
}

-(void) doUpdate :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"UPDATE m_tr_routine_dt"
           "     SET tr_bui_id     = %d"
           "        ,tr_syumoku_id = %d"
           "   WHERE tr_routine_id  = %d"
           "     AND tr_routine_id2 = %d"
           ,(int)self.pTrBuiId
           ,(int)self.pTrSyumokuId
           ,(int)self.pKeyTrRoutineId
           ,(int)self.pKeyTrRoutineId2
           ];
    [db executeUpdate:sql];
}

-(void) doDelete :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"DELETE FROM m_tr_routine_dt"
           "   WHERE tr_routine_id  = %d"
           "     AND tr_routine_id2 = %d"
           ,(int)self.pKeyTrRoutineId
           ,(int)self.pKeyTrRoutineId2
           ];
    [db executeUpdate:sql];
}
@end
