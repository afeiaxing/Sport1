//
//  QYZYLiveHomeViewController.m
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import "QYZYLiveHomeViewController.h"
#import "QYZYLiveDetailViewController.h"
#import "QYZYLiveMainViewModel.h"
#import "QYZYLiveCell.h"
#import "QYZYCollectionEmptyCell.h"

@interface QYZYLiveHomeViewController ()<UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) void (^callBack)(UIScrollView *);
@property (nonatomic ,strong) QYZYLiveMainViewModel *viewModel;
@property (nonatomic ,strong) NSArray <QYZYLiveListModel *> *liveArray;

@end

@implementation QYZYLiveHomeViewController

- (UIView *)listView {
    return self.view;
}
 
- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.callBack = callback;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    [self requestLiveList];
}

- (void)setupSubViews {
    [self.collectionView registerNib:[UINib nibWithNibName:@"QYZYLiveCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(QYZYLiveCell.class)];
    [self.collectionView registerClass:QYZYCollectionEmptyCell.class forCellWithReuseIdentifier:NSStringFromClass(QYZYCollectionEmptyCell.class)];
    self.collectionView.contentInset = UIEdgeInsetsMake(8, 0, TabBarHeight, 0);
}

- (void)requestLiveList {
    weakSelf(self);
    [self.viewModel requestLiveListWithLiveGroupId:self.liveGroupId completion:^(NSArray<QYZYLiveListModel *> * _Nonnull liveArray, NSString * _Nonnull msg) {
        strongSelf(self);
        if (!msg) {
            self.liveArray = liveArray;
            [self.collectionView reloadData];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.callBack ? : self.callBack(scrollView);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.liveArray.count) {
        QYZYLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QYZYLiveCell.class) forIndexPath:indexPath];
        if (self.liveArray.count > indexPath.row) {
            cell.listModel = self.liveArray[indexPath.row];
        }
        return cell;
    }
    else {
        QYZYCollectionEmptyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QYZYCollectionEmptyCell.class) forIndexPath:indexPath];
        [cell updateWithTop:100];
        return cell;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.liveArray.count ? self.liveArray.count : 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.liveArray.count) {
        QYZYLiveDetailViewController *vc = [QYZYLiveDetailViewController new];
        if (self.liveArray.count > indexPath.row) {
            vc.anchorId = self.liveArray[indexPath.row].anchorId;
        }
        vc.hidesBottomBarWhenPushed = YES;
        [UIViewController.currentViewController.navigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.liveArray.count > 0) {
        CGFloat itemSpace = 12;
        CGFloat width = (ScreenWidth - itemSpace*3)*0.5;
        CGFloat height = 170;
        return CGSizeMake(width, height);
    }
    else {
        return CGSizeMake(ScreenWidth, ScreenHeight - NavigationContentTop - TabBarHeight - 44);
//        return CGSizeMake(self.view.frame.size.width, ScreenHeight - 320 - 48 - StatusBarHeight - SafeAreaInsetsConstantForDeviceWithNotch.bottom );
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 0, 12);
}

- (QYZYLiveMainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QYZYLiveMainViewModel alloc] init];
    }
    return _viewModel;
}

@end
