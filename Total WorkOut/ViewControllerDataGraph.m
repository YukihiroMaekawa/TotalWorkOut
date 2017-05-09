//
//  ViewControllerData2.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/05/08.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerDataGraph.h"
#import "ViewGraphLine.h"
#import "Utility.h"

@interface ViewControllerDataGraph ()

@end

@implementation ViewControllerDataGraph

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
    
    // UIActivityIndicatorViewのインスタンス化
    CGRect rect = CGRectMake(0, 0, 100, 100);
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:rect];
    
    // 位置を指定
    _indicator.center = self.view.center;
    
    // アクティビティインジケータのスタイルをセット
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    _indicator.hidesWhenStopped = YES;
    
    // UIActivityIndicatorViewのインスタンスをビューに追加
    [self.view addSubview:_indicator];
    

    // デリゲート
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _trSettings = [[TrSettings alloc]init];
    _db = [[DBConnector alloc]init];

    if(_trSettings.defaultLanguage == 0){
        [self.segmentedControl setTitle:@"Day"   forSegmentAtIndex:0];
        [self.segmentedControl setTitle:@"Month" forSegmentAtIndex:1];
        [self.segmentedControl setTitle:@"Year"  forSegmentAtIndex:2];
    }else{
        [self.segmentedControl setTitle:@"日"   forSegmentAtIndex:0];
        [self.segmentedControl setTitle:@"月" forSegmentAtIndex:1];
        [self.segmentedControl setTitle:@"年"  forSegmentAtIndex:2];
    }
    
    self.segmentedControl.selectedSegmentIndex = 0;
    _selectedSegment = 0;
    
    [self createTableData];
    
}

