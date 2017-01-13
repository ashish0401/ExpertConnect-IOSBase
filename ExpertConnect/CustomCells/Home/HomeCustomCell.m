//
//  HomeCustomCell.m
//  ExpertConnectApp
//
//  Created by Nadeem on 02/11/16.
//  Copyright © 2016 user. All rights reserved.
//

#import "HomeCustomCell.h"


@implementation HomeCustomCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bottomBorder = [CALayer layer];
    _bottomBorder.frame = CGRectMake(0.0f, self.lineLabel.frame.size.height-2,self.lineLabel.frame.size.width, 1.0f);
//    _bottomBorder.backgroundColor = Rgb2UIColor(247.0, 67.0, 0.0).CGColor;
    _bottomBorder.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:(242/255.0) green:(90/255.0) blue:(11/255.0) alpha:1.0]);
    [self.lineLabel.layer addSublayer:_bottomBorder];
    
    _sideBorder = [CALayer layer];
    _sideBorder.frame = CGRectMake(0.0, 0.0f,1.0f, 100.0f);
//    _sideBorder.backgroundColor = Rgb2UIColor(247.0, 67.0, 0.0).CGColor;
    _bottomBorder.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:(242/255.0) green:(90/255.0) blue:(11/255.0) alpha:1.0]);
    [self.lineVerticalLabel.layer addSublayer:_sideBorder];
}

@end
