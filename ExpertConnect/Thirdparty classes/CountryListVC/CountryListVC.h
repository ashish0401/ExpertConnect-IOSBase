//
//  CountryListVC.h
//  ExpertConnectApp
//
//  Created by Nadeem on 21/10/16.
//  Copyright © 2016 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryListCell.h"
@protocol CountryListVCDelegate<NSObject>
@optional
-(void)getCountryCode:(NSString*)dialingCode WithCountryName:(NSString*)CountryName;

@end

@class SignUpVC;

@interface CountryListVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, unsafe_unretained) id<CountryListVCDelegate> delegate;

@end
