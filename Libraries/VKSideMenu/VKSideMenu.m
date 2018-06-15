//
//  VKSideMenu.m
//  Version: 1.1
//
//  Created by Vladislav Kovalyov on 2/7/16.
//  Copyright © 2016 WOOPSS.com (http://woopss.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "VKSideMenu.h"
#import "SlideMenuFirstCell.h"
#import "SlideMenuCustomCell.h"

#define kBorderWidth 2.0
#define kCornerRadius 8.0

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define ROOTVC [[[[UIApplication sharedApplication] delegate] window] rootViewController]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation VKSideMenuItem

@synthesize icon;
@synthesize title;
@synthesize tag;

@end

@interface VKSideMenu() <UITableViewDelegate, UITableViewDataSource>
{
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic, strong) UIView *overlay;

@end

@implementation VKSideMenu

#pragma mark - Initialization

-(instancetype)init
{
    if (self = [super init])
    {
        [self baseInit];
    }
    
    return self;
}

-(instancetype)initWithDirection:(VKSideMenuDirection)direction
{
    if (self = [super init])
    {
        [self baseInit];
        
        self.direction  = direction;
    }
    
    return self;
}

-(instancetype)initWithSize:(CGFloat)size andDirection:(VKSideMenuDirection)direction
{
    if (self = [super init])
    {
        [self baseInit];
        
        self.size       = size;
        self.direction  = direction;
    }
    
    return self;
}

-(void)baseInit
{
    self.size                       = 220;
    self.direction                  = VKSideMenuDirectionFromLeft;
    self.rowHeight                  = 50;
    self.enableOverlay              = YES;
    self.automaticallyDeselectRow   = YES;
    self.hideOnSelection            = YES;
    self.enableGestures             = YES;
    
    self.sectionTitleFont   = [UIFont systemFontOfSize:15.];
    //    self.selectionColor     = [UIColor colorWithWhite:1. alpha:.5];
    //    self.selectionColor     = Rgb2UIColor(253.0, 166.0, 127.0);
    self.selectionColor = [UIColor colorWithRed:253/255.0 green:166/255.0 blue:127/255.0 alpha:1.0];
    //    self.selectionColor = [UIColor lightGrayColor];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //    self.backgroundColor    = [UIColor colorWithWhite:1. alpha:.8];
    //    self.backgroundColor    = Rgb2UIColor(247.0, 67.0, 0.0);
    self.backgroundColor = [UIColor colorWithRed:247/255.0 green:67/255.0 blue:0/255.0 alpha:1.0];
    //    self.backgroundColor    = [UIColor redColor];
    
#pragma clang diagnostic pop
    //    self.textColor          = UIColorFromRGB(0x252525);
    //    self.iconsColor         = UIColorFromRGB(0x8f8f8f);
    //    self.sectionTitleColor  = UIColorFromRGB(0x8f8f8f);
    
    self.textColor          = [UIColor whiteColor];
    //    self.iconsColor         = UIColorFromRGB(0x8f8f8f);
    //    self.sectionTitleColor  = UIColorFromRGB(0x8f8f8f);
    
    if(!SYSTEM_VERSION_LESS_THAN(@"8.0"))
        self.blurEffectStyle = UIBlurEffectStyleExtraLight;
    
    UINib * cellNib = [UINib nibWithNibName:@"SlideMenuFirstCell" bundle:nil];
    UINib * cellNib2 = [UINib nibWithNibName:@"SlideMenuCustomCell" bundle:nil];
    
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"SlideMenuFirstCell"];
    [self.tableView registerNib:cellNib2 forCellReuseIdentifier:@"SlideMenuCustomCell"];
}

