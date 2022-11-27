//
//  QYZYLiveMoreViewController.m
//  QYZY
//
//  Created by jspollo on 2022/9/30.
//

#import "QYZYLiveMoreViewController.h"
#import "QYZYLiveDetailViewController.h"
#import "QYZYLiveMainViewModel.h"
#import "QYZYLiveCell.h"
#import "QYZYCollectionEmptyCell.h"

@interface QYZYLiveMoreViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) QYZYLiveMainViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) NSArray<QYZYLiveListModel *> *array;
@end

@implementation QYZYLiveMoreViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setsubView];
    [self requestMoreData];
}

- (void)setsubView {
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYLiveCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(QYZYLiveCell.class)];
    [self.collectionView registerClass:QYZYCollectionEmptyCell.class forCellWithReuseIdentifier:NSStringFromClass(QYZYCollectionEmptyCell.class)];
    weakSelf(self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(self);
        [self requestMoreData];
    }];
}

- (void)requestMoreData {
    weakSelf(self);
    [self.viewModel requestLiveListWithLiveGroupId:@"1" completion:^(NSArray<QYZYLiveListModel *> * _Nonnull liveArray, NSString * _Nonnull msg) {
        strongSelf(self);
        [self.collectionView.mj_header endRefreshing];
        if (liveArray) {
            self.array = liveArray;
            [self.collectionView reloadData];
        }
    }];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.array.count) {
        QYZYLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QYZYLiveCell.class) forIndexPath:indexPath];
        if (self.array.count > indexPath.row) {
            cell.listModel = self.array[indexPath.row];
        }
        return cell;
    }
    else {
        QYZYCollectionEmptyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QYZYCollectionEmptyCell.class) forIndexPath:indexPath];
        return cell;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count ? self.array.count : 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.array.count) {
        CGFloat itemSpace = 12;
        CGFloat width = (ScreenWidth - itemSpace*3)*0.5;
        CGFloat height = 170;
        return CGSizeMake(width, height);
    }
    else {
        return self.view.frame.size;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 0, 12);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.array.count) {
        QYZYLiveDetailViewController *vc = [QYZYLiveDetailViewController new];
        if (self.array.count > indexPath.row) {
            vc.anchorId = self.array[indexPath.row].anchorId;
        }
        vc.hidesBottomBarWhenPushed = YES;
        [UIViewController.currentViewController.navigationController pushViewController:vc animated:YES];
    }
}

- (QYZYLiveMainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QYZYLiveMainViewModel alloc] init];
    }
    return _viewModel;
}

@end
