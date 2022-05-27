//
//  EMsgUserBaseCell.m
//  EaseIMKit
//
//  Created by yangjian on 2022/5/18.
//

#import "EMsgUserBaseCell.h"

@implementation EMsgUserBaseCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUserInfoViews];
    }
    return self;
}

- (void)configUserInfoViews{
    self.customBackgroundView = UIView.new;
    self.headImageView = UIImageView.new;
    self.nameLabel = UILabel.new;
    self.nameLabel.font = EMsgTableViewConfig.shared.nameFont;
    self.msgBackgroundView = UIView.new;

    [self.contentView addSubview:self.customBackgroundView];
    [self.customBackgroundView addSubview:self.headImageView];
    [self.customBackgroundView addSubview:self.nameLabel];
    [self.customBackgroundView addSubview:self.msgBackgroundView];
    [self.customBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.headImageView.backgroundColor = UIColor.orangeColor;
    self.nameLabel.backgroundColor = UIColor.orangeColor;
    self.msgBackgroundView.backgroundColor = UIColor.yellowColor;
//    self.msgContentView.backgroundColor = UIColor.cyanColor;
    
}

- (void)resetSubViewsLayout:(EMMessageDirection)direction
                   showHead:(BOOL)showHead
                   showName:(BOOL)showName {
    self.headImageView.hidden = !showHead;
    self.nameLabel.hidden = !showName;
    if (showHead) {
        [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(EMsgCellLayoutAdapterConfigs.shared.userInfoLayoutAdapter.headTop);
            make.width.mas_equalTo(EMsgCellLayoutAdapterConfigs.shared.userInfoLayoutAdapter.headWidth);
            make.height.mas_equalTo(EMsgCellLayoutAdapterConfigs.shared.userInfoLayoutAdapter.headHeight);
            switch (direction) {
                case EMMessageDirectionSend:
                    make.right.mas_equalTo(- EMsgCellLayoutAdapterConfigs.shared
                                           .userInfoLayoutAdapter.headFromSide);
                    break;
                case EMMessageDirectionReceive:
                    make.left.mas_equalTo(EMsgCellLayoutAdapterConfigs.shared
                                          .userInfoLayoutAdapter.headFromSide);
                    break;
                default:
                    break;
            }
        }];
    }
    if (showName) {
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(EMsgCellLayoutAdapterConfigs.shared.userInfoLayoutAdapter.nameTop);
            make.height.mas_equalTo(EMsgCellLayoutAdapterConfigs.shared.userInfoLayoutAdapter.nameHeight);
            switch (direction) {
                case EMMessageDirectionSend:
                    make.right.mas_equalTo(- (EMsgCellLayoutAdapterConfigs.shared
                                              .userInfoLayoutAdapter.nameFromSide
                                              + (showHead?EMsgCellLayoutAdapterConfigs.shared
                                                 .userInfoLayoutAdapter.headTakeWidth : 0)));
                    break;
                case EMMessageDirectionReceive:
                    make.left.mas_equalTo(EMsgCellLayoutAdapterConfigs.shared
                                          .userInfoLayoutAdapter.nameFromSide
                                          + (showHead?EMsgCellLayoutAdapterConfigs.shared
                                             .userInfoLayoutAdapter.headTakeWidth : 0));
                    break;
                default:
                    break;
            }
        }];
    }
    //这里说明下:如果不展示头像,聊天内容会偏移,而不是拉宽消息显示控件的宽度.偏移的距离和头像展示时占用的宽度相同(区别于头像本身,头像展示时宽度为 : 头像本身宽度和头像距离边缘的宽度相加)
    UIEdgeInsets msgBackgroundEdgeInsets
    = [EMsgCellLayoutAdapterConfigs.shared
       convertToEdgeInsets_direction:direction
       top:EMsgCellLayoutAdapterConfigs.shared.backgroundLayoutAdapter.top
       + (showName ? EMsgCellLayoutAdapterConfigs.shared.userInfoLayoutAdapter.nameTakeHeight : 0)
       fromSide:EMsgCellLayoutAdapterConfigs.shared.backgroundLayoutAdapter.fromSide
       + (showHead ? EMsgCellLayoutAdapterConfigs.shared.userInfoLayoutAdapter.headTakeWidth : 0)
       toSide:EMsgCellLayoutAdapterConfigs.shared.backgroundLayoutAdapter.toSide
       + (showHead ? 0 : EMsgCellLayoutAdapterConfigs.shared.userInfoLayoutAdapter.headTakeWidth)
       bottom:EMsgCellLayoutAdapterConfigs.shared.backgroundLayoutAdapter.bottom];
    
    [self.msgBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(msgBackgroundEdgeInsets.top);
        make.left.mas_equalTo(msgBackgroundEdgeInsets.left);
#if YANGJIAN_MANUAL
        make.bottom.mas_equalTo(-msgBackgroundEdgeInsets.bottom);
#else
#endif
        make.right.mas_equalTo(-msgBackgroundEdgeInsets.right);

    }];
}

@end
