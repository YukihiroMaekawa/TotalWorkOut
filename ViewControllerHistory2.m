//
//  ViewControllerHistory2.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/06.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "Utility.h"
#import "ViewControllerHistory2.h"
#import "ViewControllerWorkOut.h"

@interface ViewControllerHistory2 ()

@end

@implementation ViewControllerHistory2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // デリゲート
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _trSettings = [[TrSettings alloc]init];
    
    [self createTableData];
}

// テーブルデータ作成
- (void) createTableData{
    _db = [[DBConnector alloc]init];
    
    //テーブルセクション
    _tableSection = [[NSMutableArray alloc] init];
    _tableKey     = [[NSMutableArray alloc] init];
    _tableVal     = [[NSMutableArray alloc] init];
    
    [_db dbOpen];

    [_db executeQuery:[self getTrData]];

    NSString *addStr = @"";
    int bkTrId1 = 0;
    int bkTrId2 = 0;
    int bkTrId3 = 0;
    int setSu   = 0;
    NSDate *date;
    NSString *dateStr;
    NSString *timeStr;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];

    NSString *weightName   = [_trSettings getUnitWeightName];
    NSString *distanceName = [_trSettings getUnitDistanceName];
    
    while ([_db.results next]) {
        if (
            bkTrId1 == 0
            || bkTrId1 != [_db.results intForColumn:@"tr_id"]
            || bkTrId2 == 0
            || bkTrId2 != [_db.results intForColumn:@"tr_id2"]
           )
        {
            //セクションとkeyを追加
            if (
                bkTrId1 == 0
                || bkTrId1 != [_db.results intForColumn:@"tr_id"]
                )
            {
                //各国言語にローカライズする
                df.dateFormat = @"yyyy/MM/dd";
                date = [df dateFromString:[_db.results stringForColumn:@"tr_date"]];
                [df setLocale:[NSLocale currentLocale]];
                [df setDateStyle:NSDateFormatterFullStyle];
                [df setTimeStyle:NSDateFormatterNoStyle];
                dateStr = [df stringFromDate:date];
            
                df.dateFormat = @"HH:mm";
                date = [df dateFromString:[_db.results stringForColumn:@"tr_time_st"]];
                [df setLocale:[NSLocale currentLocale]];
                [df setDateStyle:NSDateFormatterNoStyle];
                [df setTimeStyle:NSDateFormatterShortStyle];
                timeStr = [df stringFromDate:date];
                
                //セクション
                [_tableSection addObject:[NSString stringWithFormat:@"%@ %@\n%@"
                                          ,dateStr
                                          ,timeStr
                                          ,[_db.results stringForColumn:@"tr_syumoku_name"]
                                          ]];
            }else{
                //セクション
                [_tableSection addObject:[NSString stringWithFormat:@"%@"
                                          ,[_db.results stringForColumn:@"tr_syumoku_name"]
                                          ]];
            }
            
            [_tableKey     addObject:[NSNumber numberWithInt:
                                      [_db.results intForColumn:@"tr_id"]]];
            
            
            //初回は設定しない
            if (bkTrId1 > 0){
                [_tableVal addObject:addStr];
                addStr = @"";
            }

            if(_trSettings.defaultLanguage == 0){
                if([[_db.results stringForColumn:@"tr_kb"] isEqual:@"1"]){
                    addStr = [NSString stringWithFormat:@"%@Set,Weight,Reps,1RM, ,Memo\n" ,addStr];
                }else{
                    addStr = [NSString stringWithFormat:@"%@Set,Distance,Time,Cal, ,Memo\n" ,addStr];
                }
            }else{
                if([[_db.results stringForColumn:@"tr_kb"] isEqual:@"1"]){
                    addStr = [NSString stringWithFormat:@"%@セット,重さ,回数,1RM, ,メモ\n" ,addStr];
                }else{
                    addStr = [NSString stringWithFormat:@"%@セット,距離,時間,カロリー, ,メモ\n" ,addStr];
                }
            }
            setSu = 0;
        }

        setSu++;
        bkTrId1 = [_db.results intForColumn:@"tr_id"];
        bkTrId2 = [_db.results intForColumn:@"tr_id2"];
        bkTrId3 = [_db.results intForColumn:@"tr_id3"];
        
        if([[_db.results stringForColumn:@"tr_kb"] isEqual:@"1"]){
            //1RM
            NSString * rmData;
            rmData = [NSString stringWithFormat:@"%.2f" ,[Utility get1Rm
                                                          :[[_db.results stringForColumn:@"weight"] doubleValue]
                                                          :[[_db.results stringForColumn:@"reps"] intValue]
                                                          ]
                      ];
            if ([rmData isEqualToString:@"0.00"]){rmData = @"-";}
            
            if([[_db.results stringForColumn:@"weight"] isEqual:@"-"]){
                weightName = @"";
            }
            
            addStr = [NSString stringWithFormat:@"%@%d,%@%@,%@,%@,%@,%@\n"
                      ,addStr
                      ,setSu
                      ,[_db.results stringForColumn:@"weight"],weightName
                      ,[_db.results stringForColumn:@"reps"]
                      ,rmData
                      ,[_db.results stringForColumn:@"best_record"]
                      ,[_db.results stringForColumn:@"memo"]
                      ];
        }else{
            if([[_db.results stringForColumn:@"distance"] isEqual:@"-"]){
                distanceName = @"";
            }

            addStr = [NSString stringWithFormat:@"%@%d,%@%@,%@,%@,%@,%@\n"
                      ,addStr
                      ,setSu
                      ,[_db.results stringForColumn:@"distance"],distanceName
                      ,[_db.results stringForColumn:@"time"]
                      ,[_db.results stringForColumn:@"cal"]
                      ,[_db.results stringForColumn:@"best_record"]
                      ,[_db.results stringForColumn:@"memo"]
                      ];
        }
    }
    
    [_tableVal addObject:addStr];

    [_db dbClose];
}

