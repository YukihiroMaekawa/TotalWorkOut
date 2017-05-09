//
//  ViewControllerExercises.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerExercises.h"
#import "DBConnector.h"
#import "ViewControllerExercises2.h"

@interface ViewControllerExercises ()

@end

@implementation ViewControllerExercises

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
    
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    // デリゲート
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    _trSettings = [[TrSettings alloc]init];
    _trExercisesData = [TrExercisesData sharedManager];

    // バーにボタンを追加
    if (!self.isEdit){
        //モーダル表示時はキャンセルボタンを動的追加
        UIBarButtonItem *button = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Cancel"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(btnCancel)];
    
        // ナビゲーションバーの右に「2ページ」ボタンをセット
        self.navigationItem.leftBarButtonItem = button;
    }
    
    _db = [[DBConnector alloc]init];
    
    //テーブルセクション
    _tableSection = [[NSMutableArray alloc] init];
    _tableKey     = [[NSMutableArray alloc] init];
    _tableVal     = [[NSMutableArray alloc] init];
    
    //セクション名
    NSArray *tableSectionEg = [[NSArray alloc]initWithObjects:@"Body Regions" ,nil];
    NSArray *tableSectionJp = [[NSArray alloc]initWithObjects:@"身体部位"      ,nil];
    
    if(_trSettings.defaultLanguage == 0){
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionEg];
    }else{
        _tableSection = (NSMutableArray *)[NSArray arrayWithArray:tableSectionJp];
    }
    
    [_db dbOpen];
    
    [_db executeQuery:[self getMTrBui] ];
    
    while ([_db.results next]) {
        [_tableKey addObject:[NSNumber numberWithInt:[_db.results intForColumn:@"tr_bui_id"]]];
        [_tableVal addObject:[_db.results stringForColumn:@"tr_bui_name"]];
    }
    
    [_db dbClose];
}

- (void) btnCancel{
    //view閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSString*)getMTrBui{
    NSString *sql;
    
    sql = [NSString stringWithFormat
           :@"SELECT tr_bui_id"
             "      ,tr_bui_name"
             "  FROM m_tr_bui"
             " ORDER BY tr_bui_id"
           ];
    return sql;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //選択モードの場合
    if(_trExercisesData.runMode == 1){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _buiID   = [NSString stringWithFormat:@"%@",[_tableKey objectAtIndex:indexPath.row]].intValue;
    _buiName = [_tableVal objectAtIndex:indexPath.row];
    
    //選択モード
    if(_trExercisesData.runMode == 1){
        //選択モード
        /* シングルトンに設定して閉じる viewControllerのdelegateで通知*/
        _trExercisesData.buiId = [NSString stringWithFormat:@"%@"
                                      ,[_tableKey objectAtIndex:indexPath.row]].intValue;
        _trExercisesData.buiName = [NSString stringWithFormat:@"%@"
                                        ,[_tableVal objectAtIndex:indexPath.row]];
        _trExercisesData.syumokuId   = 0;
        _trExercisesData.syumokuName = @"";
        //view閉じる
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
        [self performSegueWithIdentifier:@"trExercises2Segue" sender:self];
    }
}

//画面遷移時に呼ばれるメソッド
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"trExercises2Segue"]) {
        ViewControllerExercises2 *nextView = segue.destinationViewController;
        nextView.buiID = _buiID;
        nextView.buiName = _buiName;
        nextView.isEdit = self.isEdit;
        nextView.delegate = (id<ViewControllerExercises2Delegate>)self;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // 必ず親クラスのviewWillAppear:メソッドを呼ぶこと
    [super viewWillAppear:animated];
    // ハイライト解除
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