// テーブルデータ作成
- (void) createTableData{
    // メインスレッド用で処理を実行するキューを定義するする
    _main_queue = dispatch_get_main_queue();
    // サブスレッドで実行するキューを定義する
    _sub_queue = dispatch_queue_create("tableLoad", 0);

    [_indicator startAnimating];
    
    // サブキュー実行
    dispatch_async(_sub_queue, ^{
        
        //テーブルセクション
        _tableSection   = [[NSMutableArray alloc] init];
        _tableKey       = [[NSMutableArray alloc] init];
        _tableLabelVal  = [[NSMutableArray alloc] init];
        _tableDataXVal  = [[NSMutableArray alloc] init];
        _tableDataYVal  = [[NSMutableArray alloc] init];
        _tableGraphData = [[NSMutableArray alloc] init]; // 平均値
        [_db dbOpen];
        [_db executeQuery:[self getTrData]];
        
        NSString *labelVal = @"";
        NSString *dataXVal = @"";
        NSString *dataYVal = @"";
        
        int rowCnt   = 0;
        NSDate *date;
        NSDate *dateCurrent;
        NSDate *dateTr;
        NSInteger bkTrBuiId     = 0;
        NSInteger bkTrSyumokuId = 0;
        NSString *trSyumokuName = @"";
        NSString *weight        = @"";
        BOOL isResults     = NO;
        BOOL isNextRec     = YES;
        BOOL isBreak       = NO;
        BOOL isBreak2      = NO;

        
        NSDateFormatter *df  = [[NSDateFormatter alloc]init]; //変換用
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger flags;
        NSDateComponents *comps;
        
        //グラフデータの開始日と終了日は検索でヒットした最小日付と最大日付とする
        while (YES){
            if(_isCancelQue){
                break;
            }
            
            //日付ベースで集計するため制御(初回はYESなので実施)
            if(isNextRec){
                isResults = [_db.results next];
            }
            
            //ブレイク判定 初回以外で種目変更またはリザルトがなし(月の場合は月末まで集計、年の場合は年末まで集計させる)
            /*
            NSLog(@"bkTrBuiId:%d --- rs:%d"     ,(int)bkTrBuiId ,[_db.results intForColumn:@"tr_bui_id"]);
            NSLog(@"bkTrSyumokuId-%d --- rs:%d" ,(int)bkTrSyumokuId ,[_db.results intForColumn:@"tr_syumoku_id"]);
            */
            
            //ブレイク判定
            if(
               (
                rowCnt > 0
                && (
                    (bkTrBuiId     > 0  && bkTrBuiId != [_db.results intForColumn:@"tr_bui_id"])
                    || (bkTrSyumokuId > 0 && bkTrSyumokuId != [_db.results intForColumn:@"tr_syumoku_id"])
                    || (!isResults)
                    )
                )
               ){
                isBreak2 = YES;
            }
            
            if(isBreak2){
                //月末か年末か判定する、月末、年末までは集計する必要があるため
                comps = [[NSDateComponents alloc] init];
                [comps setDay:1];
                flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
                comps = [calendar components:flags fromDate:[calendar dateByAddingComponents:comps toDate:dateCurrent options:0]
                         ];
                NSInteger month = comps.month;
                NSInteger day   = comps.day;
                
                if(_selectedSegment == 0){
                    isBreak = YES;
                }else if(_selectedSegment == 1){
                    //月が変わったらブレイク = 1日かどうか
                    if(day == 1){isBreak = YES;}
                }else if(_selectedSegment == 2){
                    //年賀変わったらブレイク = 1月1日かどうか
                    if(month == 1 && day == 1){
                        isBreak = YES;
                    }
                }
            }
            
            //ブレイク判定された場合
            if(isBreak){
                //セクション登録
                [_tableSection addObject:trSyumokuName];
                
                //先頭のカンマをとる
                labelVal = [labelVal substringFromIndex:1];
                dataYVal = [dataYVal substringFromIndex:1];
                
                //後ろからピックアップする
                NSMutableArray * labelArr = (NSMutableArray *)[labelVal componentsSeparatedByString:@","];
                NSMutableArray * dataYArr = (NSMutableArray *)[dataYVal componentsSeparatedByString:@","];
                
                labelVal = @"";
                dataYVal = @"";
                int breakCnt = 0;
                int sumWeight = 0;
                int avarageWeight = 0;
                rowCnt = 0;
                //ラベルの重複はのぞく
                NSString *newLabel = @"";
                NSString *labelDate;
                NSString *bkLabelDate;
                
                for (int i = (int)[labelArr count] ; i > 0; i--) {
                    //日付フォーマットを変換
                    labelDate = [labelArr objectAtIndex:i-1];
                    df.dateFormat = @"yyyy/MM/dd";
                    date = [df dateFromString:labelDate];
                    
                    flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
                    comps = [calendar components:flags fromDate:date];
                    NSInteger month = comps.month;
                    NSInteger day = comps.day;
                    BOOL isFirstDay = NO;
                    
                    NSString * dateFormat;   // 変換用
                    if(_selectedSegment == 0){
                        breakCnt ++;
                        isFirstDay = YES;
                        dateFormat  = @"MM/dd";
                    }else if(_selectedSegment == 1){
                        dateFormat  = @"MMM";
                        //月初のみ見出しを表示
                        if(day == 1 && ![bkLabelDate isEqualToString:labelDate]){
                            breakCnt++;
                            isFirstDay = YES;
                        }
                    }else if(_selectedSegment == 2){
                        dateFormat  = @"yyyy";
                        //1月1日のみ見出しを表示
                        if(month == 1 && day == 1 && ![bkLabelDate isEqualToString:labelDate]){
                            breakCnt++;
                            isFirstDay = YES;
                        }
                    }
                    bkLabelDate = labelDate;
                    
                    [df setDateFormat:[NSDateFormatter dateFormatFromTemplate:dateFormat
                                                                      options:0 locale:[NSLocale currentLocale]]];
                    
                    sumWeight += [[dataYArr objectAtIndex:i-1] intValue];
                    
                    newLabel = @"";
                    if(isFirstDay){
                        newLabel = [df stringFromDate:date];
                    }
                    //前に追加
                    labelVal = [NSString stringWithFormat:@"%@,%@" ,newLabel,labelVal];
                    //後ろに追加(0から連番)
                    dataXVal = [NSString stringWithFormat:@"%@,%d" ,dataXVal ,rowCnt];
                    //前に追加
                    dataYVal = [NSString stringWithFormat:@"%@,%@" ,[dataYArr objectAtIndex:i-1] ,dataYVal];
                    
                    rowCnt++;
                    
                    //処理終了条件
                    if(_selectedSegment == 0 && breakCnt == 8){break;} //8回
                    if(_selectedSegment == 1 && breakCnt == 6){break;} //6ヶ月
                    if(_selectedSegment == 2 && breakCnt == 5){break;} //5年
                }
                avarageWeight = sumWeight / rowCnt;
                
                labelVal = [labelVal substringToIndex:[labelVal length] - 1];
                dataXVal = [dataXVal substringFromIndex:1];
                dataYVal = [dataYVal substringToIndex:[dataYVal length] - 1];
                
                [_tableKey addObject:labelVal];
                [_tableLabelVal addObject:labelVal];
                [_tableDataXVal addObject:dataXVal];
                [_tableDataYVal addObject:dataYVal];
                [_tableGraphData addObject:[NSString stringWithFormat:@"%d" ,avarageWeight]];
                
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

                //初期化
                rowCnt   = 0;
                labelVal = @"";
                dataXVal = @"";
                dataYVal = @"";
                isBreak  = NO;
                isBreak2 = NO;
            }

            //リザルトなしは終了(初回または初回以外は日付が変わったら)
            if(!isResults && rowCnt == 0){break;}
            if(!isResults && isBreak){break;}
            
            df.dateFormat = @"yyyy/MM/dd";
            dateTr = [df dateFromString:[_db.results stringForColumn:@"tr_date"]];
            
            //初回の処理
            if(rowCnt == 0){
                weight = [_db.results stringForColumn:@"weight"];
                
                //年の場合はその年の１月１日から、月の場合はその月の１日を設定すること
                flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
                comps = [calendar components:flags fromDate:dateTr];
                NSInteger year  = comps.year;
                NSInteger month = comps.month;
                
                //初回日付を格納(月は１日、年は１月１日とする)
                NSString *dateStr;
                if(_selectedSegment == 0){
                    dateCurrent = dateTr;
                }else if(_selectedSegment == 1){
                    dateStr = [NSString stringWithFormat:@"%ld/%02ld/%@" ,(long)year,(long)month,@"01"];
                    dateCurrent = [df dateFromString:dateStr];
                }else if(_selectedSegment == 2){
                    dateStr = [NSString stringWithFormat:@"%ld/%@/%@" ,(long)year,@"01",@"01"];
                    dateCurrent = [df dateFromString:dateStr];
                }
                
            //初回以外
            }else{
                //日単は直近データのみ登録する
                if(_selectedSegment == 0){
                    dateCurrent = [df dateFromString:[_db.results stringForColumn:@"tr_date"]];
                }else{
                    if(isBreak2
                    || [dateCurrent compare:dateTr] == NSOrderedAscending
                       ){
                        comps = [[NSDateComponents alloc] init];
                        [comps setDay:1];
                        dateCurrent = [calendar dateByAddingComponents:comps toDate:dateCurrent options:0];
//                        NSLog(@"%@" ,dateCurrent);
                    }else{
//                        NSLog(@"a");
                    }
                }
            }
            
            // カレント日付がTR日付と一致の場合
            if(
                 isBreak2 == NO
               &&
                  (
                    (
                      [dateCurrent compare:dateTr] == NSOrderedSame && dateTr != nil)
                  || _selectedSegment == 0
                    )
               ){
                isNextRec = YES;
            }else{
                isNextRec = NO;
            }
            
            if(isResults){
                bkTrBuiId     = [_db.results intForColumn:@"tr_bui_id"];
                bkTrSyumokuId = [_db.results intForColumn:@"tr_syumoku_id"];
                
                //ブレイクしている場合は次の種目になっているため設定しない
                if(!isBreak2 && [dateCurrent compare:dateTr] == NSOrderedSame){
                    trSyumokuName = [_db.results stringForColumn:@"tr_syumoku_name"];
                    weight        = [_db.results stringForColumn:@"weight"];
                }
            }

            //日付の見出し
            labelVal = [NSString stringWithFormat:@"%@,%@" ,labelVal,[df stringFromDate:dateCurrent]];
            //Weightのベストレコード
            dataYVal = [NSString stringWithFormat:@"%@,%@" ,dataYVal,weight];
            
            rowCnt ++;
        }
        [_db dbClose];
        
        //インジケータ消す
        [self performSelectorOnMainThread:@selector(stopIndicator) withObject:nil waitUntilDone:NO];
//        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
        // メインキュー実行
        dispatch_async(_main_queue, ^ {
            // くるくるを表示
//            [_indicator startAnimating];
        });
    });
    
}