- (NSString*)getTrData{
    NSString *sql;
    NSString *sqlWhere;
    NSString *sql2;

    sql = [NSString stringWithFormat
           :@"SELECT thd.tr_id"
           "        ,tdt.tr_id2"
           "        ,tse.tr_id3"
           "        ,thd.tr_date"
           "        ,thd.tr_time_st"
           "        ,IFNULL(tbi.tr_kb ,'1') AS tr_kb"
           "        ,IFNULL(tsm.tr_syumoku_name ,'-') AS tr_syumoku_name"
           "        ,tdt.weight_unit"
           "        ,IFNULL(tse.weight   ,'-') AS weight"
           "        ,IFNULL(tse.reps     ,'-') AS reps"
           "        ,IFNULL(tse.memo     ,'-') AS memo"
           "        ,IFNULL(tse.distance ,'-') AS distance"
           "        ,IFNULL(tse.time     ,'-') AS time"
           "        ,IFNULL(tse.cal      ,'-') AS cal"
           "        ,CASE WHEN tse.best_record = '1' THEN '☆' ELSE '' END AS best_record"
           "    FROM d_tr_hd AS thd"
           " LEFT JOIN d_tr_dt AS tdt"
           "      ON thd.tr_id = tdt.tr_id"
           " LEFT JOIN m_tr_bui AS tbi"
           "      ON tdt.tr_bui_id = tbi.tr_bui_id"
           " LEFT JOIN m_tr_syumoku AS tsm"
           "      ON tdt.tr_bui_id     = tsm.tr_bui_id"
           "     AND tdt.tr_syumoku_id = tsm.tr_syumoku_id"
           " LEFT JOIN d_tr_dt_set AS tse"
           "      ON tdt.tr_id  = tse.tr_id"
           "     AND tdt.tr_id2 = tse.tr_id2"
           ];

    switch (self.serchMode) {
        case 1:
            //月日付検索
            sqlWhere = [NSString stringWithFormat
                       :@" WHERE thd.tr_date_month = '%@'"
                       ,self.keyTrDateMonth
                       ];
            break;
        case 2:
            //TrHd検索
            sqlWhere = [NSString stringWithFormat
                       :@" WHERE thd.tr_id = %d"
                       ,(int)self.keyTrHd
                       ];
            break;
        case 3:
            //Search検索
            sqlWhere = [NSString stringWithFormat
                        :@" WHERE 1 = 1"
                        ];
            
            //トレーニング日による検索
            if(self.keyDateSt.length > 0){
                sqlWhere = [NSString stringWithFormat:@"%@"
                            " AND thd.tr_date >= '%@'"
                            ,sqlWhere
                            ,self.keyDateSt
                            ];

            }
            
            if(self.keyDateEd.length > 0){
                sqlWhere = [NSString stringWithFormat:@"%@"
                            " AND thd.tr_date <= '%@'"
                            ,sqlWhere
                            ,self.keyDateEd
                            ];
            }
            
            //部位IDによる検索
            if(self.keyBuiId > 0){
                sqlWhere = [NSString stringWithFormat:@"%@"
                            " AND tdt.tr_bui_id = %d"
                            ,sqlWhere
                            ,(int)self.keyBuiId
                            ];
            }
            //種目IDによる検索
            if(self.keySyumokuId){
                sqlWhere = [NSString stringWithFormat:@"%@"
                            " AND tdt.tr_syumoku_id = %d"
                            ,sqlWhere
                            ,(int)self.keySyumokuId
                            ];
            }
            break;
    }
    
    sql2 = [NSString stringWithFormat
           :@" ORDER BY thd.tr_date   DESC"
            "          ,thd.tr_time_st DESC"
            "          ,thd.tr_id      DESC"
            "          ,tdt.tr_id2"
            "          ,tse.tr_id3"
            ];
    
    sql = [NSString stringWithFormat:@"%@%@%@"
          ,sql
          ,sqlWhere
          ,sql2
          ];
    return sql;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 * テーブル全体のセクションの数を返す
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_tableSection count];
}

