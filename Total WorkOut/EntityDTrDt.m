//
//  EntityDTrDt.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/30.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "EntityDTrDt.h"
#import "DBConnector.h"

@implementation EntityDTrDt
// 初期化
- (id)init
{
    if (self = [super init])
    {
        [self initProperty];
    }
    return self;
}

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trId :(NSInteger)trId2
{
    if (self = [super init])
    {
        [self initProperty];
        self.pKeyTrId  = trId;
        self.pKeyTrId2 = trId2;
        
        //データ取得
        [self doSelect:db];
    }
    return self;
}

-(void) initProperty{
    self.pKeyTrId     = 0;
    self.pKeyTrId2    = 0;
    self.pTrBuiId     = 0;
    self.pTrSyumokuId = 0;
    self.pWeightUnit  = 0;
    self.pSetTotal    = 0;
}

-(NSInteger) getNextKey:(DBConnector *)db :(NSInteger)trId
{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT IFNULL(MAX(tr_id2) ,0) + 1 AS tr_id2"
           "  FROM d_tr_dt"
           " WHERE tr_id = %d"
          ,(int)trId
           ];
    
    [db executeQuery:sql];
    
    NSInteger keyValue = 0;
    
    while ([db.results next]) {
        keyValue = [db.results intForColumn:@"tr_id2"];
    }
    
    return (int) keyValue;
}

-(void) doSelect:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT "
           " tr_id"
           ",tr_id2"
           ",tr_bui_id"
           ",tr_syumoku_id"
           ",weight_unit"
           ",set_total"
           "    FROM d_tr_dt"
           "   WHERE tr_id  = %d"
           "     AND tr_id2 = %d"
           ,(int)self.pKeyTrId
           ,(int)self.pKeyTrId2
           ];
    
    [db executeQuery:sql];
    
    while ([db.results next]) {
        self.pTrBuiId     = [db.results intForColumn:@"tr_bui_id"];
        self.pTrSyumokuId = [db.results intForColumn:@"tr_syumoku_id"];
        self.pWeightUnit  = [db.results intForColumn:@"weight_unit"];
        self.pSetTotal    = [db.results intForColumn:@"set_total"];

    }
}

-(void) doInsert:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"INSERT INTO d_tr_dt"
           "("
           " tr_id"
           ",tr_id2"
           ",tr_bui_id"
           ",tr_syumoku_id"
           ",weight_unit"
           ",set_total"
           ")"
           " SELECT"
           "  %d"
           ", %d"
           ", %d"
           ", %d"
           ", %d"
           ", %d"
           ,(int)self.pKeyTrId
           ,(int)self.pKeyTrId2
           ,(int)self.pTrBuiId
           ,(int)self.pTrSyumokuId
           ,(int)self.pWeightUnit
           ,(int)self.pSetTotal
           ];
    [db executeUpdate:sql];
}

-(void) doUpdate :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"UPDATE d_tr_dt"
           "     SET tr_bui_id     = %d"
           "        ,tr_syumoku_id = %d"
           "        ,weight_unit   = %d"
           "        ,set_total     = %d"
           "   WHERE tr_id  = %d"
           "     AND tr_id2 = %d"
           ,(int)self.pTrBuiId
           ,(int)self.pTrSyumokuId
           ,(int)self.pWeightUnit
           ,(int)self.pSetTotal
           ,(int)self.pKeyTrId
           ,(int)self.pKeyTrId2
           ];
    [db executeUpdate:sql];
}

-(void) doDelete :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"DELETE FROM d_tr_dt"
           "   WHERE tr_id  = %d"
           "     AND tr_id2 = %d"
           ,(int)self.pKeyTrId
           ,(int)self.pKeyTrId2
           ];
    [db executeUpdate:sql];
    
    sql = [NSString stringWithFormat
           :@"DELETE FROM d_tr_dt_set"
           "   WHERE tr_id  = %d"
           "     AND tr_id2 = %d"
           ,(int)self.pKeyTrId
           ,(int)self.pKeyTrId2
           ];
    [db executeUpdate:sql];
}

@end