-(void)initViews
{
    // Setup overlay
    self.overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlay.alpha = 0;
    self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (self.enableOverlay)
        self.overlay.backgroundColor = [UIColor clearColor];
    
    // Setup gestures
    if (self.enableGestures)
    {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [self.overlay addGestureRecognizer:tapGesture];
    }
    
    //     Setup frame before show
    
    //    if (self.direction == VKSideMenuDirectionFromTop || self.direction == VKSideMenuDirectionFromBottom)
    //    {
    //        // Calculate table view height for vertical directions (fromTop and fromBottom)
    //        self.tableViewHeight = 20;
    //        NSInteger numberOfSections = [self.dataSource numberOfSectionsInSideMenu:self];
    //
    //        for (int section; section < numberOfSections; section++)
    //        {
    //            self.tableViewHeight += [self.dataSource sideMenu:self numberOfRowsInSection:section] * self.rowHeight;
    //
    //            if ([self.delegate sideMenu:self titleForHeaderInSection:section].length > 0)
    //                self.tableViewHeight += [self.tableView sectionHeaderHeight];
    //        }
    //    }
    
    CGRect frame = [self frameHidden];
    
    if(SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        self.view = [[UIView alloc] initWithFrame:frame];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.view.backgroundColor = self.backgroundColor;
#pragma clang diagnostic pop
    }
    else
    {
//        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
//        self.view = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.view = [[UIView alloc] initWithFrame:frame];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.view.backgroundColor = self.backgroundColor;
#pragma clang diagnostic pop
    }
    
    // Setup content table view
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.separatorColor   = [UIColor clearColor];
    //    self.tableView.backgroundColor  = [UIColor clearColor];
    //    self.tableView.backgroundColor = Rgb2UIColor(247.0, 67.0, 0.0);
    self.tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:90/255.0 blue:11/255.0 alpha:0.9];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"UserLoggedInStatus"])
    {
        self.tableView.scrollEnabled = NO;
    }

    [self.view addSubview:self.tableView];
}

#pragma mark - Appearance

-(void)show
{
    [self initViews];
    
    [ROOTVC.view addSubview:self.overlay];
    [ROOTVC.view addSubview:self.view];
    
    CGRect frame = [self frameShowed];
    
    [UIView animateWithDuration:0.275 animations:^
     {
         self.view.frame = frame;
         self.overlay.alpha = 1.0;
     }
                     completion:^(BOOL finished)
     {
         if (_delegate && [_delegate respondsToSelector:@selector(sideMenuDidShow:)])
             [_delegate sideMenuDidShow:self];
     }];
}

-(void)showWithSize:(CGFloat)size
{
    self.size = size;
    [self show];
}