/**
 * 指定されたセクションのセクション名を返す
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_tableSection objectAtIndex:section];
}

/**
 * テーブルのセルの数を返す
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1; //    return [_tableKey count];
}

// セルの高さを返す. セルが生成される前に実行されるので独自に計算する必要がある
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * arrValue = [[_tableVal objectAtIndex:indexPath.section] componentsSeparatedByString:@"\n"];
    return [arrValue count] * 20.1;
}

// ヘッダーの高さ指定
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42;
}

// フッターの高さ指定
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

/**
 * 指定されたインデックスパスのセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    for (UIView *subview in [cell.contentView subviews]) {
        [subview removeFromSuperview];
    }

    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSArray * arrValue = [[_tableVal objectAtIndex:indexPath.section] componentsSeparatedByString:@"\n"];
    
    // セクションで取得する 1セクション1行のため
    UIFont *uiFont = [UIFont systemFontOfSize:12.0];

    int x         = 15;
    int y         = 5;
    int width     = 0;
    int height    = 14;//16
    int loopCnt   = 0;
    int idxRow    = 0;
    int idxCol    = 0;
    int alignment = 0;
    for (NSString *valueRow in arrValue){
        idxRow++;
        idxCol = 0;
        NSArray * arrValue2 = [valueRow componentsSeparatedByString:@","];
        for(NSString *valueRow in arrValue2){
            idxCol++;
            
            //種目名
            if([arrValue2 count] == 1){
                alignment = NSTextAlignmentLeft;
                x = 15; width = 300;
            //セット数情報
            }else{
                alignment = NSTextAlignmentCenter;

                //セット
                if(idxCol == 1){
                    x = 15; width = 40;
                //重量
                }else if (idxCol == 2){
                    x = 40; width = 50;
                //回数
                }else if (idxCol == 3){
                    x = 80; width = 30;
                //1RM
                }else if (idxCol == 4){
                    x = 110; width = 40;
                //Best
                }else if (idxCol == 5){
                    x = 140; width = 15;
                //Memo
                }else if (idxCol == 6){
                    alignment = NSTextAlignmentLeft;
                    x = 225; width = 40;
                }
            }
            UILabel *labelCell;
            labelCell = [[UILabel alloc] initWithFrame:CGRectMake(x
                                                                ,y + (loopCnt * height)
                                                                ,(x+width)
                                                                ,(y+height) + (loopCnt * height) )];
            labelCell.textAlignment = alignment;
            labelCell.backgroundColor = [UIColor clearColor];
            if(idxRow == 1){
                labelCell.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
            }else{
                labelCell.textColor = [UIColor blackColor];
            }
            [labelCell setFont:uiFont];
            labelCell.text = valueRow;
            [cell.contentView addSubview:labelCell];
            
            if(self.isEdit){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        loopCnt++;
    }
    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedKeyTrHd = [NSString stringWithFormat:@"%@"
                        ,[_tableKey objectAtIndex:indexPath.section]].intValue;
    
    if(self.isEdit){
        // セクションで取得する 1セクション1行のため
        [self performSegueWithIdentifier:@"trWorkOutSegue" sender:self];
    }
}

//画面遷移時に呼ばれるメソッド
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"trWorkOutSegue"]) {
        ViewControllerWorkOut * viewNext = [[ViewControllerWorkOut alloc] init];
        viewNext = segue.destinationViewController;
        viewNext.keyTrHd = _selectedKeyTrHd;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createTableData];
    [self.tableView reloadData];
}

@end
