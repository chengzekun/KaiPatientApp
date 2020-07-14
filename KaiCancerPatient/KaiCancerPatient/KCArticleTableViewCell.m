//
//  KCArticleTableViewCell.m
//  KaiCancerPatient
//
//  Created by 成泽坤 on 2020/7/1.
//  Copyright © 2020 CZK. All rights reserved.
//

#import "KCArticleTableViewCell.h"
@interface KCArticleTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *introImg;
@property (strong,nonatomic) KCArticleModel* model;
@end

@implementation KCArticleTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.introImg.layer.masksToBounds = YES;
    self.introImg.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateWithModel:(KCArticleModel *)model{
    self.model = model;
    self.timeLabel.text = model.time;
    [self.introImg sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.titileLabel.text = model.title;
    self.contentLabel.text = model.content;
}

@end
