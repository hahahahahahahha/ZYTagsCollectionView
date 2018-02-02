//
//  TagsViewCell.h
//  TagsCollectionViewDemo
//
//  Created by zylkdd on 2018/1/31.
//  Copyright © 2018年 zylkdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagsViewCell : UICollectionViewCell

//标题
@property (nonatomic, copy) NSString *title;

//是否正在移动状态
@property (nonatomic, assign) BOOL isMoving;

//是否被固定
@property (nonatomic, assign) BOOL isFixed;
@end
