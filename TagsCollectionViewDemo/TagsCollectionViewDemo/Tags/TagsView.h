//
//  TagsView.h
//  TagsCollectionViewDemo
//
//  Created by zylkdd on 2018/1/31.
//  Copyright © 2018年 zylkdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagsView : UIView

@property (nonatomic, strong) NSMutableArray *inUseTitles;

@property (nonatomic, strong) NSMutableArray *unUseTitles;

- (void)reloadData;

@end
