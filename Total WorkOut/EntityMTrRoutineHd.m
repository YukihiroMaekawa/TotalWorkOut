//
//  EntityMTrRoutineHd.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/05.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "EntityMTrRoutineHd.h"

@implementation EntityMTrRoutineHd
// 初期化
- (id)init
{
    if (self = [super init])
    {
        [self initProperty];
    }
    return self;
}

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trRoutineId
{
    if (self = [super init])
    {
        [self initProperty];
        self.pKeyTrRoutineId = trRoutineId;
        
        //データ取得
        [self doSelect:db];
    }
    return self;
}

-(void) initProperty{
    self.pKeyTrRoutineId = 0;
    self.pTrRoutineName = @"";
}

-(NSInteger) getNextKey:(DBConnector *)db
{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT IFNULL(MAX(tr_routine_id) ,0) + 1 AS tr_routine_id"
           "  FROM m_tr_routine_hd"
           ];
    
    [db executeQuery:sql];
    
    NSInteger keyValue = 0;
    
    while ([db.results next]) {
        keyValue = [db.results intForColumn:@"tr_routine_id"];
    }
    
    return (int) keyValue;
}

-(void) doSelect:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT "
           " tr_routine_id"
           ",tr_routine_name"
           "    FROM m_tr_routine_hd"
           "   WHERE tr_routine_id  = %d"
           ,(int)self.pKeyTrRoutineId
           ];
    
    [db executeQuery:sql];
    
    while ([db.results next]) {
        self.pTrRoutineName = [db.results stringForColumn:@"tr_routine_name"];
    }
}

-(void) doInsert:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"INSERT INTO m_tr_routine_hd"
           "("
           " tr_routine_id"
           ",tr_routine_name"
           ")"
           " SELECT"
           "  %d"
           ",'%@'"
           ,(int)self.pKeyTrRoutineId
           ,self.pTrRoutineName
           ];
    [db executeUpdate:sql];
}

-(void) doUpdate :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"UPDATE m_tr_routine_hd"
           "     SET tr_routine_name = '%@'"
           "   WHERE tr_routine_id = %d"
           ,self.pTrRoutineName
           ,(int)self.pKeyTrRoutineId
           ];
    [db executeUpdate:sql];
}

-(void) doDelete :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"DELETE FROM m_tr_routine_hd"
           "   WHERE tr_routine_id = %d"
           ,(int)self.pKeyTrRoutineId
           ];
    [db executeUpdate:sql];

    sql = [NSString stringWithFormat
           :@"DELETE FROM m_tr_routine_dt"
           "   WHERE tr_routine_id = %d"
           ,(int)self.pKeyTrRoutineId
           ];
    [db executeUpdate:sql];
    
}

@end
