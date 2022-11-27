//
//  QYZYMatchOverHeaderView.m
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import "QYZYMatchOverHeaderView.h"
#import <WebKit/WebKit.h>

@interface QYZYMatchOverHeaderView ()
@property (nonatomic ,strong) WKWebView *webView;
@end

@implementation QYZYMatchOverHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(60);
    }];
}

- (void)setDetailModel:(QYZYMatchMainModel *)detailModel {
    _detailModel = detailModel;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:detailModel.trendAnim]]];
}

#pragma mark - get
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[[WKWebViewConfiguration alloc] init]];
    }
    return _webView;
}

@end
