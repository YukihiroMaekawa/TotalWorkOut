//
//  EntityMTrSyumoku.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "EntityMTrSyumoku.h"
#import "DBConnector.h"

@implementation EntityMTrSyumoku
// 初期化
- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trBuiId :(NSInteger)trSyumokuId
{
    if (self = [super init])
    {
        self.pKeyTrBuiId     = trBuiId;
        self.pKeyTrSyumokuId = trSyumokuId;
        //データ取得
        [self doSelect:db];
    }
    return self;
}

-(NSInteger) getKeyMTrSyumoku :(DBConnector *)db :(NSInteger)trBuiID
{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT MAX(tr_syumoku_id) + 1 AS tr_syumoku_id"
             "  FROM m_tr_syumoku"
             " WHERE tr_bui_id  = %d"
           ,(int)trBuiID
           ];
    
    [db executeQuery:sql];
    
    NSInteger keyValue =0;
    while ([db.results next]) {
        keyValue = [db.results intForColumn:@"tr_syumoku_id"];
    }
    if (keyValue <= 100){
        keyValue = 101;
    }
    
    return (int) keyValue;
}

-(void) doSelect :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT "
           " tr_bui_id"
           ",tr_syumoku_id"
           ",tr_syumoku_name"
           "    FROM m_tr_syumoku"
           "   WHERE tr_bui_id     = %d"
           "     AND tr_syumoku_id = %d"
           ,(int)self.pKeyTrBuiId
           ,(int)self.pKeyTrSyumokuId
           ];

    [db executeQuery:sql];
    
    while ([db.results next]) {
        self.pTrSyumokuName = [db.results stringForColumn:@"tr_syumoku_name"];
    }
}

-(void) doInsert :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"INSERT INTO m_tr_syumoku"
           "("
           " tr_bui_id"
           ",tr_syumoku_id"
           ",tr_syumoku_name"
           ")"
           " SELECT"
           "  %d"
           ", %d"
           ",'%@'"
           ,(int)self.pKeyTrBuiId
           ,(int)self.pKeyTrSyumokuId
           ,self.pTrSyumokuName
           ];
    
    [db executeUpdate:sql];
}

-(void) doUpdate :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"UPDATE m_tr_syumoku"
           "     SET tr_syumoku_name = '%@'"
           "   WHERE tr_bui_id     = %d"
           "     AND tr_syumoku_id = %d"
           ,self.pTrSyumokuName
           ,(int)self.pKeyTrBuiId
           ,(int)self.pKeyTrSyumokuId
           ];
    
    [db executeUpdate:sql];
}

-(void) doDelete :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"DELETE FROM m_tr_syumoku"
           "   WHERE tr_bui_id     = %d"
           "     AND tr_syumoku_id = %d"
           ,(int)self.pKeyTrBuiId
           ,(int)self.pKeyTrSyumokuId
           ];
    
    [db executeUpdate:sql];
}


@end
