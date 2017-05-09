//
//  EntityMTrSyumoku.h
//  Total WorkOut
//
//  Created by 前川 幸広 on 2014/03/29.
//  Copyright (c) 2014年 Yukihiro Maekawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnector.h"

@interface EntityMTrSyumoku : NSObject

@property NSInteger  pKeyTrBuiId;
@property NSInteger  pKeyTrSyumokuId;
@property NSString * pTrSyumokuName;

- (id)initWithSelect :(DBConnector *)db :(NSInteger)trBuiId :(NSInteger)trSyumokuId;
-(void) doInsert:(DBConnector *)db;
-(void) doUpdate:(DBConnector *)db;
-(void) doDelete:(DBConnector *)db;
-(NSInteger) getKeyMTrSyumoku:(DBConnector *)db :(NSInteger)trBuiID;


@end
