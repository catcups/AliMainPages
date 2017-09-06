
//
//  BackCell.m
//  QuartzCoreCode
//
//  Created by QH on 2017/8/25.
//  Copyright © 2017年 QH. All rights reserved.
//

#import "BackCell.h"

@interface BackCell ()
@property (nonatomic, strong) UILabel *l;
@property (nonatomic, strong) UIView *vvv;
@end
@implementation BackCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _vvv = [[UIView alloc] initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width - 20, 34)];
        [self.contentView addSubview:_vvv];
        
        _l = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, [UIScreen mainScreen].bounds.size.width - 30, 30)];
        _l.text = @"xxxx";
        _l.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_l];
    }
    return self;
}
- (void)setStr:(NSString *)str {
    _str = str;
    self.l.text = str;
}
- (void)setBack:(UIColor *)back {
    _back = back;
    _vvv.backgroundColor = back;
    [_vvv.layer setShadowPath:[[UIBezierPath bezierPathWithRect:_vvv.bounds] CGPath]];
    [_vvv.layer setShadowOpacity:0.5];
}
- (void)layoutSubviews {
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
