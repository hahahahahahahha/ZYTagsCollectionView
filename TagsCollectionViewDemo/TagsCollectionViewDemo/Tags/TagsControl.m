//
//  TagsControl.m
//  TagsCollectionViewDemo
//
//  Created by zylkdd on 2018/1/31.
//  Copyright © 2018年 zylkdd. All rights reserved.
//

#import "TagsControl.h"
#import "TagsView.h"

@interface TagsControl(){
    
    UINavigationController *_nav;
    
    TagsView *_tagsView;
    
    TagsBlock _block;

}
@end

@implementation TagsControl

+ (TagsControl *)shareControl{
    
    static TagsControl *control = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        control = [[TagsControl alloc]init];
    });
    return control;
}
- (instancetype)init{
    
    if (self = [super init]) {
        
        [self buildTagsView];
    }
    return self;
}
- (void)buildTagsView{
    
    _tagsView = [[TagsView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    _nav = [[UINavigationController alloc]initWithRootViewController:[UIViewController new]];
    _nav.navigationBar.tintColor = [UIColor blackColor];
    _nav.topViewController.title = @"频道管理";
    _nav.topViewController.view = _tagsView;
     _nav.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backMethod)];
}

-(void)backMethod{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _nav.view.frame;
        frame.origin.y = -_nav.view.bounds.size.height;
        _nav.view.frame = frame;
    }completion:^(BOOL finished) {
        [_nav.view removeFromSuperview];
    }];
    
    _block(_tagsView.inUseTitles,_tagsView.unUseTitles);

}
- (void)showTagsViewWithInUseTitles:(NSArray *)inUseTitles unUseTitles:(NSArray *)unUseTitles finish:(TagsBlock)block{
    
    _block = block;
    _tagsView.inUseTitles = [NSMutableArray arrayWithArray:inUseTitles];
    _tagsView.unUseTitles = [NSMutableArray arrayWithArray:unUseTitles];
    [_tagsView reloadData];
    
    CGRect frame = _nav.view.frame;
    frame.origin.y = -_nav.view.bounds.size.height;
    _nav.view.frame = frame;
    _nav.view.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:_nav.view];
    
    [UIView animateWithDuration:0.4 animations:^{
        _nav.view.alpha = 1;
        _nav.view.frame = [UIScreen mainScreen].bounds;
    }];
}















@end
