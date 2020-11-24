//
//  EMChatViewController+EMMsgLongPressIncident.h
//  EaseIM
//
//  Created by 娜塔莎 on 2020/7/9.
//  Copyright © 2020 娜塔莎. All rights reserved.
//

#import "EMChatViewController.h"
#import "EMMessageModel.h"
#import "EMMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMChatViewController (EMMsgLongPressIncident)

//长按操作栏
@property (strong, nonatomic) NSIndexPath *__nullable longPressIndexPath;

- (void)executeAction:(NSInteger)tag;

- (void)resetCellLongPressStatus:(EMMessageCell *)aCell;

@end

NS_ASSUME_NONNULL_END
