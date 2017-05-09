//
//  Utility.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/07.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "Utility.h"
#import "DBConnector.h"

@implementation Utility
// 初期化
- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

+ (double) get1Rm :(double)weight :(NSInteger)reps{
    float keisu=0;
    switch (reps) {
        case 1:
            keisu = 100;
            break;
        case 2:
            keisu = 95;
            break;
        case 3:
            keisu = 93;
            break;
        case 4:
            keisu = 90;
            break;
        case 5:
            keisu = 87;
            break;
        case 6:
            keisu = 85;
            break;
        case 7:
            keisu = 83;
            break;
        case 8:
            keisu = 80;
            break;
        case 9:
            keisu = 77;
            break;
        case 10:
            keisu = 75;
            break;
        case 11:
            keisu = 72;
            break;
        case 12:
            keisu = 70;
            break;
        case 13:
            keisu = 69;
            break;
        case 14:
            keisu = 68;
            break;
        case 15:
            keisu = 67;
            break;
        case 16:
            keisu = 66;
            break;
        case 17:
            keisu = 65;
            break;
        case 18:
            keisu = 64;
            break;
        case 19:
            keisu = 62;
            break;
        case 20:
            keisu = 60;
            break;
        default:
            keisu = 0;
            break;
    }
//    NSString * aaa = [NSString stringWithFormat:@"%.2f" ,weight * 100 / keisu];
    
    if (keisu ==0){return 0;}
    return weight * 100 / keisu;
}

+ (NSArray *) getZenkaiTrDtKey :(NSInteger) keyTrId :(NSInteger) keyTrId2{
    NSString *sql;
    DBConnector *db;
    db = [[DBConnector alloc]init];
    
    [db dbOpen];
    
    sql = [NSString stringWithFormat
           :@"SELECT thd.tr_date"
           "        ,tdt.tr_bui_id"
           "        ,tdt.tr_syumoku_id"
           "    FROM d_tr_hd AS thd"
           " INNER JOIN d_tr_dt AS tdt"
           "      ON thd.tr_id = tdt.tr_id"
           "   WHERE tdt.tr_id  = %d"
           "     AND tdt.tr_id2 = %d"
           ,(int)keyTrId
           ,(int)keyTrId2
           ];
    
    [db executeQuery:sql];
    
    NSString *trDate;
    NSInteger trBuiId     = 0;
    NSInteger trSyumokuId = 0;

    while ([db.results next]) {
        trDate      = [db.results stringForColumn:@"tr_date"];
        trBuiId     = [db.results intForColumn:@"tr_bui_id"];
        trSyumokuId = [db.results intForColumn:@"tr_syumoku_id"];
    }

    [db dbClose];

    [db dbOpen];
    
    sql = [NSString stringWithFormat
           :@"SELECT tdt.tr_id"
           "        ,tdt.tr_id2"
           "    FROM d_tr_hd AS thd"
           " INNER JOIN d_tr_dt AS tdt"
           "      ON thd.tr_id = tdt.tr_id"
           "   WHERE thd.tr_date       < '%@'"
           "     AND tdt.tr_bui_id     = %d"
           "     AND tdt.tr_syumoku_id = %d"
           "   ORDER BY thd.tr_date DESC ,tdt.tr_id DESC ,tdt.tr_id2 DESC"
           ,trDate
           ,(int)trBuiId
           ,(int)trSyumokuId
           ];
    
    [db executeQuery:sql];
    
    NSInteger trId;
    NSInteger trId2;
    while ([db.results next]) {
        trId  = [db.results intForColumn:@"tr_id"];
        trId2 = [db.results intForColumn:@"tr_id2"];
        break;
    }
    
    [db dbClose];

    NSArray *retArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:(int)trId]
                         ,[NSNumber numberWithInt:(int)trId2] ,nil];
    
    return retArray;
    
}

// iPhone画面サイズ判定
+ (NSString *)screenSize{
    NSString *retValue;
    
    //スクリーンサイズの取得
    CGRect rect1 = [[UIScreen mainScreen] bounds];
    NSLog(@"rect1.size.width : %f , rect1.size.height : %f", rect1.size.width, rect1.size.height);
    
    if(rect1.size.width == 320 && rect1.size.height == 568){
        retValue = @"4Inch";
    }else if(rect1.size.width == 375 && rect1.size.height == 667){
        retValue = @"4.7Inch";
    }else if(rect1.size.width == 414 && rect1.size.height == 736){
        retValue = @"5.5Inch";
    }
    return retValue;
}

@end
