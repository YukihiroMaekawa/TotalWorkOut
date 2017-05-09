//
//  ViewGraphLine.h
//  test20140413_3
//
//  Created by 前川 幸広 on 2014/04/13.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface ViewGraphLine : UIView<CPTPlotDataSource>
{
@private
    // グラフ表示領域（この領域に円グラフを追加する）
    CPTGraph *graph;
}

- (void) createGraphLine;

// 軸の単位
@property (nonatomic) NSString * xTitle;
@property (nonatomic) NSString * yTitle;

// グラフ位置指定
@property (nonatomic) int viewX; //X座標
@property (nonatomic) int viewY; //Y座標
@property (nonatomic) int viewWidth;  //幅
@property (nonatomic) int viewHeight; //高さ

// グラフデータ
@property (nonatomic) NSArray * xDataArr; // 0から連番
@property (nonatomic) NSArray * yDataArr; //
@property (nonatomic) NSArray * xLabelArr; //日付
@property (nonatomic) float yIntervalLength; //Y軸間隔
@property (nonatomic) int   yMin; //Y軸最小値
@property (nonatomic) int   yLength; //Y軸最大値


// 円グラフで表示するデータを保持する配列
@property (readwrite, nonatomic) NSMutableArray *scatterPlotData;


@end
