//
//  ChatPopView.m
//  EaseIMKit
//
//  Created by 中裕 on 2022/7/26.
//

#import "ChatPopView.h"
#import "View+EaseAdditions.h"

@interface ChatPopView ()

@property (nonatomic, strong)UILabel * voteLabel;
@property (nonatomic, strong)UILabel * activityLabel;

@end

@implementation ChatPopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:53/255 green:50/255 blue:76/255 alpha:0.8];
        [self setupView];

    }
    return  self;
}

- (void)setupView {
    self.voteBtn = [[UIButton alloc] init];
    [self.voteBtn setImage:[UIImage imageNamed:@"chat_vote"] forState:UIControlStateNormal];
    [self.voteBtn addTarget:self action:@selector(voteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.voteBtn];
    [self.voteBtn Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.ease_top).offset(12);
        make.width.height.Ease_equalTo(28);
    }];
    self.voteLabel = [[UILabel alloc] init];
    self.voteLabel.font = [UIFont systemFontOfSize:12];
    self.voteLabel.textColor = [UIColor whiteColor];
    self.voteLabel.text = @"投票";
    [self addSubview:self.voteLabel];
    [self.voteLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.voteBtn.ease_bottom).offset(3);
    }];
    
    self.activityBtn = [[UIButton alloc] init];
    [self.activityBtn setImage:[UIImage imageNamed:@"chat_activity"] forState:UIControlStateNormal];
    [self.activityBtn addTarget:self action:@selector(activityBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.activityBtn];
    [self.activityBtn Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.voteLabel.ease_bottom).offset(10);
        make.width.height.Ease_equalTo(28);
    }];
    self.activityLabel = [[UILabel alloc] init];
    self.activityLabel = [[UILabel alloc] init];
    self.activityLabel.font = [UIFont systemFontOfSize:12];
    self.activityLabel.textColor = [UIColor whiteColor];
    self.activityLabel.text = @"活动";
    [self addSubview:self.activityLabel];
    [self.activityLabel Ease_makeConstraints:^(EaseConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.activityBtn.ease_bottom).offset(3);
    }];
}

- (void)tap {
    NSLog(@"2222");
}

- (void)voteBtnClick:(UIButton *)sender {
    NSLog(@"投票");
}

- (void)activityBtnClick {
    NSLog(@"活动");
}



@end
