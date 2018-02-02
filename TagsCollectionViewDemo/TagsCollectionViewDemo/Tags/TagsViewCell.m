//
//  TagsViewCell.m
//  TagsCollectionViewDemo
//
//  Created by zylkdd on 2018/1/31.
//  Copyright © 2018年 zylkdd. All rights reserved.
//

#import "TagsViewCell.h"

@interface TagsViewCell(){
    
    UILabel *_textLabel;
    CAShapeLayer *_borderLayer;
}
@end

@implementation TagsViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    
    self.userInteractionEnabled = YES;
    self.layer.cornerRadius = 5.0f;
    self.backgroundColor = [self backgroundColor];
    
    _textLabel = [UILabel new];
    _textLabel.frame = self.bounds;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = [self textColor];
    _textLabel.adjustsFontSizeToFitWidth = YES;
    _textLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:_textLabel];
    
    [self addBorderLayer];
}
-(void)addBorderLayer{
    _borderLayer = [CAShapeLayer layer];
    _borderLayer.bounds = self.bounds;
    _borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:_borderLayer.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    _borderLayer.lineWidth = 1;
    _borderLayer.lineDashPattern = @[@5,@3];
    _borderLayer.fillColor = [UIColor clearColor].CGColor;
    _borderLayer.strokeColor = [self backgroundColor].CGColor;
    [self.layer addSublayer:_borderLayer];
    _borderLayer.hidden = YES;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}
#pragma mark -
#pragma mark 配置方法

-(UIColor*)backgroundColor{
    return [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
}

-(UIColor*)textColor{
    return [UIColor colorWithRed:40/255.0f green:40/255.0f blue:40/255.0f alpha:1];
}

-(UIColor*)lightTextColor{
    return [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
}
#pragma mark -
#pragma mark Setter
- (void)setTitle:(NSString *)title{
    
    _title = title;
    _textLabel.text = title;
}
- (void)setIsMoving:(BOOL)isMoving{
    
    _isMoving = isMoving;
    if (_isMoving) {
        self.backgroundColor = [UIColor clearColor];
        _borderLayer.hidden = false;
    }else{
        self.backgroundColor = [self backgroundColor];
        _borderLayer.hidden = true;
    }
}
-(void)setIsFixed:(BOOL)isFixed{
    _isFixed = isFixed;
    if (isFixed) {
        _textLabel.textColor = [self lightTextColor];
    }else{
        _textLabel.textColor = [self textColor];
    }
}
@end
