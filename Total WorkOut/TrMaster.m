//
//  TrMaster.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "TrSettings.h"
#import "TrMaster.h"
#import "DBConnector.h"
#import "EntityMTrBui.h"
#import "EntityMTrSyumoku.h"

@implementation TrMaster

// 初期化
- (id)init
{
    if (self = [super init])
    {
        _trSettings = [[TrSettings  alloc]init];
        _db         = [[DBConnector alloc]init];
    }
    return self;
}

- (void) resetAllData{
    //DB全削除→作成
    [self dbDrop];
    [self dbInit];
    
    //マスターデータ初期化
    [self masterDataInit];
    
}

//ウェイト
- (NSArray*) masterDataBui{
    
    NSArray *arrMstInitBui  = [NSArray arrayWithObjects:
                               @"Neck,首"
                               ,@"Trapezius,僧帽筋"
                               ,@"Chest,胸"
                               ,@"Latissimus dorsi,広背筋"
                               ,@"Deltoid,三角筋"
                               ,@"Biceps,二頭筋"
                               ,@"Triceps,三頭筋"
                               ,@"Forearm,前腕"
                               ,@"Legs,脚"
                               ,@"Lower back,腰"
                               ,@"Gluteus,尻"
                               ,@"Calves,脹脛"
                               ,@"Abs,腹筋", nil];
    return arrMstInitBui;
}

//カーディオ
- (NSArray*) masterDataBui2{
    
    NSArray *arrMstInitBui2  = [NSArray arrayWithObjects:
                               @"Cardio Exercises,有酸素運動"
                               ,nil];
    return arrMstInitBui2;
}

//カーディオ種目
- (NSArray*) masterDataSyumoku2{
    NSArray *arrMstInitSyumoku2 = [NSArray arrayWithObjects:
                                    [NSArray arrayWithObjects:
                                     @"Warking,ウォーキング"
                                    ,@"Running,ランニング"
                                     ,nil
                                     ]
                                  ,nil];
    return arrMstInitSyumoku2;
}

