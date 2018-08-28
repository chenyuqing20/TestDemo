//
//  DBViewController.m
//  test
//
//  Created by 盒子 on 2018/6/21.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import "DBViewController.h"
#import "Masonry.h"

@interface DBViewController ()
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UITextField *ageTextField;
@end

@implementation DBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WCDB";
}

- (void)setupSubviews {
    _nameTextField = [[UITextField alloc] init];
    [self.view addSubview:_nameTextField];
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    _ageTextField = [[UITextField alloc] init];
    [self.view addSubview:_ageTextField];
    [_ageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.nameTextField);
        make.top.equalTo(self.nameTextField.mas_bottom).offset(10);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
