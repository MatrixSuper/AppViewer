//
//  DetailView.m
//  appViewer
//
//  Created by JuZhen on 16/6/7.
//  Copyright © 2016年 JuZhen. All rights reserved.
//

#import "DetailView.h"
#import "head.h"
@interface DetailView()<UIScrollViewDelegate>{
    int viewPage;
    NSMutableDictionary * infDic;
    NSArray * infArr;
}
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UILabel* showHintLabel;
@end
@implementation DetailView
-(void)viewDidLoad{
    [super viewDidLoad];
    infDic = [NSMutableDictionary new];
    NSMutableDictionary * requestDic=[NSMutableDictionary new];
    requestDic[@"offset"]=[NSNumber numberWithInt:0];
    requestDic[@"limit"]=[NSNumber numberWithInt:10];
    requestDic[@"entryID"]=[NSNumber numberWithInt:40];
    [self post:requestDic];
    [HttpHelper get:[NSString stringWithFormat:@"%@%@",AppViewUrl,@"getEntrySubs.action"] params:requestDic success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        infDic=responseObj;
        infArr = infDic[@"result"];
        [self InitScrollView:(int)infArr.count];
        [self InitTopView:(int)infArr.count];
    } failure:^(NSError *error) {
        
    }];
    self.view.backgroundColor=[UIColor grayColor];
}
-(void)InitScrollView:(int)num{
    
    viewPage = 0;
    self.scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT-200)];
    [self.scrollView setContentSize:CGSizeMake(num*SCREEN_WIDTH,0)];
    self.scrollView.pagingEnabled=YES;
    //self.scrollView.bounces=NO;
    self.scrollView.scrollEnabled=YES;
    self.scrollView.backgroundColor=[UIColor whiteColor];
    self.scrollView.alwaysBounceHorizontal=YES;
    self.scrollView.delegate=self;
    for(int i = 0 ; i < infArr.count ;i++){
        [self InitDetailVersion:i withDic:infArr[i]];
    }
    [self.view addSubview:self.scrollView];
}
-(void)InitDetailVersion:(int)num withDic: (NSDictionary *) dic{
    UIScrollView * subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*num, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200)];
    NSArray * imgArr = dic[@"picList"];
    subScrollView.contentSize=CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*imgArr.count);
    for(int i = 0 ; i < imgArr.count ; i++){
        UIImageView * detailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        NSString * imgStr =@"http://139.196.56.202:8080/picture/payment/game/relax/Cut the Rope/1.4.0/IMG_1364.PNG";
//        imgStr=[imgStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [Person setImageWithURL:[NSURL URLWithString:imgStr]];
        NSString * imgStr = [NSString stringWithFormat:@"%@%@",@"http://139.196.56.202:8080/",imgArr[i]];//imgArr[i];
        imgStr=[imgStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [detailImageView setImageWithURL:[NSURL URLWithString:imgStr]];
        [subScrollView addSubview:detailImageView];
    }
    [self.scrollView addSubview:subScrollView];
}
-(void)InitTopView:(int)num{
    self.showHintLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 70, 140, 140, 40)];
    self.showHintLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:self.showHintLabel];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    self.showHintLabel.text=[numberFormatter stringFromNumber:0];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int num = (int)(scrollView.contentOffset.x/SCREEN_WIDTH);
    NSLog(@"%d",num);
    
    if(num != viewPage){
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString* versonNumber = [numberFormatter stringFromNumber:[NSNumber numberWithInt:num]];
        self.showHintLabel.text = infArr[num][@"version"];//[NSString stringWithFormat:@"%@%@",@"version",versonNumber];
//        [self.ImgNumView[viewPage] setImage:self.ImgNumPic[viewPage]];
//        [self.ImgNumView[num] setImage:self.ImgNumPicSelected[num]];
//        [self.ImgNumView[viewPage] setBackgroundColor:[UIColor blackColor]];
//        [self.ImgNumView[num] setBackgroundColor:[UIColor redColor]];
        viewPage = num;
    }
}

- (void)post:(NSDictionary *)dic {
    NSString *str = [NSString stringWithFormat:@"%@%@",AppViewUrl,@"getEntrySubs.action"];
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    [request setValue:[ud objectForKey:@"deviceId"] forHTTPHeaderField:@"uuid"];
//    [request setValue:[ud objectForKey:@"token"] forHTTPHeaderField:@"token"];
//    if((![action isEqual:@"User/Login.action"])  && (![action  isEqual: @"User/Register.action"])&& (![action  isEqual: @"User/Register.action"])){
//        [request setValue:[ud objectForKey:@"userId"] forHTTPHeaderField:@"userId"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    if([action isEqual:@"Query/FriendsInfo/List.action"]){
    //
    //    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"%@",dic);
    request.HTTPBody = data;
    //NSLog(@"%@", request);;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",request);
    }];
}
@end