- (NSArray*) masterDataSyumoku{
    NSArray *arrMstInitSyumoku = [NSArray arrayWithObjects:
                                  [NSArray arrayWithObjects:
                                   @"Neck Flexion,ネックフレクション"
                                   ,@"Side Neck Flexion,サイドネックフレクション"
                                   ,@"Neck extension,ネックエクステンション"
                                   ,nil]
                                  ,[NSArray arrayWithObjects:
                                    @"Barbell Shrug,バーベルシュラッグ"
                                    ,@"Dumbbell Shrug,ダンベルシュラッグ"
                                    ,@"Upright Rowing,アップライトロウイング"
                                    ,nil]
                                  ,[NSArray arrayWithObjects:
                                    @"Barbell Bench Press,バーベルベンチプレス"
                                    ,@"Dumbbell Bench Press,ダンベルベンチプレス"
                                    ,@"Incline Barbell Bench Press,インクラインバーベルベンチプレス"
                                    ,@"Incline Dumbbell Bench Press,インクラインダンベルベンチプレス"
                                    ,@"Decline Barbell Bench Press,デクラインバーベルベンチプレス"
                                    ,@"Decline Dumbbell Bench Press,デクラインダンベルベンチプレス"
                                    ,@"Dumbbell fly,ダンベルフライ"
                                    ,@"Incline Dumbbell Fly,インクラインダンベルフライ"
                                    ,@"Decline Dumbbell Fly,デクラインダンベルフライ"
                                    ,@"Cable Crossover,ケーブルクロスオーバー"
                                    ,nil]
                                  ,[NSArray arrayWithObjects:@"Dead Lift,デッドリフト"
                                    ,@"Bent Over Row,ベントオーバーロー"
                                    ,@"Rat Pull Down,ラットプルダウン"
                                    ,@"Seated Row,シーテッドロー"
                                    ,@"Chinning,チンニング"
                                    ,@"One hand Dumbbell Row,ワンハンドダンベルロー"
                                    ,@"Two Arm Dumbbell Row,ツーアームダンベルロー"
                                    ,@"Straight Arm Rat Pull-Down,ストレートアームバープルダウン"
                                    ,nil]
                                  
                                  ,[NSArray arrayWithObjects:
                                    @"Front Raise,フロントレイズ"
                                    ,@"Lateral Raise,ラテラルレイズ"
                                    ,@"Barbell shoulder press,バーベルショルダープレス"
                                    ,@"Dumbbell Shoulder Press,ダンベルショルダープレス"
                                    ,@"Arnold Press,アーノルドプレス"
                                    ,@"Rear deltoid raise,リアデルトレイズ"
                                    ,nil]
                                  
                                  ,[NSArray arrayWithObjects:
                                    @"Barbell Curl,バーベルカール"
                                    ,@"Dumbbell Curl,ダンベルカール"
                                    ,@"Hammer Curl,ハンマーカール"
                                    ,@"Concentration Curl,コンセントレーションカール"
                                    ,@"Preacher Curl,プリチャーカール"
                                    ,@"Incline Curl,インクラインカール"
                                    ,nil]
                                  
                                  ,[NSArray arrayWithObjects:
                                    @"Press down,プレスダウン"
                                    ,@"Kick Back,キックバック"
                                    ,@"Close Grip Bench Press,クローズグリップベンチプレス"
                                    ,@"Dumbbell French Press,ダンベルフレンチプレス"
                                    ,@"Lying Triceps Extension,ライイングトライセプスエクステンション"
                                    ,nil]
                                  
                                  ,[NSArray arrayWithObjects:
                                    @"Wrist Curl,リストカール"
                                    ,@"Reverse Curl,リバースカール"
                                    ,nil]
                                  
                                  ,[NSArray arrayWithObjects:
                                    @"Squat,スクワット"
                                    ,@"Front Squat,フロントスクワット"
                                    ,@"Lunge,ランジ"
                                    ,@"Side Lunge,サイドランジ"
                                    ,@"Leg Extension,レッグエクステンション"
                                    ,@"Leg Curl,レッグカール"
                                    ,@"Leg Press,レッグプレス"
                                    ,@"Adduction,アダクション"
                                    ,@"Hack Squat,ハックスクワット"
                                    ,@"Stiff Legged Dead lift,スティフレッグドデッドリフト"
                                    ,nil]
                                  
                                  ,[NSArray arrayWithObjects:
                                    @"Back Extension,バックエクステンション"
                                    ,@"Good Morning,グッドモーニング"
                                    ,@"Hyper Extension,ハイパーエクステンション"
                                    ,@"High Pull,ハイプル"
                                    ,@"Power Clean,パワークリーン"
                                    ,nil]
                                  
                                  ,[NSArray arrayWithObjects:
                                    @"Step Up,ステップアップ"
                                    ,@"Hip Lift,ヒップリフト"
                                    ,@"Hip Extension,ヒップエクステンション"
                                    ,@"Abduction,アブダクション"
                                    ,@"Prawn Leg Raise,プローンレッグレイズ"
                                    ,nil]
                                  
                                  ,[NSArray arrayWithObjects:
                                    @"Calf Raise,カーフレイズ"
                                    ,@"Donkey Calf Raise,ドンキーカーフレイズ"
                                    ,@"Seated Calf Raise,シーテッドカーフレイズ"
                                    ,@"Dumbbell Calf Raise,ダンベルカーフレイズ"
                                    ,@"Smith Machine Calf Raise,スミスマシーンカーフレイズ"
                                    ,nil]
                                  
                                  
                                  ,[NSArray arrayWithObjects:
                                    @"Sit Up,シットアップ"
                                    ,@"Abdominal Crunch,アブドミナルクランチ"
                                    ,@"Cable Crunch,ケーブルクランチ"
                                    ,@"Oblique Crunch,オブリーククランチ"
                                    ,@"Reverse Crunch,リバースクランチ"
                                    ,@"Leg Raise,レッグレイズ"
                                    ,@"Reverse Crunch,リバースクランチ"
                                    ,@"Knee Raise,ニーレイズ"
                                    ,@"Side Bend,サイドベント"
                                    ,nil]
                                  ,nil];

    return arrMstInitSyumoku;
}