-(void)hide
{
    [UIView animateWithDuration:0.275 animations:^
     {
         self.view.frame = [self frameHidden];
         self.overlay.alpha = 0.;
     }
                     completion:^(BOOL finished)
     {
         if (_delegate && [_delegate respondsToSelector:@selector(sideMenuDidHide:)])
             [_delegate sideMenuDidHide:self];
         
         [self.view removeFromSuperview];
         [self.overlay removeFromSuperview];
         [self.overlay removeGestureRecognizer:tapGesture];
         
         self.overlay = nil;
         self.tableView = nil;
         self.view = nil;
     }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource numberOfSectionsInSideMenu:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource sideMenu:self numberOfRowsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UIImageView *imageViewIcon;
    UILabel *title;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:self.selectionColor];
        [cell setSelectedBackgroundView:bgColorView];
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"UserLoggedInStatus"])
        {
            if(indexPath.row == 0 || indexPath.row == 2)
            {
                cell.userInteractionEnabled = NO;
            }
//            if(indexPath.row == 2)
//            {
//                UIView *bgColorView = [[UIView alloc] init];
//                [bgColorView setBackgroundColor:self.selectionColor];
//                [cell setSelectedBackgroundView:bgColorView];
//                cell.backgroundColor = [UIColor colorWithRed:146/255.0 green:53/255.0 blue:5/255.0 alpha:1.0];
//            }
        }
        else
        {
            cell.userInteractionEnabled = YES;
        }
    }
    
    VKSideMenuItem *item = [self.dataSource sideMenu:self itemForRowAtIndexPath:indexPath];
    
    CGFloat contentHeight = cell.frame.size.height * .8;
    CGFloat contentTopBottomPadding = cell.frame.size.height * .1;
    
    if (item.icon)
    {
        
        imageViewIcon = [cell.contentView viewWithTag:100];
        if (!imageViewIcon)
        {
            if (indexPath.row ==0) {
                imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, contentTopBottomPadding, contentHeight+45, contentHeight+45)];
                [imageViewIcon.layer setCornerRadius: imageViewIcon.frame.size.height/2];
                [imageViewIcon.layer setBorderWidth:kBorderWidth];
                [imageViewIcon.layer setBorderColor:[[UIColor colorWithRed:154/255.0 green:55/255.0 blue:04/255.0 alpha:1.0] CGColor]];
                imageViewIcon.clipsToBounds = YES;
            }
            else if (indexPath.row !=0)
            {
                imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, contentTopBottomPadding+5, contentHeight-10, contentHeight-10)];
                [imageViewIcon setContentMode:UIViewContentModeScaleAspectFit];
            }
            
            imageViewIcon.tag = 100;
            [cell.contentView addSubview:imageViewIcon];
        }
        
        imageViewIcon.image = item.icon;

        if (self.iconsColor)
        {
            imageViewIcon.image = [imageViewIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            //            imageViewIcon.tintColor = self.iconsColor;
        }
    }
    
    title = [cell.contentView viewWithTag:200];
    
    if (!title)
    {
        
        if (indexPath.row ==0) {
            CGFloat titleX = item.icon ? CGRectGetMaxX(imageViewIcon.frame) + 12 : 12;
            title = [[UILabel alloc] initWithFrame:CGRectMake(20, contentTopBottomPadding+75, self.size - 25, contentHeight+10)];

            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 132, self.view.bounds.size.width, 1)];
            lineView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:lineView];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"UserLoggedInStatus"])
            {
            [cell.contentView addSubview:[self addButton:nil : CGRectMake(self.size - 44, contentTopBottomPadding, 44, 44) :@selector(btnAction:) :[UIImage imageNamed:@"sidemenu_edit_btn"] :indexPath]];
            }
            else
            {
                UILabel *logoLabelTop = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)-(contentHeight+133)/2, contentTopBottomPadding, contentHeight+133, contentHeight+49)];
                [logoLabelTop setNumberOfLines:1
                 ];
                logoLabelTop.textAlignment = NSTextAlignmentCenter;
                [logoLabelTop setFont:[UIFont fontWithName:@"01 Digitall" size:29]];
                [logoLabelTop setTextColor:[UIColor whiteColor]];
                [logoLabelTop setText:@"EXPERT"];
                [cell.contentView addSubview:logoLabelTop];
                
                UILabel *logoLabelBottom = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)-(contentHeight+133)/2, contentTopBottomPadding+25, contentHeight+133, contentHeight+49)];
                [logoLabelBottom setNumberOfLines:1
                 ];
                logoLabelBottom.textAlignment = NSTextAlignmentCenter;
                [logoLabelBottom setFont:[UIFont fontWithName:@"01 Digitall" size:29]];
                [logoLabelBottom setTextColor:[UIColor whiteColor]];
                [logoLabelBottom setText:@"CONNECT"];
                [cell.contentView addSubview:logoLabelBottom];
            }
            
            [title setFont:[UIFont fontWithName:@"Raleway-Medium" size:18]];
        }
        else if (indexPath.row !=0)
        {
            CGFloat titleX = item.icon ? CGRectGetMaxX(imageViewIcon.frame) + 12 : 12;
            title = [[UILabel alloc] initWithFrame:CGRectMake(titleX+10, contentTopBottomPadding, cell.frame.size.width - titleX - 12, contentHeight)];
            [title setFont:[UIFont fontWithName:@"Raleway-Light" size:17]];

        }
        title.tag  = 200;
        //title.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:title];

    }
    
    //title.adjustsFontSizeToFitWidth = YES;

    title.text      = item.title;
    title.textColor = self.textColor;
    
    return cell;
}
    