- (void) stopIndicator{
        [_indicator stopAnimating];
}

- (NSString*)getTrData{
    NSString *sql      = @"";
    NSString *sqlWhere = @"";
    NSString *sql2     = @"";
    
    sql = [NSString stringWithFormat
           :@"SELECT tdt.tr_bui_id"
           "        ,tdt.tr_syumoku_id"
           "        ,thd.tr_date"
           "        ,IFNULL(tsm.tr_syumoku_name ,'-') AS tr_syumoku_name"
           "        ,tse.weight"
           "    FROM d_tr_hd AS thd"
           " INNER JOIN d_tr_dt AS tdt"
           "      ON thd.tr_id = tdt.tr_id"
           " INNER JOIN m_tr_bui AS tbi"
           "      ON tdt.tr_bui_id = tbi.tr_bui_id"
           " INNER JOIN m_tr_syumoku AS tsm"
           "      ON tdt.tr_bui_id     = tsm.tr_bui_id"
           "     AND tdt.tr_syumoku_id = tsm.tr_syumoku_id"
           " INNER JOIN d_tr_dt_set AS tse"
           "      ON tdt.tr_id  = tse.tr_id"
           "     AND tdt.tr_id2 = tse.tr_id2"
           "   WHERE tse.best_record = '1'"
           "     AND IFNULL(tbi.tr_kb ,'1') = '1'"
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

    if (self.keyBuiId > 0){
        sqlWhere = [NSString stringWithFormat
                    :@" AND tdt.tr_bui_id = %d"
                    ,(int)self.keyBuiId
                    ];
    }
    
    if (self.keySyumokuId > 0){
        sqlWhere = [NSString stringWithFormat:@"%@"
                    " AND tdt.tr_syumoku_id = %d"
                    ,sqlWhere
                    ,(int)self.keySyumokuId
                    ];
    }
    
    sql2 = [NSString stringWithFormat
            :@" ORDER BY tdt.tr_bui_id"
            "           ,tdt.tr_syumoku_id"
            "           ,thd.tr_date"
            "           ,thd.tr_time_st"
            "           ,thd.tr_id"
            "           ,tdt.tr_id2"
            "           ,tse.tr_id3"
            ];

    sql = [NSString stringWithFormat:@"%@%@%@"
           ,sql
           ,sqlWhere
           ,sql2
           ];
    return sql;
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
    // 1セクション1セル
    return 1;
}

// セルの高さを返す. セルが生成される前に実行されるので独自に計算する必要がある
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 430;
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
    
    NSString * screenSize = [Utility screenSize];
    int viewWidth; int viewHeight;
    if([screenSize isEqual:@"4.7Inch"]){
        viewWidth = 375; viewHeight = 420;
    }else if([screenSize isEqual:@"5.5Inch"]){
        viewWidth = 414; viewHeight = 420;
    }else{
        viewWidth = 320; viewHeight = 420;
    }

    // スクロールビュー例文
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth ,viewHeight)];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = YES;
    [scrollView setDelegate:self];
    [scrollView setShowsVerticalScrollIndicator:YES];
    [scrollView setShowsHorizontalScrollIndicator:YES];
    
    // VIEW
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth ,viewHeight)];
    
    NSString * labelValue = [_tableLabelVal objectAtIndex:indexPath.section];
    NSString * xDataValue = [_tableDataXVal objectAtIndex:indexPath.section];
    NSString * yDataValue = [_tableDataYVal objectAtIndex:indexPath.section];
    
    //要素数２以上ないとグラフが生成されないため、カンマが無い場合は付加する
    //２要素目は１要素目と同一の値を設定し直線グラフを生成する
    if([labelValue rangeOfString:@","].location == NSNotFound){
        labelValue = [NSString stringWithFormat:@"%@," ,labelValue];
    }
    if([xDataValue rangeOfString:@","].location == NSNotFound){
        xDataValue = [NSString stringWithFormat:@"%@,1" ,xDataValue];
    }
    if([yDataValue rangeOfString:@","].location == NSNotFound){
        yDataValue = [NSString stringWithFormat:@"%@,%@" ,yDataValue,yDataValue];
    }

    NSArray * labelArr = [labelValue componentsSeparatedByString:@","];
    NSArray * xDataArr = [xDataValue componentsSeparatedByString:@","];
    NSArray * yDataArr = [yDataValue componentsSeparatedByString:@","];
    
