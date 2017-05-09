//
//  ViewControllerHistory.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/04.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "DBConnector.h"
#import "ViewControllerHistory.h"
#import "ViewControllerHistory2.h"

@implementation ViewControllerHistory

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
    //セクション名
    NSArray *tableSectionEg = [[NSArray alloc]initWithObjects:@"WorkOut History" ,nil];
    NSArray *tableSectionJp = [[NSArray alloc]initWithObjects:@"ワークアウト履歴"   ,nil];
    if(_trSettings.defaultLanguage == 0){
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionEg];
    }else{
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionJp];
    }

    [_db dbOpen];
    
    [_db executeQuery:[self getTrData] ];
    
    NSString *strAdd;
    NSDate *date;;
    NSDateFormatter *df  = [[NSDateFormatter alloc]init];
    while ([_db.results next]) {
        
        df.dateFormat = @"yyyy/MM";
        date = [df dateFromString:[_db.results stringForColumn:@"tr_date_month"]];
    
        [df setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyyy/MM" options:0 locale:[NSLocale currentLocale]]];
        
        strAdd = [NSString stringWithFormat:@"%@   %3d"
                  ,[df stringFromDate:date]
                  ,[_db.results intForColumn:@"tr_cnt_month"]
                  ];
        
        [_tableKey  addObject:[_db.results stringForColumn:@"tr_date_month"]];
        [_tableVal  addObject:strAdd];
        [_tableVal2 addObject:[df stringFromDate:date]];

    }
    [_db dbClose];
}

- (NSString*)getTrData{
    NSString *sql;
    sql = [NSString stringWithFormat
           :@"SELECT tr_date_month"
           "        ,COUNT(*) AS tr_cnt_month"
           "  FROM d_tr_hd"
           " GROUP BY tr_date_month"
           " ORDER BY tr_date_month DESC"
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
    return [_tableKey count];
}

/**
 * 指定されたインデックスパスのセルを作成する
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // セルが作成されていないか?
    if (!cell) { // yes
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セルにテキストを設定
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.text = [_tableVal objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _keyTrDateMonth = [_tableKey  objectAtIndex:indexPath.row];
    _valTrDateMonth = [_tableVal2 objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"trHistory2Segue" sender:self];
}

//画面遷移時に呼ばれるメソッド
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"trHistory2Segue"]) {
        ViewControllerHistory2 * viewNext = [[ViewControllerHistory2 alloc] init];
        viewNext = segue.destinationViewController;
        viewNext.isEdit         = true;
        viewNext.serchMode      = 1; // 日付検索指定
        viewNext.keyTrDateMonth = _keyTrDateMonth;
        viewNext.titleString    = _valTrDateMonth;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createTableData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