-(UIButton *)addButton:(NSString *)title :(CGRect)frame : (SEL)selector :(UIImage *)image :(NSIndexPath *)indexPath
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.tag = indexPath.row;
    return btn;
}

-(void)btnAction:(UIButton *) sender
{
     NSLog(@"button clicked");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];

    if (_delegate && [_delegate respondsToSelector:@selector(sideMenu:didSelectRowAtIndexPath:)])
    [_delegate sideMenu:self didSelectRowAtIndexPath:indexPath];
    
    if (self.automaticallyDeselectRow)
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.hideOnSelection)
    [self hide];
}
    
#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"UserLoggedInStatus"])
    {
      if(indexPath.row == 0)
      {
          return;
      }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(sideMenu:didSelectRowAtIndexPath:)])
        [_delegate sideMenu:self didSelectRowAtIndexPath:indexPath];
    
    if (self.automaticallyDeselectRow)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.hideOnSelection)
        [self hide];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 140;
    }
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"UserLoggedInStatus"])
    {
        if (indexPath.row == 1) {
//            return self.view.frame.size.height-(self.rowHeight+125+self.rowHeight);
        }
    }
    return self.rowHeight;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideMenu:titleForHeaderInSection:)])
        return [self.delegate sideMenu:self titleForHeaderInSection:section].uppercaseString;
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    //    [header.textLabel setTextColor:self.sectionTitleColor];
    [header.textLabel setFont:self.sectionTitleFont];
}

#pragma mark - GestureRecognition

-(void)addSwipeGestureRecognition:(UIView *)view
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwap:)];
    
    switch (self.direction)
    {
        case VKSideMenuDirectionFromTop:
            swipe.direction = UISwipeGestureRecognizerDirectionDown;
            break;
            
        case VKSideMenuDirectionFromLeft:
            swipe.direction = UISwipeGestureRecognizerDirectionRight;
            break;
            
            
        case VKSideMenuDirectionFromBottom:
            swipe.direction = UISwipeGestureRecognizerDirectionUp;
            break;
            
            
        case VKSideMenuDirectionFromRight:
            swipe.direction = UISwipeGestureRecognizerDirectionLeft;
            break;
    }
    
    [view addGestureRecognizer:swipe];
}

-(void)didTap:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
        [self hide];
}

-(void)didSwap:(UISwipeGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded && self.enableGestures)
        [self showWithSize:self.size];
}

#pragma mark - Helpers

-(CGRect)frameHidden
{
    CGRect frame = CGRectZero;
    
    switch (self.direction)
    {
        case VKSideMenuDirectionFromTop:
            frame = CGRectMake(0, -self.size, [UIScreen mainScreen].bounds.size.width, self.size);
            break;
            
        case VKSideMenuDirectionFromLeft:
            frame = CGRectMake(-self.size, 0, self.size, [UIScreen mainScreen].bounds.size.height);
            break;
            
        case VKSideMenuDirectionFromBottom:
            frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.size);
            break;
            
        case VKSideMenuDirectionFromRight:
            frame = CGRectMake([UIScreen mainScreen].bounds.size.width + self.size, 0, self.size, [UIScreen mainScreen].bounds.size.height);
            break;
    }
    
    return frame;
}

-(CGRect)frameShowed
{
    CGRect frame = self.view.frame;
    
    switch (self.direction)
    {
        case VKSideMenuDirectionFromTop:
            frame.origin.y = 0;
            break;
            
        case VKSideMenuDirectionFromLeft:
            frame.origin.x = 0;
            break;
            
        case VKSideMenuDirectionFromBottom:
            frame.origin.y = [UIScreen mainScreen].bounds.size.height - self.size;
            break;
            
        case VKSideMenuDirectionFromRight:
            frame.origin.x = [UIScreen mainScreen].bounds.size.width - self.size;
            break;
    }
    
    return frame;
}

@end
