//
//  EmTrBui.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "EntityMTrBui.h"
#import "DBConnector.h"

@implementation EntityMTrBui
// 初期化
- (id)init
{
    if (self = [super init])
    {
        [self initProperty];
    }
    return self;
}

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trBuiId
{
    if (self = [super init])
    {
        [self initProperty];
        self.pKeyTrBuiId  = trBuiId;
        
        //データ取得
        [self doSelect:db];
    }
    return self;
}

-(void) initProperty{
    self.pKeyTrBuiId = 0;
    self.pTrBuiName  = @"";
    self.pTrKb       = @"";
}

-(void) doSelect:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT "
           " tr_bui_id"
           ",tr_bui_name"
           ",tr_kb"
           "    FROM m_tr_bui"
           "   WHERE tr_bui_id  = %d"
           ,(int)self.pKeyTrBuiId
           ];
    
    [db executeQuery:sql];
    
    while ([db.results next]) {
        self.pTrBuiName = [db.results stringForColumn:@"tr_bui_name"];
        self.pTrKb      = [db.results stringForColumn:@"tr_kb"];
    }
}

-(void) doInsMTrBui:(DBConnector *)db{
    NSString *sql;
    //SELECT (SELECT MAX(tr_bui_id)+ 1 FROM m_tr_bui)
    sql = [NSString stringWithFormat
           :@"INSERT INTO m_tr_bui"
           "("
           " tr_bui_id"
           ",tr_bui_name"
           ",tr_kb"
           ")"
           " SELECT"
           "  %d"
           ",'%@'"
           ",'%@'"
           ,(int)self.pKeyTrBuiId
           ,self.pTrBuiName
           ,self.pTrKb
           ];
    [db executeUpdate:sql];
}
-(void) doUpdMTrBui{
    
}
-(void) doDelMTrBui{
    
}


@end