- (void) masterDataInit{
    //ウェイト
    NSMutableArray *arrMstInitBui     = [[NSMutableArray alloc] init];
    NSMutableArray *arrMstInitSyumoku = [[NSMutableArray alloc] init];
    arrMstInitBui     = (NSMutableArray *)[NSArray arrayWithArray:[self masterDataBui]];
    arrMstInitSyumoku = (NSMutableArray *)[NSArray arrayWithArray:[self masterDataSyumoku]];

    //有酸素
    NSMutableArray *arrMstInitBui2     = [[NSMutableArray alloc] init];
    NSMutableArray *arrMstInitSyumoku2 = [[NSMutableArray alloc] init];
    arrMstInitBui2     = (NSMutableArray *)[NSArray arrayWithArray:[self masterDataBui2]];
    arrMstInitSyumoku2 = (NSMutableArray *)[NSArray arrayWithArray:[self masterDataSyumoku2]];

    //初期データ更新
    NSInteger dataCnt =0;
    NSInteger dataCnt2=0;
    
    EntityMTrBui     *entityMTrMbui     = [[EntityMTrBui alloc]init];
    EntityMTrSyumoku *entityMTrMsyumoku = [[EntityMTrSyumoku alloc]init];
    
    [_trSettings loadLanguage];

    [_db dbOpen];
    NSString *sql;
    
    sql = @"DELETE FROM m_tr_bui     WHERE tr_bui_id <= 100";
    [_db executeUpdate:sql];
    sql = @"DELETE FROM m_tr_syumoku WHERE tr_syumoku_id <= 100";
    [_db executeUpdate:sql];

    //ウェイト種目の設定(trKb = 1)
    for (NSString *mstInitBui in arrMstInitBui) {
        dataCnt2 = 0;
        
        NSArray* values = [mstInitBui componentsSeparatedByString:@","];
        //部位マスタ登録
        entityMTrMbui.pKeyTrBuiId = dataCnt + 1;
        entityMTrMbui.pTrBuiName  = values[_trSettings.defaultLanguage];
        entityMTrMbui.pTrKb       = @"1";
        [entityMTrMbui doInsMTrBui:_db];
        
        for (NSString *mstInitSyumoku in arrMstInitSyumoku[dataCnt]) {
            NSArray* values2 = [mstInitSyumoku componentsSeparatedByString:@","];
            entityMTrMsyumoku.pKeyTrBuiId     = dataCnt  + 1;
            entityMTrMsyumoku.pKeyTrSyumokuId = dataCnt2 + 1;
            entityMTrMsyumoku.pTrSyumokuName  = values2[_trSettings.defaultLanguage];
            [entityMTrMsyumoku doInsert:_db];
            dataCnt2++;
        }
        dataCnt++;
    }
    
    //有酸素種目の設定(trKb = 2)
    for (NSString *mstInitBui2 in arrMstInitBui2) {
        dataCnt2 = 0;
        
        NSArray* values = [mstInitBui2 componentsSeparatedByString:@","];
        //部位マスタ登録
        entityMTrMbui.pKeyTrBuiId = dataCnt + 1;
        entityMTrMbui.pTrBuiName  = values[_trSettings.defaultLanguage];
        entityMTrMbui.pTrKb       = @"2";
        [entityMTrMbui doInsMTrBui:_db];
        
        for (NSString *mstInitSyumoku2 in arrMstInitSyumoku2[dataCnt2]) {
            NSArray* values2 = [mstInitSyumoku2 componentsSeparatedByString:@","];
            entityMTrMsyumoku.pKeyTrBuiId     = dataCnt  + 1;
            entityMTrMsyumoku.pKeyTrSyumokuId = dataCnt2 + 1;
            entityMTrMsyumoku.pTrSyumokuName  = values2[_trSettings.defaultLanguage];
            [entityMTrMsyumoku doInsert:_db];
            dataCnt2++;
        }
        dataCnt++;
    }

    [_db dbClose];
}

- (void) dbDrop{
    NSString *sql;
    
    [_db dbOpen];
    
    // テーブル削除
   // sql = @"DROP TABLE IF EXISTS d_weight";        [_db executeUpdate:sql];
    sql = @"DROP TABLE IF EXISTS m_tr_bui";        [_db executeUpdate:sql];
    sql = @"DROP TABLE IF EXISTS m_tr_syumoku";    [_db executeUpdate:sql];
    sql = @"DROP TABLE IF EXISTS m_tr_routine_hd"; [_db executeUpdate:sql];
    sql = @"DROP TABLE IF EXISTS m_tr_routine_dt"; [_db executeUpdate:sql];
    sql = @"DROP TABLE IF EXISTS d_tr_hd";         [_db executeUpdate:sql];
    sql = @"DROP TABLE IF EXISTS d_tr_dt";         [_db executeUpdate:sql];
    sql = @"DROP TABLE IF EXISTS d_tr_dt_set";     [_db executeUpdate:sql];

    [_db dbClose];

}

