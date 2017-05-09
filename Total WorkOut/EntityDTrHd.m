//
//  EntityDTrHd.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/30.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "EntityDTrHd.h"
#import "DBConnector.h"

@implementation EntityDTrHd
// 初期化
- (id)init
{
    if (self = [super init])
    {
        [self initProperty];
    }
    return self;
}

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trId
{
    if (self = [super init])
    {
        [self initProperty];
        self.pKeyTrId     = trId;
        
        //データ取得
        [self doSelect:db];
    }
    return self;
}

-(void) initProperty{
    self.pKeyTrId     = 0;
    self.pTrDate      = @"";
    self.pTrTimeSt    = @"";
    self.pWeight      = @"";
    self.pFat         = @"";
    self.pMemo        = @"";
    self.pTrDateMonth = @"";
}

-(NSInteger) getNextKey:(DBConnector *)db
{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT IFNULL(MAX(tr_id) ,0) + 1 AS tr_id"
           "  FROM d_tr_hd"
           ];
    
    [db executeQuery:sql];
    
    NSInteger keyValue = 0;
    
    while ([db.results next]) {
        keyValue = [db.results intForColumn:@"tr_id"];
    }

    return (int) keyValue;
}

-(void) doSelect:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT "
           " tr_id"
           ",tr_date"
           ",tr_time_st"
           ",weight"
           ",fat"
           ",memo"
           ",tr_date_month"
           "    FROM d_tr_hd"
           "   WHERE tr_id = %d"
           ,(int)self.pKeyTrId
        ];
    
    [db executeQuery:sql];
    
    while ([db.results next]) {
        self.pTrDate      = [db.results stringForColumn:@"tr_date"];
        self.pTrTimeSt    = [db.results stringForColumn:@"tr_time_st"];
        self.pWeight      = [db.results stringForColumn:@"weight"];
        self.pFat         = [db.results stringForColumn:@"fat"];
        self.pMemo        = [db.results stringForColumn:@"memo"];
        self.pTrDateMonth = [db.results stringForColumn:@"tr_date_month"];
    }
}

-(void) doInsert:(DBConnector *)db{
    NSString *sql;
    
    if(self.pTrDate.length > 0){
        self.pTrDateMonth = [self.pTrDate substringWithRange:NSMakeRange(0, 7)];
    }
    
    sql = [NSString stringWithFormat
           :@"INSERT INTO d_tr_hd"
           "("
           " tr_id"
           ",tr_date"
           ",tr_time_st"
           ",weight"
           ",fat"
           ",memo"
           ",tr_date_month"
           ")"
           " SELECT"
           "  %d"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ",'%@'"
           ,(int)self.pKeyTrId
           ,self.pTrDate
           ,self.pTrTimeSt
           ,self.pWeight
           ,self.pFat
           ,self.pMemo
           ,self.pTrDateMonth
           ];
    [db executeUpdate:sql];
}

-(void) doUpdate :(DBConnector *)db{
    NSString *sql;
    
    if(self.pTrDate.length > 0){
        self.pTrDateMonth = [self.pTrDate substringWithRange:NSMakeRange(0, 7)];
    }

    sql = [NSString stringWithFormat
           :@"UPDATE d_tr_hd"
           "     SET tr_date       = '%@'"
           "        ,tr_time_st    = '%@'"
           "        ,weight        = '%@'"
           "        ,fat           = '%@'"
           "        ,memo          = '%@'"
           "        ,tr_date_month = '%@'"
           "   WHERE tr_id = %d"
           ,self.pTrDate
           ,self.pTrTimeSt
           ,self.pWeight
           ,self.pFat
           ,self.pMemo
           ,self.pTrDateMonth
           ,(int)self.pKeyTrId
           ];
    [db executeUpdate:sql];
}

-(void) doDelete :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"DELETE FROM d_tr_hd"
           "   WHERE tr_id  = %d"
           ,(int)self.pKeyTrId
           ];
    [db executeUpdate:sql];
    
    sql = [NSString stringWithFormat
           :@"DELETE FROM d_tr_dt"
           "   WHERE tr_id  = %d"
           ,(int)self.pKeyTrId
           ];
    [db executeUpdate:sql];

    sql = [NSString stringWithFormat
           :@"DELETE FROM d_tr_dt_set"
           "   WHERE tr_id  = %d"
           ,(int)self.pKeyTrId
           ];
    [db executeUpdate:sql];
}

@end
