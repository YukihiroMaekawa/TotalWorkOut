//
//  EmTrBui.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnector.h"
@interface EntityMTrBui : NSObject

@property NSInteger  pKeyTrBuiId;
@property NSString * pTrBuiName;
@property NSString * pTrKb;

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trBuiId;
-(void) doInsMTrBui:(DBConnector *)db;
-(void) doSelect:(DBConnector *)db;

@end
