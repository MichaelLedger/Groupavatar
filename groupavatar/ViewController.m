//
//  ViewController.m
//  groupavatar
//
//  Created by Gavin on 15/2/13.
//  Copyright (c) 2015年 Gavin. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+maskClip.h"
#import "CustomShapeView.h"
#import "CornerView.h"
#import "MaskView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // section 1
    UIImage* rawimage = [UIImage imageNamed:@"0.jpg"];
    // star、anormal、hexagon
    UIImage* maskimge = [UIImage imageNamed:@"hexagon.png"];
    UIImage* clippedimg = [UIImage maskClipImage:rawimage withMaskImage:maskimge];
    
    UIImageView* imv0 = [[UIImageView alloc] initWithImage:clippedimg];
    [self.view addSubview:imv0];
    imv0.frame = CGRectMake(100, 40, 120, 120);
    
    // section 2
    NSMutableArray* marray = [NSMutableArray new];
    //QQ的多人聊天组头像（梅花状头像组）
    //在实际情况中，主要是针对3，4，5，6人头像进行绘制
    int randomNum = arc4random() % 4 + 3;//3、4、5、6
    for (int i = 0; i < randomNum; i++) {
        NSString* str = [NSString stringWithFormat:@"%d.jpg",i];
        UIImage* img = [UIImage imageNamed:str];
        [marray addObject:img];
    }
 
    NSArray* imageAry = [NSArray arrayWithArray:marray];
    UIImage *headImage = [UIImage mergeImages:imageAry];
   
    UIImageView* imv1 = [[UIImageView alloc] initWithImage:headImage];
    [self.view addSubview:imv1];
    imv1.frame = CGRectMake(100, 200, 120, 120);
    
    MaskView *mask = [[MaskView alloc] initWithFrame:CGRectMake(250, 360, 100, 100)];
    [self.view addSubview:mask];
    
    CustomShapeView *shapeView = [[CustomShapeView alloc] initWithFrame:CGRectMake(100, 360, 60, 60)];
    shapeView.backgroundColor = [UIColor orangeColor];
    shapeView.contentMode = UIViewContentModeRedraw;//每次设置或更改frame的时候自动调用drawRect，无需手动setNeedsDisplay
    [self.view addSubview:shapeView];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [shapeView addSubview:textLabel];
    
    textLabel.text = @"Londoners are under starter's orders as the city gets ready for the Olympic Games, which will begin one year today.To mark the start of the 366-day countdown (2012 is a leap year), special events are planned for today.The design of the Olympic medals will be unveiled tonight in a live ceremony from Trafalgar Square.Over at the brand new Aquatics Centre, Britain's star diver Tom Daley is going to perform an official launch dive into the Olympic pool.With this building, the organisers have attempted to give London a landmark to rival Beijing's Water Cube from 2008.It was designed by the prestigious architect Zaha Hadid and has a wave-like roof that is 160 metres long.Today's special events are designed to arouse interest in the Olympics around the world and to encourage British fans too.Many failed to get Olympic tickets in the recent sales process.According to a new survey for the BBC, 53% of Londoners think the process was \"not fair\".But the same survey found support is growing for London 2012. Of the 1,000 people surveyed, 73% said they backed the Games - up from 69% in 2006.Olympics minister Hugh Robertson said: \"We are under budget and ahead of time and as a nation we have a reputation of really getting behind these big events.";
    
    //Visual Format Language
    NSDictionary *metrics = @{@"m" : @10, @"h" : @20};
    NSDictionary *views = NSDictionaryOfVariableBindings(textLabel);
    
    NSString *vfl = @"H:|-m-[textLabel]-m-|";
    NSArray *constraint = [NSLayoutConstraint constraintsWithVisualFormat:vfl options:kNilOptions metrics:metrics views:views];
    [shapeView addConstraints:constraint];
    
    //Relation must be ==, >=, or <=
    NSString *vf2 = @"V:|-(>=m)-[textLabel(>=h)]-(>=m)-|";
    NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:vf2 options:kNilOptions metrics:metrics views:views];
    [shapeView addConstraints:constraint2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        shapeView.frame = CGRectMake(100, 360, 120, 120);
//        [shapeView setNeedsDisplay];
    });
    
    NSInteger maxColum = 8;
    NSInteger maxRow = 3;
    CGFloat radius = [UIScreen mainScreen].bounds.size.width * 1.0 / maxColum / 2;
    for (NSInteger i = 0; i < maxColum * maxRow; i ++) {
        NSInteger row = i / maxColum;
        NSInteger column = i % maxColum;
        CGRect frame = CGRectMake(0 + radius * 2 * column + radius * row,
                                  500 + radius * 2 * row - ((1 - (sqrtf(3) - 1)) * radius * row),
                                  radius * 2,
                                  radius * 2);
        //CornerView or MaskView
        MaskView *corner = [[MaskView alloc] initWithFrame:frame];
        corner.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1.0];
        
        CGFloat vertexWH = 3.f;
        for (NSInteger j = 0; j < 4; j ++) {
            NSInteger row2 = j / 2;
            NSInteger column2 = j % 2;
            UIView *vertex = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(corner.frame) - vertexWH) * column2, (CGRectGetHeight(corner.frame) - vertexWH) * row2, vertexWH, vertexWH)];
            vertex.backgroundColor = [UIColor redColor];
            [corner addSubview:vertex];
        }
        
        [self.view addSubview:corner];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
