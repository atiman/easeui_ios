//
//  EaseConversationsViewController.h
//  EaseIMKit
//
//  Created by 杜洁鹏 on 2020/10/29.
//

#import <UIKit/UIKit.h>
#import <Hyphenate/Hyphenate.h>
#import "EaseConversationCellOptions.h"
#import "EaseConversationCellModelDelegate.h"
#import "EaseConversationCell.h"
#import "EaseBaseTableViewController.h"

@protocol EaseConversationVCDelegate <NSObject>

@optional

/**
 * 会话列表 cell 部分数据源     头像等
 *
 * @param   cellModel  id<EaseConversationModelDelegate> 类型 数据源
 */
- (id<EaseConversationCellModelDelegate>)conversationCellForModel:(EaseConversationModel*)cellModel;

/**
 * 会话列表cell侧滑自定义功能区，可添加一项Action
 *
 * @param   tableView  当前操作的 tableview
 * @param   dataArray  id<EaseConversationModelDelegate> 类型 数据源
 * @param   indexPath 当前点击的   indexPath
 */
- (UIContextualAction *)sideslipCustomAction:(UITableView *)tableView dataArray:(NSMutableArray *)dataArray trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos);

/**
 * 会话列表cell 选中 事件
 *
 * @param   tableView  当前点击的 tableview
 * @param   dataArray  id<EaseConversationModelDelegate> 类型 数据源
 * @param   indexPath 当前点击的   indexPath
 */
- (void)tableView:(UITableView *)tableView dataArray:(NSMutableArray *)dataArray didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 排序会话列表
 *
 * @param   modelList  会话列表（EaseConversationModel *）类型数据源
 */
- (NSArray *)sortConversationsList:(NSArray<EaseConversationModel *> *)modelList;

//是否需要系统通知：好友/群 申请等   默认需要
- (BOOL)isNeedsSystemNotification;

@end

@interface EaseConversationsViewController : EaseBaseTableViewController

- (instancetype)initWithOptions:(EaseConversationCellOptions *)options; //初始化
- (void)reloadViewWithOption:(EaseConversationCellOptions*)options; //根据 option 重新刷新会话列表

@property (nonatomic, assign) id<EaseConversationVCDelegate> conversationVCDelegate;

@end
