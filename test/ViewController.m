//
//  ViewController.m
//  test
//
//  Created by 盒子 on 2018/6/1.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "ViewController.h"
#import "TableController.h"
#import "Masonry.h"
#import "DemoViewController.h"
#import "WKWebViewController.h"
#import "WebViewController.h"
#import "TimerShaftController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *dataList;
@end

@implementation ViewController
- (void)injected {
    NSLog(@"injected -- ");
//    self.tableView.backgroundColor = [UIColor redColor];
//    UITableViewCell *cell = [self.tableView visibleCells][0] ;
//    cell.backgroundColor = [UIColor blueColor];
//    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _dataList = @[@"Banner",@"Alert",@"TableCell删除",@"旋转",@"Y轴翻转",@"x轴翻转",@"放大",@"弹出",@"Masonry等间距排列",@"WKWevView",@"UIWebView",@"TimerShaft"];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(self.view.bounds.size);
    }];
    
//    UITextField *tx = [UITextField new];
//    tx.placeholder
    
    
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld项 %@",(long)indexPath.row,_dataList[indexPath.row]];
    cell.textLabel.font = [UIFont fontWithName:@"Plumb" size:20];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case kVC_CellDel:{
            TableController *tc = [[TableController alloc] init];
            [self.navigationController pushViewController:tc animated:YES];
        }
            break;
        case kVC_WKWeb:{
            WKWebViewController *wkvc = [[WKWebViewController alloc] init];
            [self.navigationController pushViewController:wkvc animated:YES];
        }
            break;
        case kVC_UIWeb:{
            WebViewController *wvc = [[WebViewController alloc] init];
            [self.navigationController pushViewController:wvc animated:YES];
        }
            break;
        case kVC_TimerShaft: {
            TimerShaftController *tvc = [[TimerShaftController alloc] init];
            [self.navigationController pushViewController:tvc animated:YES];
        }
            break;
        default:{
            DemoViewController *v = [[DemoViewController alloc] init];
            v.type = indexPath.row;
            [self.navigationController pushViewController:v animated:YES];
        }
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
