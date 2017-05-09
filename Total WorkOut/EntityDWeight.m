//
//  EntityDWeight.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/12.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "EntityDWeight.h"

@implementation EntityDWeight
// 初期化
- (id)init
{
    if (self = [super init])
    {
        [self initProperty];
    }
    return self;
}

- (id)initWithSelect :(DBConnector *)db :(NSString*)date
{
    if (self = [super init])
    {
        [self initProperty];
        self.pDate = date;
        
        //データ取得
        [self doSelect:db];
    }
    return self;
}

-(void) initProperty{
    self.isExists = false;
    self.pDate   = @"";
    self.pWeight = @"";
    self.pFat    = @"";
}

-(void) doSelect:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT "
           " date"
           ",weight"
           ",fat"
           "    FROM d_weight"
           "   WHERE date  = '%@'"
           ,self.pDate
           ];
    
    [db executeQuery:sql];
    
    while ([db.results next]) {
        self.isExists = true;
        self.pWeight = [db.results stringForColumn:@"weight"];
        self.pFat    = [db.results stringForColumn:@"fat"];
    }
}

-(void) doInsert:(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"INSERT INTO d_weight"
           "("
           " date"
           ",weight"
           ",fat"
           ")"
           " SELECT"
           "  '%@'"
           " ,'%@'"
           " ,'%@'"
           ,self.pDate
           ,self.pWeight
           ,self.pFat
           ];
    [db executeUpdate:sql];
}

-(void) doUpdate :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"UPDATE d_weight"
           "     SET weight = '%@'"
           "        ,fat    = '%@'"
           "   WHERE date = '%@'"
           ,self.pWeight
           ,self.pFat
           ,self.pDate
           ];
    [db executeUpdate:sql];
}

-(void) doDelete :(DBConnector *)db{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"DELETE FROM d_weight"
           "   WHERE date = '%@'"
           ,self.pDate
           ];
    [db executeUpdate:sql];
}

@end
