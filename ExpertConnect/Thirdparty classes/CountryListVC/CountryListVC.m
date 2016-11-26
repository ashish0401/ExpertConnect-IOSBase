//
//  CountryListVC.m
//  ExpertConnectApp
//
//  Created by Nadeem on 21/10/16.
//  Copyright © 2016 user. All rights reserved.
//

#import "CountryListVC.h"


@interface CountryListVC ()
{
    NSArray *countryCodeArray;
    NSMutableArray *searchResultsArray;
}
@end

@implementation CountryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.searchBar.delegate = self;
    
    countryCodeArray =[[NSArray alloc]init];
    searchResultsArray=[[NSMutableArray alloc]init];
    self.searchBar.enablesReturnKeyAutomatically=NO;
}
-(void) viewWillAppear:(BOOL)animated
{
//    self.navigationItem.hidesBackButton = YES;
    [self addLabelOnNavigationBar];
    [self addBackButtonOnNavigationBar];
    
    [self getDialingCodeFromLocalJson];
}
-(void)addLabelOnNavigationBar
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 320, 40)];
    [titleLabel setText:@"Select Country Code"];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
//    [titleLabel setTextColor:Rgb2UIColor(247.0, 67.0, 0.0)];
    [titleLabel setTextColor:
     [UIColor colorWithRed:(247/255.0) green:(67/255.0) blue:(0/255.0) alpha:1.0]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
//    titleLabel.font = [UIFont fontWithName:@"Budmo" size:50];
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:titleLabel];
}
-(void)addBackButtonOnNavigationBar
{
    UIButton  *settingsButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 5, 30, 30)];
    settingsButton.backgroundColor = [UIColor clearColor];
    
    [settingsButton setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
//    [settingsButton setTitle:@"Back" forState:UIControlStateNormal];
//    [settingsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * view2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [view2 setBackgroundColor:[UIColor clearColor]];
    [view2 addSubview:settingsButton];
    
    UIBarButtonItem *rightbuttonItem2 = [[UIBarButtonItem alloc] initWithCustomView:view2];
    NSArray * barItems = [[NSArray alloc]initWithObjects:rightbuttonItem2, nil];
    
    
    [self.navigationItem setLeftBarButtonItems:barItems];
}
-(void)backButtonAction
{
    
    [self.navigationController popViewControllerAnimated:NO];
    
}
-(void)getDialingCodeFromLocalJson
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CountryCode" ofType:@"json"];
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    countryCodeArray=[jsonDictionary objectForKey:@"countries"];
    [self.tableview reloadData];
}
# pragma mark tableview datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchBar.text.length!=0) {
        return   [searchResultsArray count];
    }
    else
        return [countryCodeArray count];
    
}