//    ViewGraphLine *graph = [[ViewGraphLine alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    ViewGraphLine *graph = [[ViewGraphLine alloc] initWithFrame:CGRectMake(0, 0, viewWidth,viewHeight)];
    
    graph.viewX = 0;
    graph.viewY = 0;
    graph.viewWidth = viewWidth;
    graph.viewHeight = viewHeight;
    
    graph.xTitle = @"";
    graph.yTitle = [_trSettings getUnitWeightName]; // Lbs Kg
    
    graph.xLabelArr = labelArr;
    graph.xDataArr  = xDataArr;
    graph.yDataArr  = yDataArr;
    
    int avarageWeight = [[_tableGraphData objectAtIndex:indexPath.section] intValue];

    //kg
    if(_trSettings.unitWeight == 0){
        if     (avarageWeight <=  60){graph.yMin =   0; graph.yLength =  80; graph.yIntervalLength =  20.0f;}
        else if(avarageWeight <= 100){graph.yMin =  40; graph.yLength =  80; graph.yIntervalLength =  20.0f;}
        
        else if(avarageWeight <= 140){graph.yMin =  60; graph.yLength = 100; graph.yIntervalLength =  20.0f;}
        else if(avarageWeight <= 200){graph.yMin = 120; graph.yLength = 100; graph.yIntervalLength =  20.0f;}
        
        else if(avarageWeight <= 300){graph.yMin = 160; graph.yLength = 160; graph.yIntervalLength =  40.0f;}
        else                         {graph.yMin = 200; graph.yLength = 300; graph.yIntervalLength =  50.0f;}
    }else{
        if     (avarageWeight <= 120){graph.yMin =   0; graph.yLength = 160; graph.yIntervalLength =  40.0f;}
        else if(avarageWeight <= 200){graph.yMin =  80; graph.yLength = 160; graph.yIntervalLength =  40.0f;}
        
        else if(avarageWeight <= 280){graph.yMin = 160; graph.yLength = 200; graph.yIntervalLength =  40.0f;}
        else if(avarageWeight <= 420){graph.yMin = 250; graph.yLength = 250; graph.yIntervalLength =  50.0f;}
        
        else if(avarageWeight <= 550){graph.yMin = 350; graph.yLength = 250; graph.yIntervalLength = 50.0f;}
        else                         {graph.yMin = 400; graph.yLength = 500; graph.yIntervalLength = 100.0f;}
    }
    
    [graph createGraphLine];
    [cellView addSubview:graph];

    [scrollView addSubview:cellView];
    scrollView.contentSize = cellView.bounds.size;
    [cell.contentView addSubview:scrollView];

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)segmentChenged:(id)sender {
    _isCancelQue = YES;
    
    [NSThread sleepForTimeInterval:0.2];

    _selectedSegment = [sender selectedSegmentIndex];
    
    _tableSection   = [[NSMutableArray alloc] init];
    _tableKey       = [[NSMutableArray alloc] init];
    _tableLabelVal  = [[NSMutableArray alloc] init];
    _tableDataXVal  = [[NSMutableArray alloc] init];
    _tableDataYVal  = [[NSMutableArray alloc] init];
    _tableGraphData = [[NSMutableArray alloc] init]; // 平均値
    [self.tableView reloadData];

    _isCancelQue = NO;
    [self createTableData];
//    [self.tableView reloadData];
}
@end