- (void) dbInit{
    NSString *sql;
    
    [_db dbOpen];

    // 体重マスター(未使用)
    /*
    sql = @"CREATE TABLE IF NOT EXISTS d_weight"
    "(date          TEXT"
    ",weight        TEXT"
    ",fat           TEXT"
    ",PRIMARY KEY(date)"
    ")";
    [_db executeUpdate:sql];
*/
    
    // 部位マスタ
    sql = @"CREATE TABLE IF NOT EXISTS m_tr_bui"
    "(tr_bui_id     INTEGER"
    ",tr_bui_name   TEXT"
    ",tr_kb         TEXT"
    ",PRIMARY KEY(tr_bui_id)"
    ")";
    [_db executeUpdate:sql];
    
    // 種目マスタ
    sql = @"CREATE TABLE IF NOT EXISTS m_tr_syumoku"
    "("
    " tr_bui_id         INTEGER"
    ",tr_syumoku_id     INTEGER"
    ",tr_syumoku_name   TEXT"
    ",PRIMARY KEY(tr_bui_id ,tr_syumoku_id)"
    ")";
    [_db executeUpdate:sql];

    // ルーチンマスタ
    sql = @"CREATE TABLE IF NOT EXISTS m_tr_routine_hd"
    "("
    " tr_routine_id     INTEGER"
    ",tr_routine_name   TEXT"
    ",PRIMARY KEY(tr_routine_id)"
    ")";
    [_db executeUpdate:sql];

    // ルーチン詳細マスタ
    sql = @"CREATE TABLE IF NOT EXISTS m_tr_routine_dt"
    "("
    " tr_routine_id     INTEGER"
    ",tr_routine_id2    INTEGER"
    ",tr_bui_id         INTEGER"
    ",tr_syumoku_id     INTEGER"
    ",PRIMARY KEY(tr_routine_id ,tr_routine_id2)"
    ")";
    [_db executeUpdate:sql];

    // トレーニングHD
    sql = @"CREATE TABLE IF NOT EXISTS d_tr_hd"
    "("
    " tr_id             INTEGER"
    ",tr_date           TEXT"
    ",tr_time_st        TEXT"
    ",weight            TEXT"
    ",fat               TEXT"
    ",memo              TEXT"
    ",tr_date_month     TEXT"
    ",PRIMARY KEY(tr_id)"
    ")";
    [_db executeUpdate:sql];

    sql = @"CREATE INDEX IF NOT EXISTS IDX_01 ON d_tr_hd(tr_date)";
    [_db executeUpdate:sql];
    sql = @"CREATE INDEX IF NOT EXISTS IDX_02 ON d_tr_hd(tr_date_month)";
    [_db executeUpdate:sql];
    
    // トレーニングDT
    sql = @"CREATE TABLE IF NOT EXISTS d_tr_dt"
    "("
    " tr_id             INTEGER"
    ",tr_id2            INTEGER"
    ",tr_bui_id         INTEGER"
    ",tr_syumoku_id     INTEGER"
    ",weight_unit       INTEGER"
    ",set_total         INTEGER"
    ",PRIMARY KEY(tr_id ,tr_id2)"
    ")";
    [_db executeUpdate:sql];
    
    
    // トレーニングDtSet
    sql = @"CREATE TABLE IF NOT EXISTS d_tr_dt_set"
    "("
    " tr_id             INTEGER"
    ",tr_id2            INTEGER"
    ",tr_id3            INTEGER"
    ",weight            TEXT"
    ",reps              TEXT"
    ",distance          TEXT"
    ",time              TEXT"
    ",cal               TEXT"
    ",best_record       TEXT"
    ",memo              TEXT"
    ",PRIMARY KEY(tr_id ,tr_id2 ,tr_id3)"
    ")";
    [_db executeUpdate:sql];
    [_db dbClose];
}
@end
