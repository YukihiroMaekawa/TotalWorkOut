//
//  EntityDTrDtSet.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/02.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "EntityDTrDtSet.h"
#import "DBConnector.h"

@implementation EntityDTrDtSet
// 初期化
- (id)init
{
    if (self = [super init])
    {
        [self initProperty];
    }
    return self;
}

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trId :(NSInteger)trId2 :(NSInteger)trId3
{
    if (self = [super init])
    {
        [self initProperty];
        self.pKeyTrId  = trId;
        self.pKeyTrId2 = trId2;
        self.pKeyTrId3 = trId3;
        
        //データ取得
        [self doSelect:db];
    }
    return self;
}

-(void) initProperty{
    self.pKeyTrId     = 0;
    self.pKeyTrId2    = 0;
    self.pKeyTrId3    = 0;
    self.pWeight      = @"";
    self.pReps        = @"";
    
    self.pDistance    = @"";
    self.pTime        = @"";
    self.pCal         = @"";
    
    self.pBestRecord  = @"";
    self.pMemo        = @"";
}

-(NSInteger) getNextKey:(DBConnector *)db :(NSInteger)trId :(NSInteger)trId2
{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT IFNULL(MAX(tr_id3) ,0) + 1 AS tr_id3"
           "  FROM d_tr_dt_set"
           " WHERE tr_id  = %d"
           "   AND tr_id2 = %d"
           ,(int)trId
           ,(int)trId2
           ];
    
    [db executeQuery:sql];
    
    NSInteger keyValue = 0;
    
    while ([db.results next]) {
        keyValue = [db.results intForColumn:@"tr_id3"];
    }
    
    return (int) keyValue;
}

-(void) doSelect:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT "
           " tr_id"
           ",tr_id2"
           ",tr_id3"
           ",weight"
           ",reps"
           ",distance"
           ",time"
           ",cal"
           ",best_record"
           ",memo"
           "    FROM d_tr_dt_set"
           "   WHERE tr_id  = %d"
           "     AND tr_id2 = %d"
           "     AND tr_id3 = %d"
           ,(int)self.pKeyTrId
           ,(int)self.pKeyTrId2
           ,(int)self.pKeyTrId3
           ];
    
    [db executeQuery:sql];
    
    while ([db.results next]) {
        self.pWeight     = [db.results stringForColumn:@"weight"];
        self.pReps       = [db.results stringForColumn:@"reps"];
        self.pDistance   = [db.results stringForColumn:@"distance"];
        self.pTime       = [db.results stringForColumn:@"time"];
        self.pCal        = [db.results stringForColumn:@"cal"];
        self.pBestRecord = [db.results stringForColumn:@"best_record"];
        self.pMemo       = [db.results stringForColumn:@"memo"];
    }
}

-(void) doInsert:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"INSERT INTO d_tr_dt_set"
           "("
           " tr_id"
           ",tr_id2"
           ",tr_id3"
           ",weight"
           ",reps"
           ",distance"
           ",time"
           ",cal"
           ",best_record"
           ",memo"
           ")"
           " SELECT"
           "  %d"
           ", %d"
           ", %d"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ,(int)self.pKeyTrId
           ,(int)self.pKeyTrId2
           ,(int)self.pKeyTrId3
           ,self.pWeight
           ,self.pReps
           ,self.pDistance
           ,self.pTime
           ,self.pCal
           ,self.pBestRecord
           ,self.pMemo
           ];
    [db executeUpdate:sql];
}

-(void) doUpdate :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"UPDATE d_tr_dt_set"
           "     SET weight      ='%@'"
           "        ,reps        ='%@'"
           "        ,distance    ='%@'"
           "        ,time        ='%@'"
           "        ,cal         ='%@'"
           "        ,best_record ='%@'"
           "        ,memo        ='%@'"
           "   WHERE tr_id  = %d"
           "     AND tr_id2 = %d"
           "     AND tr_id3 = %d"
           ,self.pWeight
           ,self.pReps
           ,self.pDistance
           ,self.pTime
           ,self.pCal
           ,self.pBestRecord
           ,self.pMemo
           ,(int)self.pKeyTrId
           ,(int)self.pKeyTrId2
           ,(int)self.pKeyTrId3
           ];
    [db executeUpdate:sql];
}

-(void) doDelete :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"DELETE FROM d_tr_dt_set"
           "   WHERE tr_id  = %d"
           "     AND tr_id2 = %d"
           "     AND tr_id3 = %d"
           ,(int)self.pKeyTrId
           ,(int)self.pKeyTrId2
           ,(int)self.pKeyTrId3
           ];
    [db executeUpdate:sql];
}

@end
