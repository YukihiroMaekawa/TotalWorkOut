//
//  ViewControllerSetthings.m
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/04/03.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import "ViewControllerSetthings.h"

@interface ViewControllerSetthings ()

@end

@implementation ViewControllerSetthings

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
    
    //設定読み込み
    _trSettings = [[TrSettings alloc]init];
    _trMaster   = [[TrMaster alloc]init];
    
    //デリゲート
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self createTableData];
}

// テーブルデータ作成
- (void) createTableData{
    _tableSection         = [[NSMutableArray alloc]init];
    _tableValLanguage     = [[NSMutableArray alloc]init];
    _tableValUnitWeight   = [[NSMutableArray alloc]init];
    _tableValUnitDistance = [[NSMutableArray alloc]init];
    
    _tableVal3    = [[NSMutableArray alloc]init];
    _tableVal4    = [[NSMutableArray alloc]init];
    
    //セクション名
    NSArray *tableSectionEg = [[NSArray alloc]initWithObjects:@"language",@"Units(Weight)",@"Units(Distance)"
                               ,@"Load Data" ,@"Reset" ,nil];
    NSArray *tableSectionJp = [[NSArray alloc]initWithObjects:@"言語"     ,@"単位(重さ)" ,@"単位(距離)"
                               ,@"読み込み"   ,@"リセット" ,nil];
    //言語
    NSArray *tableValLanguageEg     = [[NSArray alloc]initWithObjects:@"English",@"Japanese", nil];
    NSArray *tableValLanguageJp     = [[NSArray alloc]initWithObjects:@"英語",@"日本語", nil];
    //単位-重さ
    NSArray *tableValUnitWeightEg    = [[NSArray alloc]initWithObjects:@"Kg",@"Lbs", nil];
    NSArray *tableValUnitWeightJp    = [[NSArray alloc]initWithObjects:@"Kg",@"Lbs", nil];
    //単位-距離
    NSArray *tableValUnitDistanceEg = [[NSArray alloc]initWithObjects:@"Miles",@"Km", nil];
    NSArray *tableValUnitDistanceJp = [[NSArray alloc]initWithObjects:@"Miles",@"Km", nil];
    
    
    NSArray *tableVal3Eg    = [[NSArray alloc]initWithObjects:@"Exercise Data", nil];
    NSArray *tableVal3Jp    = [[NSArray alloc]initWithObjects:@"エクササイズデータ", nil];

    NSArray *tableVal4Eg    = [[NSArray alloc]initWithObjects:@"Delete All Data", nil];
    NSArray *tableVal4Jp    = [[NSArray alloc]initWithObjects:@"すべてのデータを削除", nil];
    
    [_trSettings loadLanguage];
    [_trSettings loadUnitWeight];
    
    if(_trSettings.defaultLanguage == 0){
        _tableSection         = (NSMutableArray *)[NSArray arrayWithArray:tableSectionEg];
        _tableValLanguage     = (NSMutableArray *)[NSArray arrayWithArray:tableValLanguageEg];
        _tableValUnitWeight   = (NSMutableArray *)[NSArray arrayWithArray:tableValUnitWeightEg];
        _tableValUnitDistance = (NSMutableArray *)[NSArray arrayWithArray:tableValUnitDistanceEg];
        
        _tableVal3    = (NSMutableArray *)[NSArray arrayWithArray:tableVal3Eg];
        _tableVal4    = (NSMutableArray *)[NSArray arrayWithArray:tableVal4Eg];
    }else{
        _tableSection         = (NSMutableArray *)[NSArray arrayWithArray:tableSectionJp];
        _tableValLanguage     = (NSMutableArray *)[NSArray arrayWithArray:tableValLanguageJp];
        _tableValUnitWeight   = (NSMutableArray *)[NSArray arrayWithArray:tableValUnitWeightJp];
        _tableValUnitDistance = (NSMutableArray *)[NSArray arrayWithArray:tableValUnitDistanceJp];

        _tableVal3    = (NSMutableArray *)[NSArray arrayWithArray:tableVal3Jp];
        _tableVal4    = (NSMutableArray *)[NSArray arrayWithArray:tableVal4Jp];
    }
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
//    return [_tableVal count];
    
    NSInteger retVal=0;
    switch (section) {
        case 0:
            retVal = [_tableValLanguage count];
            break;
        case 1:
            retVal = [_tableValUnitWeight count];
            break;
        case 2:
            retVal = [_tableValUnitDistance count];
            break;
        case 3:
            retVal = [_tableVal3 count];
            break;
        case 4:
            retVal = [_tableVal4 count];
            break;
    }
    return retVal;
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
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
            // 言語 (0:英語 ,1:日本語)
            if(indexPath.row == _trSettings.defaultLanguage){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            cell.textLabel.text = [_tableValLanguage objectAtIndex:indexPath.row];
            break;
        case 1:
            // 単位(0:Kg ,1:Lb)
            if(indexPath.row == _trSettings.unitWeight){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            cell.textLabel.text = [_tableValUnitWeight objectAtIndex:indexPath.row];
            break;
        case 2:
            // 単位(0:Miles ,1:Km)
            if(indexPath.row == _trSettings.unitDistance){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            cell.textLabel.text = [_tableValUnitDistance objectAtIndex:indexPath.row];
            break;
        case 3:
            //ロードデータ
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.text = [_tableVal3 objectAtIndex:indexPath.row];
            cell.textLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
            break;
        case 4:
            //リセット
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.text = [_tableVal4 objectAtIndex:indexPath.row];
            cell.textLabel.textColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.8 alpha:1.000];
            break;
    }
    return cell;
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0
        || indexPath.section == 1
        || indexPath.section == 2
        ){
        for (NSInteger index=0; index<[self.tableView numberOfRowsInSection:indexPath.section]; index++) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:
                                     [NSIndexPath indexPathForRow:index inSection:indexPath.section]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            // ①選択したセルだけチェックする
            if (indexPath.row == index) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
                // 言語設定(0:英語、1:日本語)
                if(indexPath.section == 0){
                    _trSettings.defaultLanguage = indexPath.row;
                    [_trSettings saveLanguage];
                }
                // 単位設定(0:Kg ,1:Lb)
                else if (indexPath.section == 1){
                    _trSettings.unitWeight = indexPath.row;
                    [_trSettings saveUnitWeight];
                }
                // 単位設定(0:Miles,1:Km)
                else if (indexPath.section == 2){
                    _trSettings.unitDistance = indexPath.row;
                    [_trSettings saveUnitDistance];
                }
            }
        }
        
        [self createTableData];
        [self.tableView reloadData];

    }
    else{
        NSString * titleStr;
        NSString * mesStr;
        //ロード
        if (indexPath.section == 3) {
            _runMode = 1;
            if(_trSettings.defaultLanguage == 0){
                titleStr = @"Confirm";
                mesStr   = @"Are you sure you want to load the initial data?";
            }else{
                titleStr = @"確認";
                mesStr   = @"初期データを読み込みしますか";
            }
        ///リセット
        }else{
            _runMode = 2;

            if(_trSettings.defaultLanguage == 0){
                titleStr = @"Confirm";
                mesStr   = @"Are you sure you want to reset all data?";
            }else{
                titleStr = @"確認";
                mesStr   = @"すべてのデータをリセットします";
            }
        }
        
        // １行で書くタイプ（複数ボタンタイプ）
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:titleStr message:mesStr
                                  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            // ハイライト解除
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

            break;
        case 1:
            if(_runMode == 1){
                //マスターデータ初期化
                [self loadMasterData];
            }else{
                //マスターデータ初期化
                [self resetAll];
            }
    }
}

-(void) loadMasterData{
    [_trMaster masterDataInit];
    [self.tableView reloadData];

}

-(void) resetAll{
    //マスターデータ初期化
    //設定初期化
    [_trSettings resetAllData];
    //テーブル初期化
    [_trMaster resetAllData];
    
    [self.tableView reloadData];

}

@end