# pragma mark tableview delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
//    static NSString *cellIdentifier=@"CountryListCell";
//    
//    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if(cell==nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    UIImageView *flagImageView= (UIImageView*)[cell.contentView viewWithTag:101];
//    UILabel *countryNameLabel= (UILabel*)[cell.contentView viewWithTag:102];
//    UILabel *dialingCodeLabel= (UILabel*)[cell.contentView viewWithTag:103];
    
    CountryListCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"CountryListCell"];
    if (cell==nil)
    {
        NSArray * nib = [[NSBundle mainBundle]loadNibNamed:@"CountryListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary* countryDictionary;
    if (self.searchBar.text.length==0) {
//        if(indexPath.row==0)
//        {
        
//            countryNameLabel.text=  UDString(@"Country");
//            dialingCodeLabel.text=UDString(@"CountryCode");
//            cell.backgroundView=[[UIImageView alloc] initWithImage: [UIImage imageNamed:@""]];
//            flagImageView.image=[UIImage imageNamed:[countryNameLabel.text lowercaseString]];
//            cell.backgroundView.backgroundColor=REGISTERBUTTON_TEXT_COLOR;
//            [cell.countryNameLabel setFont:[UIFont systemFontOfSize:17]];
//            cell.countryNameLabel.text = [NSString stringWithFormat:@"Country Name"];
//            cell.countryCodeLabel.text = [NSString stringWithFormat:@"Country Code"];
//        }
//        else
//        {
            countryDictionary=countryCodeArray[indexPath.row];
            cell.backgroundView.backgroundColor=[UIColor clearColor];
//            flagImageView.image=[UIImage imageNamed:[[countryDictionary objectForKey:@"name"]lowercaseString]];
            cell.countryNameLabel.text=[countryDictionary objectForKey:@"name"];
            NSString *codeString = [NSString stringWithFormat:@"%@",[countryDictionary objectForKey:@"dial_code"]];
            cell.countryCodeLabel.text= codeString;
            cell.imageView.image = [UIImage imageNamed:[[countryDictionary objectForKey:@"name"]lowercaseString]];
//            cell.backgroundView=[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"settings_bg"]];
//        }
    }
    else{
        countryDictionary=searchResultsArray[indexPath.row];
        cell.backgroundView.backgroundColor=[UIColor clearColor];
//        flagImageView.image=[UIImage imageNamed:[[countryDictionary objectForKey:@"name"]lowercaseString]];
        cell.countryNameLabel.text=[NSString stringWithFormat:@"%@",[countryDictionary objectForKey:@"name"]];
        NSString *codeString = [NSString stringWithFormat:@"%@",[countryDictionary objectForKey:@"dial_code"]];
        cell.countryCodeLabel.text=codeString;
        cell.imageView.image = [UIImage imageNamed:[[countryDictionary objectForKey:@"name"]lowercaseString]];
//        cell.backgroundView=[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"settings_bg"]];
    }
//    countryNameLabel.font=MEDIUM_FONT;
//    dialingCodeLabel.font=SMALL_SIZE_FONT;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchBar.text.length==0) {
        if([[self delegate] respondsToSelector:@selector(getCountryCode:WithCountryName:)]) // Pass the country code and dial code to the delegate
        {
            int indexValue=(int)indexPath.row;
//            UDSetObject(@"Country",[countryCodeArray[indexValue]objectForKey:@"name"]);
//            UDSetObject(@"CountryCode",[countryCodeArray[indexValue]objectForKey:@"dial_code"]);
//            UDSync();
            
            //send the delegate function with the country selected by the user
            [_delegate getCountryCode:[countryCodeArray[indexValue]objectForKey:@"dial_code"] WithCountryName:[countryCodeArray[indexValue]objectForKey:@"name"]];
        }
//        SignUpVC *obj;
//        obj.countryCode =
        int indexValue=(int)indexPath.row;
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",[countryCodeArray[indexValue]objectForKey:@"dial_code"]] forKey:@"countryCode"];
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        if([[self delegate] respondsToSelector:@selector(getCountryCode:WithCountryName:)])
        {
            int indexValue=(int)indexPath.row;
//            UDSetObject(@"Country",[searchResultsArray[indexValue]objectForKey:@"name"]);
//            UDSetObject(@"CountryCode",[searchResultsArray[indexValue]objectForKey:@"dial_code"]);
//            UDSync();
            
            //send the delegate function with the country selected by the user
            
            [_delegate getCountryCode:[searchResultsArray[indexValue]objectForKey:@"dial_code"] WithCountryName:[searchResultsArray[indexValue]objectForKey:@"name"]];
        }
        int indexValue=(int)indexPath.row;
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",[searchResultsArray[indexValue]objectForKey:@"dial_code"]] forKey:@"countryCode"];
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark Search Countries
-(void) searchCountry {
    
    // if search bar contains any text
    if (self.searchBar.text.length!=0) {
        [searchResultsArray removeAllObjects];
        for (NSDictionary *countryDict in countryCodeArray) { // iterate through the Country array
            //Check if the search string is a number or alphabet and search for dial code if nuumber and country name if alphabet
            NSString *country=([self.searchBar.text rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound)?countryDict[@"dial_code"]: countryDict[@"name"];
            if ([country containsString:self.searchBar.text]) {  // compare the two strings
                [searchResultsArray addObject:countryDict];        // they match so
            }
        }
        [self.tableview reloadData];
    }
}
#pragma mark SearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchCountry];
    [self.tableview reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self searchCountry];
    [self.tableview reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchCountry];
    [self.tableview reloadData];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self searchCountry];
    [self.tableview reloadData];
    return YES;
}
- (IBAction)closeButtonClick:(id)sender {
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
