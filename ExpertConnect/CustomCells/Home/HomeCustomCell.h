//
//  HomeCustomCell.h
//  ExpertConnectApp
//
//  Created by Nadeem on 02/11/16.
//  Copyright © 2016 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCustomCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lineLabel;
@property (strong, nonatomic) IBOutlet UILabel *lineVerticalLabel;




@property(nonatomic,strong) CALayer *bottomBorder;
@property(nonatomic,strong) CALayer *sideBorder;
@end
