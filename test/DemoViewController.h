//
//  DemoViewController.h
//  test
//
//  Created by 盒子 on 2018/6/12.
//  Copyright © 2018年 盒子. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,kVCType) {
    kVC_Banner ,
    kVC_Alert ,
    kVC_CellDel ,
    kVC_Animation_Z ,
    kVC_Animation_Y ,
    kVC_Animation_X ,
    kVC_Animation_Scale ,
    kVC_Animation_Jump ,
    kVC_AutoItem ,
    kVC_WKWeb ,
    kVC_UIWeb ,
    kVC_TimerShaft ,
};

@interface DemoViewController : UIViewController

@property (nonatomic,assign) kVCType type;
@end
