//
//  TagsView.m
//  TagsCollectionViewDemo
//
//  Created by zylkdd on 2018/1/31.
//  Copyright © 2018年 zylkdd. All rights reserved.
//

#import "TagsView.h"
#import "TagsViewCell.h"
#import "TagsHeaderView.h"

//菜单列数
static NSInteger ColumnNumber = 4;
//横向和纵向的间距
static CGFloat CellMarginX = 15.0f;
static CGFloat CellMarginY = 10.0f;

@interface TagsView()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    UICollectionView *_collectionView;
    //被拖拽的item
    TagsViewCell *_dragingItem;
    //正在拖拽的indexpath
    NSIndexPath *_dragingIndexPath;
    //目标位置
    NSIndexPath *_targetIndexPath;
}
@end
@implementation TagsView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}
- (void)buildUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat cellWidth = (self.bounds.size.width - (ColumnNumber + 1) * CellMarginX) / ColumnNumber;
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth/2.0f);
    flowLayout.sectionInset = UIEdgeInsetsMake(CellMarginY, CellMarginX, CellMarginY, CellMarginX);
    flowLayout.minimumLineSpacing = CellMarginY;
    flowLayout.minimumInteritemSpacing = CellMarginX;
    flowLayout.headerReferenceSize = CGSizeMake(self.bounds.size.width, 40);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[TagsViewCell class] forCellWithReuseIdentifier:@"TagsViewCell"];
    [_collectionView registerClass:[TagsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TagsHeaderView"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressMethod:)];
    [_collectionView addGestureRecognizer:longPress];
    
    _dragingItem = [[TagsViewCell alloc]initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth/2)];
    _dragingItem.hidden = YES;
    [_collectionView addSubview:_dragingItem];
    
}
#pragma mark -
#pragma mark LongPressMethod
- (void)longPressMethod:(UILongPressGestureRecognizer *)gesture{
    
    CGPoint point = [gesture locationInView:_collectionView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd];
            break;
            
        default:
            break;
    }
}
//拖拽开始 找到被拖拽的item
- (void)dragBegin:(CGPoint)point{
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!_dragingIndexPath) {
        return;
    }
    [_collectionView bringSubviewToFront:_dragingItem];
    
    TagsViewCell *item = (TagsViewCell *)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
    item.isMoving = YES;
    //更新被拖拽的item
    _dragingItem.hidden = NO;
    _dragingItem.frame = item.frame;
    _dragingItem.title = item.title;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
}
//正在被拖拽、、、
-(void)dragChanged:(CGPoint)point{
    
    if (!_dragingIndexPath) {
        return;
    }
    _dragingItem.center = point;
    _targetIndexPath = [self getTargetIndexPathWithPoint:point];
    //交换位置 如果没有找到_targetIndexPath则不交换位置

    if (_dragingIndexPath && _targetIndexPath) {
        //更新数据源
        [self rearrangeInUseTitles];
        //更新item位置
        [_collectionView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
    }
}
//拖拽结束
-(void)dragEnd{
    if(!_dragingIndexPath){
        return;
    }
    CGRect endFrame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [UIView animateWithDuration:0.3 animations:^{
        _dragingItem.frame = endFrame;
    } completion:^(BOOL finished) {
        _dragingItem.hidden = YES;
        TagsViewCell *itme = (TagsViewCell *)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
        itme.isMoving = NO;
    }];

}
#pragma mark -
#pragma mark 辅助方法
- (NSIndexPath *)getDragingIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *dragIndexPath = nil;
    //最后剩一个怎不可以排序
    
    if ([_collectionView numberOfItemsInSection:0] == 1) {
        return dragIndexPath;
    }
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //下半部分不需要排序
        if (indexPath.section > 0) {
            continue;
        }
        //在上半部分找出相应的item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            
            if (indexPath.row != 0) {
                dragIndexPath = indexPath;
            }
            break;
        }
    }
    return dragIndexPath;
}
//获取目标IndexPath的方法
-(NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point{
    
    NSIndexPath *targetIndexPath = nil;
    
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //如果是自己不需要排序
        if ([indexPath isEqual:_dragingIndexPath]) {
            continue;
        }
        //第二组不需要排序
        if (indexPath.section > 0) {continue;}
        //在第一组中找出将被替换位置的Item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath != 0) {
                targetIndexPath = indexPath;
            }
        }
    }
    return targetIndexPath;
}
#pragma mark -
#pragma mark CollectionViewDelegate&DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return section == 0 ? _inUseTitles.count : _unUseTitles.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    TagsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TagsHeaderView" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        headerView.title = @"已选频道";
        headerView.subTitle = @"按住拖动调整排序";
    }else{
        headerView.title = @"推荐频道";
        headerView.subTitle = @"";
    }
    return headerView;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellId = @"TagsViewCell";
    TagsViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    item.title = indexPath.section == 0 ? _inUseTitles[indexPath.row] : _unUseTitles[indexPath.row];
    item.isFixed = indexPath.section == 0 && indexPath.row == 0;
    return item;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        //只剩一个的时候不可删除
        if ([_collectionView numberOfItemsInSection:0] == 1) {return;}
        //第一个不可删除
        if (indexPath.row  == 0) {return;}
        id obj = [_inUseTitles objectAtIndex:indexPath.row];
        [_inUseTitles removeObject:obj];
        [_unUseTitles insertObject:obj atIndex:0];
        //此方法非常重要，不调用，不会重排
        [_collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    }else{
        id obj = [_unUseTitles objectAtIndex:indexPath.row];
        [_unUseTitles removeObject:obj];
        [_inUseTitles addObject:obj];
        [_collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:_inUseTitles.count - 1 inSection:0]];
    }
    
}
#pragma mark -
#pragma mark 刷新方法
//拖拽排序后需要重新排序数据源
-(void)rearrangeInUseTitles{
    id obj = [_inUseTitles objectAtIndex:_dragingIndexPath.row];
    [_inUseTitles removeObject:obj];
    [_inUseTitles insertObject:obj atIndex:_targetIndexPath.row];
}
-(void)reloadData{
    [_collectionView reloadData];
}

@end
