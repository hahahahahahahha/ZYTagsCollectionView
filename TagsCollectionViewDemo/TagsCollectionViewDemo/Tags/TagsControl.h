//
//  TagsControl.h
//  TagsCollectionViewDemo
//
//  Created by zylkdd on 2018/1/31.
//  Copyright © 2018年 zylkdd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^TagsBlock)(NSArray *inUseTitles,NSArray *unUseTitles);

@interface TagsControl : NSObject


+ (TagsControl *)shareControl;

- (void)showTagsViewWithInUseTitles:(NSArray *)inUseTitles unUseTitles:(NSArray *)unUseTitles finish:(TagsBlock)block;
@end
