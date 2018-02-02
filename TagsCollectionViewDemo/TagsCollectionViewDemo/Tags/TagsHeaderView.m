//
//  TagsHeaderView.m
//  TagsCollectionViewDemo
//
//  Created by zylkdd on 2018/1/31.
//  Copyright © 2018年 zylkdd. All rights reserved.
//

#import "TagsHeaderView.h"

@interface TagsHeaderView(){
    
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
}

@end
@implementation TagsHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI
{
    CGFloat marginX = 15.0f;
    
    CGFloat labelWidth = (self.bounds.size.width - 2*marginX)/2.0f;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, labelWidth, self.bounds.size.height)];
    _titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth + marginX, 0, labelWidth, self.bounds.size.height)];
    _subTitleLabel.textColor = [UIColor lightGrayColor];
    _subTitleLabel.textAlignment = NSTextAlignmentRight;
    _subTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:_subTitleLabel];
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

-(void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    _subTitleLabel.text = subTitle;
}
@end
