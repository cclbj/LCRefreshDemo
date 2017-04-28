//
//  ViewController.m
//  LCRefreshDemo
//
//  Created by lcc on 2017/4/28.
//  Copyright © 2017年 early bird international. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import <MJRefresh.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIImageView *topImg;

@property (nonatomic,assign) NSInteger rowNum;

@property (nonatomic,assign) BOOL isHidden;  //判断是否隐藏顶部视图的标志位

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUI];
}

- (void)setUI{

    [self.view addSubview:self.topImg];
    [self.view addSubview:self.tableView];
    
    [self.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(202);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.top.mas_equalTo(_topImg.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(0);
        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark- tableView delegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offsetY = scrollView.contentOffset.y;
    
    //偏移量在顶部image的高度以内
    if (offsetY <= 202 & offsetY > 0) {
        
        [self.topImg mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(-offsetY);
            
        }];

        
    }else if(offsetY > 202){ //大于顶部头部高度，固定顶部的高度
    
        if (self.topImg.frame.origin.y == -202) {
            
            return;
        }
        
        
        [self.topImg mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(-202);
            
        }];

    }else if(offsetY < 0){
    
        [self.topImg mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(0);
            
        }];
        
    }
    
    
}

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    if (contentOffsetY > 0) {
    
        //隐藏顶部img
        if (!self.isHidden) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                   
                    make.top.mas_equalTo(0);
                    
                }];
                
                [self.tableView layoutIfNeeded];
                
            }];
            
            self.isHidden = YES;

        }
        
        
    }else{
    
        
        //显示顶部img
        if (self.isHidden) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.mas_equalTo(202);
                    
                }];
                
                [self.tableView layoutIfNeeded];
                
            }];
            
            self.isHidden = NO;
        }
        
        
    }
    
    
    
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    
    cell.textLabel.text = @"我是cell";
    
    return cell;
}



#pragma -mark- lazy load

- (NSInteger)rowNum{

    if (!_rowNum) {
        _rowNum = 10;
    }
    
    return _rowNum;
}

- (UIImageView *)topImg{

    if (!_topImg) {
        _topImg = [UIImageView new];
        _topImg.contentMode = UIViewContentModeScaleAspectFill;
        _topImg.layer.masksToBounds = YES;
        _topImg.image = [UIImage imageNamed:@"timg.jpg"];
    }
    
    return _topImg;
}

- (UITableView *)tableView{

    if (!_tableView) {
        
        MJWeakSelf;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            weakSelf.rowNum = 10;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_tableView.mj_header endRefreshing];
            });
        }];
        
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
           
            weakSelf.rowNum += 10;
            [weakSelf.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf.tableView.mj_footer endRefreshing];
                
            });
            
            
        }];
        
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    
    
    return _tableView;
}


@end
