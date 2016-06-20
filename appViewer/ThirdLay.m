//
//  ThirdLay.m
//  appViewer
//
//  Created by JuZhen on 16/6/7.
//  Copyright © 2016年 JuZhen. All rights reserved.
//

#import "ThirdLay.h"
#include "DetailView.h"
#include "head.h"
@interface ThirdLay()<UITableViewDataSource,UITableViewDelegate>{
    double angle;
    double radius;
    double centerX;
    double centerY;
    double length;
}
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic, strong) UIButton * btn;
@property (nonatomic, strong) UIImageView * Person;

@property (nonatomic,strong) UIImageView * Base1;
@property (nonatomic,strong) UIImageView * Base2;
@property (nonatomic,strong) UIImageView * Base3;

@property (nonatomic,strong) UITableView * listView;
@end
@implementation ThirdLay
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBG"]];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*2)];
    self.scrollView.pagingEnabled=YES;
    self.scrollView.bounces=NO;
    self.scrollView.scrollEnabled=YES;
    [self.view addSubview:self.scrollView];
    
    angle=0;radius=100;centerX=SCREEN_WIDTH/2;centerY=SCREEN_HEIGHT/2;centerY=SCREEN_WIDTH/2;length=80;
    [self InitCircle];
    //[NSTimer scheuledTimerWithTimeInterval:1.0/60.0  target: self  selector:@selector(timerAdvanced:) userInfo:nil  repeats: YES];
    [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(timerAdvanced:) userInfo:nil repeats:YES];
    [self initListView];
    // Do any additional setup after loading the view.
}
-(void)initListView{
    self.listView=[[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT +50, SCREEN_WIDTH, SCREEN_HEIGHT-50) style:UITableViewStyleGrouped];
    self.listView.backgroundColor=[UIColor grayColor];
    self.listView.delegate=self;
    self.listView.dataSource=self;
    self.listView.alpha=0.9;
    [self.scrollView addSubview:self.listView];
}
-(void)timerAdvanced:(NSTimer * )timer
{
    angle += 0.005;
    [self.Base1 setCenter:CGPointMake(centerY+ cos(angle)* radius,centerY + sin(angle)* radius)];
    [self.Base2 setCenter:CGPointMake(centerY+ cos(angle+6.283/3)* radius,centerY + sin(angle+6.283/3)* radius)];
    [self.Base3 setCenter:CGPointMake(centerY+ cos(angle-6.283/3)* radius,centerY + sin(angle-6.283/3)* radius)];
}
-(void)InitCircle{
    self.Base1=[[UIImageView alloc] initWithFrame:CGRectMake(centerX-length/2 + cos(angle)* radius, centerY-length/2 + sin(angle)* radius, length, length)];
    self.Base2=[[UIImageView alloc] initWithFrame:CGRectMake(centerX-length/2 + cos(angle+6.283/3)* radius, centerY-length/2 + sin(angle+6.283/3)* radius, length, length)];
    self.Base3=[[UIImageView alloc] initWithFrame:CGRectMake(centerX-length/2 + cos(angle-6.283/3)* radius, centerY-length/2 + sin(angle-6.283/3)* radius, length, length)];
    [self.Base1 setImage:[UIImage imageNamed:@"feichuang"]];
    [self.Base2 setImage:[UIImage imageNamed:@"feichuang"]];
    [self.Base3 setImage:[UIImage imageNamed:@"feichuang"]];
    //[self.Base3 setImageWithURL:];
    
    self.Base1.userInteractionEnabled=YES;
    self.Base2.userInteractionEnabled=YES;
    self.Base3.userInteractionEnabled=YES;
    self.Base1.tag=1;
    self.Base2.tag=2;
    self.Base3.tag=3;
    
    UITapGestureRecognizer * singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bthClick:)];
    UITapGestureRecognizer * singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bthClick:)];
    UITapGestureRecognizer * singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bthClick:)];
    [self.Base1 addGestureRecognizer:singleTap1];
    [self.Base2 addGestureRecognizer:singleTap2];
    [self.Base3 addGestureRecognizer:singleTap3];
    
    [self.scrollView addSubview:self.Base1];
    [self.scrollView addSubview:self.Base2];
    [self.scrollView addSubview:self.Base3];
}
-(void) bthClick:(UITapGestureRecognizer *)tap
{
    DetailView * svc = [[DetailView alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    //cell.contentView.backgroundColor=[UIColor redColor];
    [cell.imageView setImage:[UIImage imageNamed:@"test"]];
    cell.textLabel.text=@"this is a XXX software";
    cell.detailTextLabel.text=@"这是一个xxx软件，我们在这个软件中出现了什么情况，这是一个xxx软件，我们在这个软件中出现了什么情况，这是一个xxx软件，我们在这个软件中出现了什么情况，这是一个xxx软件，我们在这个软件中出现了什么情况，";
    cell.imageView.alpha=1;
    cell.alpha=1;
    //cell.contentView.alpha=0;
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;

}
#pragma mark 返回每组头标题名称
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"dajiba";
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailView * svc = [[DetailView alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
