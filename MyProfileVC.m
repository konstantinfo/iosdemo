//
//  MyProfileVC.m
//  VENT
//
//  Created by Latika Tiwari on 10/5/13.
//  Copyright (c) 2013 Konstant Info. All rights reserved.
//

#import "MyProfileVC.h"
#import "LatestVentsVC.h"
#import "PostYourvent.h"
#import "ActivityVC.h"
#import "FavouritesVC.h"
#import "FollowersVC.h"
#import "FollowingVC.h"
#import "ViewMoreVentsVC.h"
#import "SearchResultsVC.h"
#import "FavUsersListVC.h"
#import "FavVentListVC.h"
#import "VentDetailVC.h"
#import "UserInfoCustomCell.h"
#import "CommonFunctions.h"
#import "UsersProfileCustomCell.h"
#import "MyProfileBotCell.h"
#import "LatestVentCustomCell.h"
#import "EditProfileVC.h"



#define EDIT_PROFILE_ACTION_SHEET 1

@interface MyProfileVC ()

@end

@implementation MyProfileVC

@synthesize tblView;
@synthesize headerView;

@synthesize userInfoArr;

@synthesize userInfoDict;
@synthesize refreshControl;
@synthesize LatestVentBtn,profileBtn,activityBtn,redLingBtn;
@synthesize popViewTopSpaceToSV;
@synthesize shouldDeleteSelectedIndex;

#define macro to set up Latest Vent custom cell

#define WIDTH_TXT                   284.0f
#define MINIMUM_HEIGHT              132.0f

#pragma mark-
#pragma mark- UIView Controller Life Cycle Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    
    self.tblView.hidden = YES;
    
    if(!self.refreshControl)
    {
    self.refreshControl = [[UIRefreshControl alloc]init];
    }
    
    [self.refreshControl addTarget:self action:@selector(fetchUserProfileData)forControlEvents:UIControlEventValueChanged];
    
    [CommonFunctions addTableViewControllerWithTableView:self.tblView andRefreshControl:self.refreshControl inViewController:self];
    
    if([CommonFunctions reachabiltyCheck])
    {
        [CommonFunctions showActivityIndicatorWithText:nil];
        [NSThread detachNewThreadSelector:@selector(fetchDataFromServer) toTarget:self withObject:nil];
    }
    else
    {
        [CommonFunctions showNotificationBanner:self.view setVentLvl:1 setTitle:NETWORK_ERROR setYpos:10.0f setHeight:50.0f setNumOfLines:1];
    }
    [self registerForNotifications];

    [self setUpPopUpFont];
    
   
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    
    if(showPopUpMenu==TRUE)
    {
        [popViewTopSpaceToSV setConstant:-180.0f];
    }
    
    [self setUpForNavigationBar];
    
    if (self.shouldDeleteSelectedIndex)
    {
        self.shouldDeleteSelectedIndex = NO;
        
        [CommonFunctions showActivityIndicatorWithText:nil];
        [NSThread detachNewThreadSelector:@selector(fetchDataFromServer) toTarget:self withObject:nil];
    }

    
}

-(void)viewWillDisappear:(BOOL)animate
{
    
    
    [super viewWillDisappear:animate];
    
    for(UIView* view in self.navigationController.navigationBar.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            if(view.tag == 11)
            {
                [view removeFromSuperview];
            }
        }
        
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(refershDataFromFollowingNFoolowers == NO)
    {
        [self.tblView reloadData];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

#pragma mark - Instance Method

- (void) editBtnTap:(id) sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit profile", nil];
    [actionSheet setTag:EDIT_PROFILE_ACTION_SHEET];
    [actionSheet showInView:self.view];
}

-(void)registerForNotifications
{
    
   
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setBadgeOnView)
                                                 name:SHOW_ACTIVITY_BADGE object:nil];
    
}

-(void)setBadgeOnView
{
    NSLog(@"badge %d",[[[NSUserDefaults standardUserDefaults]objectForKey:@"badge"]integerValue]);
    
    
    [CommonFunctions showActivityBadgeOnNavBarForProfile:[[[NSUserDefaults standardUserDefaults]objectForKey:@"badge"]integerValue] setVentLvl:[[self.userInfoDict objectForKey:@"vent_level"] integerValue]];
    [CommonFunctions setUpToShowForActivityCount:self.headerView];
    
}

-(void)refereshData
{
    
    if([CommonFunctions reachabiltyCheck])
    {
        [NSThread detachNewThreadSelector:@selector(fetchDataFromServer) toTarget:self withObject:nil];
    }
    else
    {
        [CommonFunctions showNotificationBanner:self.view setVentLvl:1 setTitle:NETWORK_ERROR setYpos:10.0f setHeight:50.0f setNumOfLines:1];
    }
    
}
-(void)unregisterForNotifications
{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHOW_ACTIVITY_BADGE object:nil];
    
    
}

/** method to set up for nav bar ***/
-(void)setUpForNavigationBar
{
    
    
    [CommonFunctions setNavigationTitleForUserProfile:@"Profile" ForNavigationItem:self.navigationItem setVentLvl:[[self.userInfoDict objectForKey:@"vent_level"] integerValue]];
    
    
        [CommonFunctions showActivityBadgeOnNavBarForProfile:[[[NSUserDefaults standardUserDefaults]objectForKey:@"badge"]integerValue] setVentLvl:[[self.userInfoDict objectForKey:@"vent_level"] integerValue]];
        [CommonFunctions setUpToShowForActivityCount:self.headerView];
    

    
    UIImage *buttonImage;
    UIButton *backButton;
    UIImage *rightBtnImg;
    UIImage *serachBtnImg;

    if([[self.userInfoDict objectForKey:@"vent_level"] integerValue]==0)
    {
    [CommonFunctions setNavigationBarBackgroundImage];
    
        /******* define custom image button at navigation bar *********/
     buttonImage = [UIImage imageNamed:@"menuBtn"];
     rightBtnImg = [UIImage imageNamed:@"edit_icon"];
    
    serachBtnImg = [UIImage imageNamed:@"search_icon_b"];
        
    }
    else
    {
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"navSep"]];
        
        [self.navigationController.navigationBar setBackgroundImage:[CommonFunctions setNavigationBarImage:[[self.userInfoDict objectForKey:@"vent_level"] integerValue]] forBarMetrics:
         UIBarMetricsDefault];
        
        float version =    [[UIDevice currentDevice].systemVersion floatValue];
        
        if(version>=7.0)
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
        else
            
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
       
       
        buttonImage = [UIImage imageNamed:@"menuBtn_white"];
        rightBtnImg = [UIImage imageNamed:@"editIcon_w"];
        serachBtnImg = [UIImage imageNamed:@"search_icon"];
        
    }
    
   
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f,0.0f,21.0f,21.0f);
    /******* define custom image button at navigation bar *********/
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0.0f,0.0f,27.0f,21.0f);
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    [backButton setImage:buttonImage forState:UIControlStateHighlighted];
    
    /******** Add LeftBarButton in navigation controller ************/
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(showPopUpMenu) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backBarButtonItem,nil];
    
    [rightBtn setImage:rightBtnImg forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(navigateToPostVentScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    /******* define custom image button at navigation bar *********/
    
    UIButton *serchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [serchButton setImage:serachBtnImg forState:UIControlStateNormal];
    serchButton.frame = CGRectMake(0.0f,0.0f,19.0f,21.0f);
    
    /******** Add LeftBarButton in navigation controller ************/
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithCustomView:serchButton];
    [serchButton addTarget:self action:@selector(searchScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 14;
    
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                        target:nil action:nil];
    
    float version =    [[UIDevice currentDevice].systemVersion floatValue];
    
    if(version>=7.0)
    {
        negativeSpacer1.width = -8;
    }
    else
    {
        negativeSpacer1.width = 0;
    }
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer1,rightBarButtonItem,negativeSpacer,searchBtn,nil] animated:TRUE];
    
    
}

-(void)updateNavBar
{
    [self setUpForNavigationBar];
    [self.navigationController.navigationBar setNeedsDisplay];
}


-(void)popViewControllerAnimated
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefershLatestVents" object:nil userInfo:nil];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LatestVentsVC class]])
        {    
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            break;
        }
    }
    
}

/** Method to set up custom font of pop up view
 */
-(void)setUpPopUpFont
{
    NSLog(@" fon t %@",[UIFont fontNamesForFamilyName:@"Klinic Slab"]);
    [self.LatestVentBtn.titleLabel setFont:[CommonFunctions setPopupFont]];
    [self.redLingBtn.titleLabel setFont:[CommonFunctions setPopupFont]];
    [self.activityBtn.titleLabel setFont:[CommonFunctions setPopupFont]];
    [self.profileBtn.titleLabel setFont:[CommonFunctions setPopupFont]];
    
}

/**
 method to show  pop up at nav bar add button action
 */
-(void)showPopUpMenu
{
    
    showPopUpMenu = TRUE;
   
    [popViewTopSpaceToSV setConstant:0.0f];
    
    
    [UIView animateWithDuration:0.3f
                          delay:0.0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [headerView.superview layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                     }];
    
    UIImage *buttonImage;
    UIImage *rightBtnImg;
    UIImage *serachBtnImg ;
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"VENT_LEVEL"]integerValue]==0)
    {
     buttonImage  = [UIImage imageNamed:@"close_icon_b"];
    rightBtnImg = [UIImage imageNamed:@"edit_icon"];
    serachBtnImg = [UIImage imageNamed:@"search_icon_b"];
    }
    else
    {
       buttonImage  = [UIImage imageNamed:@"close_icon"];
      rightBtnImg = [UIImage imageNamed:@"editIcon_w"];
        serachBtnImg = [UIImage imageNamed:@"search_icon"];
    }
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    [backButton setImage:buttonImage forState:UIControlStateHighlighted];
    backButton.frame = CGRectMake(0.0f,0.0f,16.0f,16.0f);
    /******** Add LeftBarButton in navigation controller ************/
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(hidePopUpMenu) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backBarButtonItem,nil];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0.0f,0.0f,27.0f,21.0f);
    
    
    [rightBtn setImage:rightBtnImg forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(navigateToPostVentScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    /******* define custom image button at navigation bar *********/
    
    UIButton *serchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [serchButton setImage:serachBtnImg forState:UIControlStateNormal];
    
    serchButton.frame = CGRectMake(0.0f,0.0f,19.0f,21.0f);
    [serchButton addTarget:self action:@selector(searchScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    /******* define custom image button at navigation bar *********/
    
    /******** Add LeftBarButton in navigation controller ************/
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithCustomView:serchButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 14;
    
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                        target:nil action:nil];
    
    float version =    [[UIDevice currentDevice].systemVersion floatValue];
    
    if(version>=7.0)
    {
        negativeSpacer1.width = -8;
    }
    else
    {
        negativeSpacer1.width = 0;
    }
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer1,rightBarButtonItem,negativeSpacer,searchBtn,nil] animated:TRUE];
    
}

/**
 method to hide  pop up at nav bar add button action
 */
-(void)hidePopUpMenu
{
    
    showPopUpMenu= FALSE;
    
    [popViewTopSpaceToSV setConstant:-180.0f];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [headerView.superview layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                     }];
    
    UIImage *buttonImage;
    UIImage *rightBtnImg;
    UIImage *serachBtnImg ;
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"VENT_LEVEL"]integerValue]==0)
    {
        buttonImage  = [UIImage imageNamed:@"menuBtn"];
        rightBtnImg = [UIImage imageNamed:@"edit_icon"];
        serachBtnImg = [UIImage imageNamed:@"search_icon_b"];
    }
    else
    {
        buttonImage  = [UIImage imageNamed:@"menuBtn_white"];
        rightBtnImg = [UIImage imageNamed:@"editIcon_w"];
        serachBtnImg = [UIImage imageNamed:@"search_icon"];
    }
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:buttonImage forState:UIControlStateNormal];
    [backButton setImage:buttonImage forState:UIControlStateHighlighted];
    backButton.frame = CGRectMake(0.0f,0.0f,21.0f,21.0f);
    /******** Add LeftBarButton in navigation controller ************/
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(showPopUpMenu) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backBarButtonItem,nil];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0.0f,0.0f,27.0f,21.0f);
    
    
    [rightBtn setImage:rightBtnImg forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(navigateToPostVentScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    /******* define custom image button at navigation bar *********/
    UIButton *serchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [serchButton setImage:serachBtnImg forState:UIControlStateNormal];
    
    serchButton.frame = CGRectMake(0.0f,0.0f,19.0f,21.0f);
    [serchButton addTarget:self action:@selector(searchScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    /******* define custom image button at navigation bar *********/
    
    /******** Add LeftBarButton in navigation controller ************/
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithCustomView:serchButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 14;
    
    UIBarButtonItem *negativeSpacer1 = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                        target:nil action:nil];
    
    float version =    [[UIDevice currentDevice].systemVersion floatValue];
    
    if(version>=7.0)
    {
        negativeSpacer1.width = -8;
    }
    else
    {
        negativeSpacer1.width = 0;
    }
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer1,rightBarButtonItem,negativeSpacer,searchBtn,nil] animated:TRUE];
    
}


/**** add nav bar right button action ******/

-(void)searchScreen:(id)sender
{
    
    SearchResultsVC *searchResultVC = [[SearchResultsVC alloc]initWithNibName:@"SearchResultsVC" bundle:nil];

    [self.navigationController pushViewController:searchResultVC animated:YES];
    
    
}

-(void)fetchUserProfileData
{
    
    if (([CommonFunctions reachabiltyCheck]))
    {
      [self performSelector:@selector(fetchdata) withObject:nil afterDelay:1.0f];
    }
    else
    {
         [CommonFunctions showNotificationBanner:self.view setVentLvl:1 setTitle:NETWORK_ERROR setYpos:10.0f setHeight:50.0f setNumOfLines:1];
        [refreshControl endRefreshing];
    }
    
}

-(void)fetchDataFromServer
{
    
    NSLog(@"sid %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"sid"]);
    NSString *sourceURL=[NSString stringWithFormat:@"%@/users/myProfile",siteApiUrl];
    NSLog(@"source url %@",sourceURL);
    NSURL *postURL = [NSURL URLWithString:sourceURL];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    // change type to POST (default is GET)
    [postRequest setHTTPMethod:@"POST"];
    NSMutableData *postBody = [NSMutableData data];
    // just some random text that will never occur in the body
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    // header value
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    // set header
    [postRequest addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"sid\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[[NSUserDefaults standardUserDefaults]objectForKey:@"sid"]dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // add body to post
    [postRequest setHTTPBody:postBody];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&urlResponse error:&error];
    
    [self performSelectorOnMainThread:@selector(removeIndicator) withObject:nil waitUntilDone:NO];
    //[self performSelectorOnMainThread:@selector(scrollTblViewToTop) withObject:nil waitUntilDone:NO];
    
    if([self isNotNull:responseData])
    {
        
        NSString* newStr = [[NSString alloc] initWithData:responseData
                                                 encoding:NSUTF8StringEncoding] ;
        
        NSLog(@"Json Response Is:%@",newStr);
        NSDictionary* jsonResponse = [NSJSONSerialization
                                      JSONObjectWithData:responseData
                                      options:kNilOptions
                                      error:&error];
        if(jsonResponse)
        {
            NSLog(@"Json Response Is:%@",jsonResponse);
            
            if ([[jsonResponse objectForKey:@"replyCode"] isEqualToString:@"success"])
            {
                self.userInfoArr = [[jsonResponse objectForKey:@"recent_vents"]mutableDeepCopy];
                
                NSLog(@"user info Arr :%@",userInfoArr);
                userInfoDict = [[NSMutableDictionary alloc]init];
                
                if([self isNotNull:userInfoDict])
                {
                  userInfoDict = [jsonResponse objectForKey:@"user_info"]; 
                }

            [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(showTblView) withObject:nil waitUntilDone:NO];
                
            }
            
            else
            {
                [self performSelectorOnMainThread:@selector(showErrorMsg:) withObject:jsonResponse waitUntilDone:NO];
            }
        }
        
        else
        {
            [self performSelectorOnMainThread:@selector(showServerErrorMsg) withObject:nil waitUntilDone:NO];
        }
    }
    else
    {
        [CommonFunctions performSelectorOnMainThread:@selector(showTimeoutErrorMsgInViewController:) withObject:self waitUntilDone:NO];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [CommonFunctions setRefreshControlTitle:self.refreshControl];
        [self.refreshControl beginRefreshing];
        [self.refreshControl endRefreshing];
    });
    
    [self performSelectorOnMainThread:@selector(updateNavBar) withObject:nil waitUntilDone:NO];
    
    
}

-(void)showServerErrorMsg
{
    [CommonFunctions showNotificationBanner:self.view setVentLvl:1 setTitle:SERVER_ERROR setYpos:10.0f setHeight:50.0f setNumOfLines:1];
}

-(void)showErrorMsg:(NSDictionary *)errorInfoDict
{
    [self setNotificationBanner:[errorInfoDict objectForKey:@"replyMsg"] :5.0f setHeight:50.0f setnumOfLines:1];
    
    if ([[errorInfoDict objectForKey:@"replyCode"] isEqualToString:@"no_vent"])
    {
        [self performSelector:@selector(deleteCellAtIndexPath:) withObject:indexPathToBeDelete afterDelay:1.9f];
    }
}

- (void) deleteCellAtIndexPath:(NSIndexPath*) indexPath
{
    [self.userInfoArr removeObjectAtIndex:indexPath.row];
    
    [self.tblView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/*** method to show notification banner ****/
-(void)setNotificationBanner:(NSString *)bannerTxt :(float) ypos setHeight:(float)customHeight setnumOfLines:(int)nol
{
    
    int ventLvl= [[[NSUserDefaults standardUserDefaults]objectForKey:@"VENT_LEVEL"]integerValue];
    
    if(ventLvl==0)
    {
        ventLvl = 4;
    }
    else
    {
        ventLvl =  [[[NSUserDefaults standardUserDefaults]objectForKey:@"VENT_LEVEL"]integerValue];
    }
    customview *view1=[[customview alloc] init];
    [view1 initWithText:nil showActivity:self.view withColor:[UIColor whiteColor] setAlertTxtYpos:ypos setViewHeight:customHeight setNumOfLines:nol];
    view1.alertTxt.text = bannerTxt;
    [view1.alertTxt setNumberOfLines:nol];
    [view1.alertTxt setFont:[UIFont fontWithName:@"Proxima N W01 Smbd" size:16]];
    view1.alertTxt.textColor = [CommonFunctions setNotificationnBannerTxtColor:ventLvl];
    [view1 startAnimationgBanner:ypos setHeight:customHeight setNumOfLines:nol];
    
}
-(void)showTblView
{
    self.tblView.hidden = NO;
    }
-(void)refreshTable
{
    [refreshControl endRefreshing];
    [tblView reloadData];
}
-(void)removeIndicator
{
    [CommonFunctions removeActivityIndicator];
    [self.refreshControl endRefreshing];
}

/*** method to navigate to  Post Vent screen *****/
-(void) navigateToPostVentScreen:(id)sender
{
    PostYourvent *postYourventVC = [[PostYourvent alloc]initWithNibName:@"PostYourvent" bundle:nil];

    [self.navigationController pushViewController:postYourventVC animated:YES];
}

-(void)navigateToFavUsersList:(id)sender
{
    
    refershDataFromFollowingNFoolowers = NO;
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblView];
    NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:buttonPosition];
    NSString *ventId = [NSString stringWithFormat:@"%@",[[self.userInfoArr objectAtIndex:indexPath.row]objectForKey:@"id"]];
    
    FavUsersListVC *favuserListVc = [[FavUsersListVC alloc]initWithNibName:@"FavUsersListVC" bundle:nil];
    favuserListVc.ventID = ventId;
    [self.navigationController pushViewController:favuserListVc animated:YES];
    
}
-(void)SwitchToViewMoreVents:(id)sender
{
    refershDataFromFollowingNFoolowers = NO;
    
    ViewMoreVentsVC *viewMoreVents = [[ViewMoreVentsVC alloc]initWithNibName:@"ViewMoreVentsVC" bundle:nil];
    viewMoreVents.userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    viewMoreVents.profileVentDataArr = self.userInfoArr;
    [self.navigationController pushViewController:viewMoreVents animated:YES];
}
-(void)SwitchToffolowingScreen:(id)sender
{
    refershDataFromFollowingNFoolowers = NO;
    
    FollowingVC *favVC = [[FollowingVC alloc]initWithNibName:@"FollowingVC" bundle:nil];
    favVC.userID= [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [self.navigationController pushViewController:favVC animated:YES];
}
-(void)SwitchToffolowersScreen:(id)sender
{
    refershDataFromFollowingNFoolowers = NO;
    
    FollowersVC *favVC = [[FollowersVC alloc]initWithNibName:@"FollowersVC" bundle:nil];
    favVC.userID= [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [self.navigationController pushViewController:favVC animated:YES];
}
-(void)fetchdata
{
    [NSThread detachNewThreadSelector:@selector(fetchDataFromServer) toTarget:self withObject:nil];
}
-(void)addFav:(id)sender
{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblView];
    NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:buttonPosition];
    NSString *ventID = [[userInfoArr objectAtIndex:indexPath.row]objectForKey:@"id"];
    
    NSLog(@"id vent %@",ventID);
    
    NSMutableDictionary *cb = [[NSMutableDictionary alloc] init];
    
    [cb setObject:sender forKey:@"target"];
    int myFavCount = [[[userInfoArr objectAtIndex:indexPath.row]objectForKey:@"my_fav"]integerValue];
    if(myFavCount == 0)
    {
        int myFavCount = 1;
        int favCount = [[[userInfoArr objectAtIndex:indexPath.row]objectForKey:@"fav_count"]integerValue];
        
        [[userInfoArr objectAtIndex:indexPath.row] setObject:[NSString stringWithFormat:@"%d",myFavCount] forKey:@"my_fav"];
        [[userInfoArr objectAtIndex:indexPath.row] setObject:[NSString stringWithFormat:@"%d",favCount+1] forKey:@"fav_count"];
        
        
    }
    else
    {
        int myFavCount = 0;
        int favCount = [[[userInfoArr objectAtIndex:indexPath.row]objectForKey:@"fav_count"]integerValue];
        
        [[userInfoArr objectAtIndex:indexPath.row] setObject:[NSString stringWithFormat:@"%d",myFavCount] forKey:@"my_fav"];
        if([self isNotNull:[[userInfoArr objectAtIndex:indexPath.row]objectForKey:@"fav_count"]])
        {
            if([[[userInfoArr objectAtIndex:indexPath.row]objectForKey:@"fav_count"]integerValue]>0)
            {
                [[userInfoArr objectAtIndex:indexPath.row] setObject:[NSString stringWithFormat:@"%d",favCount-1] forKey:@"fav_count"];
            }
            else
            {
                [[userInfoArr objectAtIndex:indexPath.row] setObject:[NSString stringWithFormat:@"%d",favCount] forKey:@"fav_count"];
            }
        }
        
    }
    [self.tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    
    [timer invalidate];
    if([CommonFunctions reachabiltyCheck])
    {
        timer=[NSTimer scheduledTimerWithTimeInterval:0.3f
                                               target:self
                                             selector:@selector(callFavAPI:)
                                             userInfo:cb
                                              repeats:NO];
    }
    else
    {
        [CommonFunctions showNotificationBanner:self.view setVentLvl:1 setTitle:NETWORK_ERROR setYpos:10.0f setHeight:50.0f setNumOfLines:1];
    }
    
    
    
    
}

/*** method to add Fav Vent By user from server *****/
-(void)callFavAPI:(NSTimer *)timerr
{
    
    NSDictionary *dict = [timerr userInfo];
    id target = [dict objectForKey:@"target"];
    CGPoint buttonPosition = [target convertPoint:CGPointZero toView:tblView];
    NSIndexPath *indexPath = [tblView indexPathForRowAtPoint:buttonPosition];
    [NSThread detachNewThreadSelector:@selector(callFavFromServer:) toTarget:self withObject:indexPath];
    
}

-(void)callFavFromServer:(NSIndexPath *)indexPath
{
    NSString *ventID = [[userInfoArr objectAtIndex:indexPath.row]objectForKey:@"id"];
    
    NSLog(@"id vent %@",ventID);
    
    NSString *sourceURL=[NSString stringWithFormat:@"%@/vents/likeVent",siteApiUrl];
    NSLog(@"source url %@",sourceURL);
    NSURL *postURL = [NSURL URLWithString:sourceURL];
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    // change type to POST (default is GET)
    [postRequest setHTTPMethod:@"POST"];
    NSMutableData *postBody = [NSMutableData data];
    // just some random text that will never occur in the body
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    // header value
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    // set header
    [postRequest addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"vent_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[ventID dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [postBody appendData:[@"Content-Disposition: form-data; name=\"sid\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[[NSUserDefaults standardUserDefaults]objectForKey:@"sid"]dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // add body to post
    [postRequest setHTTPBody:postBody];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&urlResponse error:&error];
    
    if([self isNotNull:responseData])
    {
        NSString* newStr = [[NSString alloc] initWithData:responseData
                                                 encoding:NSUTF8StringEncoding] ;
        
        NSLog(@"Json Response Is:%@",newStr);
        NSDictionary* jsonResponse = [NSJSONSerialization
                                      JSONObjectWithData:responseData
                                      options:kNilOptions
                                      error:&error];
        if(jsonResponse)
        {
            NSLog(@"Json Response Is:%@",jsonResponse);
            
            if ([[jsonResponse objectForKey:@"replyCode"] isEqualToString:@"success"])
            {
            }
            else if ([[jsonResponse objectForKey:@"replyCode"] isEqualToString:@"no_vent"])
            {
                indexPathToBeDelete = indexPath;
                [self performSelectorOnMainThread:@selector(showErrorMsg:) withObject:jsonResponse waitUntilDone:NO];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(refereshData) withObject:nil waitUntilDone:NO];
                
            }
        }
        else
        {
            
            [self performSelectorOnMainThread:@selector(showServerErrorMsg) withObject:nil waitUntilDone:NO];
        }
        
    }
    else
    {
        [CommonFunctions performSelectorOnMainThread:@selector(showTimeoutErrorMsgInViewController:) withObject:self waitUntilDone:NO];
    }
}

-(void)refreshTableForFav:(NSIndexPath *)indexPath
{
    
    [self.tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    
    
}

-(float)setHeight:(int)indx
{
    
    NSString *str = [[[userInfoArr objectAtIndex:indx]objectForKey:@"description"] decodeStringForEmoji];
    NSLog(@"str %@",str);
	static UIFont *fontUsed = nil;
	if (fontUsed == nil) fontUsed = [UIFont fontWithName:@"Proxima N W01 Reg" size:16];
	CGSize expectedLabelSize = [str sizeWithFont:fontUsed constrainedToSize:CGSizeMake(WIDTH_TXT , FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return expectedLabelSize.height+ ([CommonFunctions getLineSpacingMultiplierForHeight:expectedLabelSize.height andFontSize:16]*FONT_TOP_PADDING_FIX) + MINIMUM_HEIGHT ;
    
    
}

#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewDatasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section==0)
    {
        return 1;
    }
    else if(section==1)
    {
        return ([userInfoArr count]>0)?[userInfoArr count]:1; //default 1 row for info text
    }
    else
    {
        return 4;
    }
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        if([[self.userInfoDict objectForKey:@"vent_level"] integerValue] ==0)
        {
            return 275.0f;
        }
        else
        {
            return 338.0f;
        }
    }
    else if(indexPath.section == 1)
    {
        if ([userInfoArr count] > 0)
            return [self setHeight:indexPath.row];
        else
            return 199.0f;
    }
    else
    {
        return 51.0f;
    }
    return 0.0f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.section==1)
    {
        if ([userInfoArr count] > 0)
        {
            VentDetailVC *ventDetailVc = [[VentDetailVC alloc]initWithNibName:@"VentDetailVC" bundle:nil];
            ventDetailVc.ventDetailDict = [self.userInfoArr objectAtIndex:indexPath.row];
            
            [self.navigationController pushViewController:ventDetailVc animated:YES];
        }
    }
    
    
    else if(indexPath.section==2)
    {
        if(indexPath.row==0)
        {
            selectedIndex = indexPath.row;
            
            refershDataFromFollowingNFoolowers = NO;
            
            ViewMoreVentsVC *viewMoreVents = [[ViewMoreVentsVC alloc]initWithNibName:@"ViewMoreVentsVC" bundle:nil];
            viewMoreVents.profileVentDataArr = self.userInfoArr;
            viewMoreVents.userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            [self.navigationController pushViewController:viewMoreVents animated:YES];
        }
        else if (indexPath.row==1)
        {
            refershDataFromFollowingNFoolowers = NO;
            
            FavouritesVC *favVC = [[FavouritesVC alloc]initWithNibName:@"FavouritesVC" bundle:nil];
            favVC.userID =[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            [self.navigationController pushViewController:favVC animated:YES];
        }
        else if (indexPath.row==2)
        {
            refershDataFromFollowingNFoolowers = NO;
            
            FollowingVC *favVC = [[FollowingVC alloc]initWithNibName:@"FollowingVC" bundle:nil];
            favVC.userID= [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            [self.navigationController pushViewController:favVC animated:YES];
            
        }
        else
        {
            refershDataFromFollowingNFoolowers = NO;
            
            FollowersVC *favVC = [[FollowersVC alloc]initWithNibName:@"FollowersVC" bundle:nil];
            favVC.userID= [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
            [self.navigationController pushViewController:favVC animated:YES];
            
        }
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 
    static NSString *usersProfileCustomCell =  @"UsersProfileCustomCell";
    static NSString *myProfileBotCell      =  @"MyProfileBotCell";
    
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            
            UsersProfileCustomCell *cell = (UsersProfileCustomCell *)[tblView dequeueReusableCellWithIdentifier:usersProfileCustomCell];
            
            if (cell == nil)
            {
                cell = (UsersProfileCustomCell*)[[[NSBundle mainBundle] loadNibNamed:@"UsersProfileCustomCell" owner:self options:nil] objectAtIndex:0];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }
            cell.userVent.font = [UIFont fontWithName:@"KlinicSlab-Light" size:30.0f];
            cell.currently.font = [UIFont fontWithName:@"KlinicSlab-Light" size:16.0f];
            cell.ventHead.font = [UIFont fontWithName:@"KlinicSlab-Medium" size:11.0f];
            cell.followingHead.font = [UIFont fontWithName:@"KlinicSlab-Medium" size:11.0f];
            cell.followersHead.font = [UIFont fontWithName:@"KlinicSlab-Medium" size:11.0f];
            
            cell.ventCount.font = [UIFont fontWithName:@"KlinicSlab-Medium" size:24.0f];
            cell.followingCount.font = [UIFont fontWithName:@"KlinicSlab-Medium" size:24.0f];
            
            cell.followersCount.font = [UIFont fontWithName:@"KlinicSlab-Medium" size:24.0f];
            
            UIImage *image = [CommonFunctions getImageDataFromFile];
            
            [cell.userImg setImage:[CommonFunctions scaleAndRotateImage:image forMaxResolution:132]];
            
            if([[self.userInfoDict objectForKey:@"vent_level"] integerValue] != 0)
            {
                cell.username.textColor = [UIColor whiteColor];
                [cell.followBtnTSSVC setConstant:215.0f];
                [cell.bgView setBackgroundColor:[CommonFunctions setBackgroundView:[[self.userInfoDict objectForKey:@"vent_level"] integerValue]]];
                
                [cell.userVent setText:[CommonFunctions updateUserMoodForVentDetail:[[self.userInfoDict objectForKey:@"vent_level"] integerValue]]];
                
                [cell.followBtn setImage:[CommonFunctions getEditProfileImgForVentLevel:[[self.userInfoDict objectForKey:@"vent_level"] integerValue]] forState:UIControlStateNormal];
                [cell.followBtnWidth setConstant:66.0f];
            }
            
            else
            {
                cell.username.textColor = [UIColor blackColor];
                [cell.followBtnTSSVC setConstant:155.0f];
                
                [cell.followBtn setImage:[UIImage imageNamed:@"editProfile"] forState:UIControlStateNormal];
                [cell.followBtnWidth setConstant:66.0f];
            }
            
            if([self isNotNull:[userInfoDict objectForKey:@"username"]])
            {
                cell.username.font = [UIFont fontWithName:@"KlinicSlab-Light" size:21.0f];
                
                NSString *usernameStr = [userInfoDict objectForKey:@"username"];
                if([usernameStr length]>23)
                {
                    NSString *username = [usernameStr substringToIndex:23];
                    cell.username.text =  username;
                }
                else
                {
                    cell.username.text = usernameStr;
                }
            }
            else
            {
                cell.username.text = @"";
            }
            
            cell.followBtn.tag = indexPath.row;
            
            [cell.followBtn addTarget:self action:@selector(editBtnTap:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([self isNotNull:[NSString stringWithFormat:@"%@",[userInfoDict objectForKey:@"vents_count"]]])
            {
                
                cell.ventCount.text =  [NSString stringWithFormat:@"%@",[userInfoDict objectForKey:@"vents_count"]];
                
            }
            else
                
            {
                cell.ventCount.text = @"";
            }
            if ([self isNotNull:[NSString stringWithFormat:@"%@",[userInfoDict objectForKey:@"followers_count"]]])
            {
                
                cell.followersCount.text = [NSString stringWithFormat:@"%@",[userInfoDict objectForKey:@"followers_count"]];
            }
            
            else
            {
                cell.followersCount.text= @"";
            }
            if ([self isNotNull:[NSString stringWithFormat:@"%@",[userInfoDict objectForKey:@"following_count"]]])
            {
                cell.followingCount.text =  [NSString stringWithFormat:@"%@",[userInfoDict objectForKey:@"following_count"]];
                
            }
            
            else
            {
                
                
                cell.followingCount.text= @"";
                
            }
            [cell.viewVentsBtn addTarget:self action:@selector(SwitchToViewMoreVents:) forControlEvents:UIControlEventTouchUpInside];
            [cell.followingBtn addTarget:self action:@selector(SwitchToffolowingScreen:) forControlEvents:UIControlEventTouchUpInside];
            [cell.followersBtn addTarget:self action:@selector(SwitchToffolowersScreen:) forControlEvents:UIControlEventTouchUpInside];
            
            
            return cell;
            
        }
    }
    else if(indexPath.section==1)
    {
        if ([userInfoArr count] > 0)
        {
            static NSString *latestVentCustomCell   = @"LatestVentCustomCell";
            
            LatestVentCustomCell *cell = (LatestVentCustomCell *)[tblView dequeueReusableCellWithIdentifier:latestVentCustomCell];
            
            if (cell == nil)
            {
                
                cell = (LatestVentCustomCell*)[[[NSBundle mainBundle] loadNibNamed:@"LatestVentCustomCell" owner:self options:nil] objectAtIndex:0];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
            }
            
            cell.topBorderImg.hidden = YES;
            
            cell.indx = indexPath.row;
            cell.infoArr = userInfoArr;
            
            int lvl =  [[[userInfoArr objectAtIndex:indexPath.row]objectForKey:@"level"] integerValue];
            [cell.addfavBtn setImage:[CommonFunctions setFvIconImg:lvl setIndx:indexPath.row updateUserInfo:userInfoArr]forState:UIControlStateNormal];
            
            cell.addfavBtn.tag = indexPath.row;
            
            [cell.addfavBtn addTarget:self action:@selector(addFav:) forControlEvents:UIControlEventTouchUpInside];
            
            if (![[[self.userInfoArr objectAtIndex:indexPath.row]objectForKey:@"fav_count"]integerValue]==0)
            {
                cell.navigateToFavUsersList.tag = indexPath.row;
                [cell.navigateToFavUsersList addTarget:self action:@selector(navigateToFavUsersList:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            NSString *commentPlaceholder;
            cell.commentNoLbl.font = [UIFont fontWithName:@"Proxima N W01 Light" size:12.0f];
            cell.commentNoLbl.textColor = [CommonFunctions setFavNumTextColor:lvl];
            if([[[self.userInfoArr objectAtIndex:indexPath.row] objectForKey:@"commentCount"]integerValue]!=0 )
            {
                
                int commentcountVal = [[[self.userInfoArr objectAtIndex:indexPath.row] objectForKey:@"commentCount"] integerValue];
                NSString *comment_count = [NSString stringWithFormat:@"%d",commentcountVal];
                
                if([[[self.userInfoArr objectAtIndex:indexPath.row] objectForKey:@"commentCount"] integerValue]>1)
                {
                    commentPlaceholder = [comment_count stringByAppendingString:@" Comments"];
                }
                else
                {
                    commentPlaceholder = [comment_count stringByAppendingString:@" Comment"];
                }
                cell.commentNoLbl.text = commentPlaceholder;
                
                if([[[self.userInfoArr objectAtIndex:indexPath.row] objectForKey:@"isCommentAddedByMe"] integerValue]==1)
                {
                    [cell.commentBtn setImage:[CommonFunctions setCommentBtnFillImg:lvl] forState:UIControlStateNormal];
                }
                else
                {
                    [cell.commentBtn setImage:[CommonFunctions setCommentBtnImg:lvl] forState:UIControlStateNormal];
                }
                
                
            }
            else
            {
                commentPlaceholder = @"0 Comments";
                cell.commentNoLbl.text = @"0 Comments";
                
                if([[[self.userInfoArr objectAtIndex:indexPath.row] objectForKey:@"isCommentAddedByMe"] integerValue]==1)
                {
                    [cell.commentBtn setImage:[CommonFunctions setCommentBtnFillImg:lvl] forState:UIControlStateNormal];
                }
                else
                {
                    [cell.commentBtn setImage:[CommonFunctions setCommentBtnImg:lvl] forState:UIControlStateNormal];
                }
                
            }
            
            return cell;
        }
        else
        {
            static NSString *infoCellIdentifier   = @"infoCell";
            
            UITableViewCell *cell = [self.tblView dequeueReusableCellWithIdentifier:infoCellIdentifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:infoCellIdentifier];
                [cell setBackgroundColor:[UIColor clearColor]];
                
                UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 199.f)];
                [bgImg setBackgroundColor:[UIColor clearColor]];
                [bgImg setImage:[UIImage imageNamed:@"myProfileInfo"]];
                [cell addSubview:bgImg];
            }
            
            return cell;
        }
    }
    else
    {
        MyProfileBotCell *cell = (MyProfileBotCell *)[tblView dequeueReusableCellWithIdentifier: myProfileBotCell];
        
        if (cell == nil)
        {
            cell = (MyProfileBotCell*)[[[NSBundle mainBundle] loadNibNamed:@"MyProfileBotCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        
        if(indexPath.row==0)
        {
            
            cell.viewNme.text = @"View more vents";
            
        }
        else if (indexPath.row==1)
        {
            cell.viewNme.text = @"Favourites";
        }
        else if (indexPath.row==2)
        {
            cell.viewNme.text = @"Following";
        }
        else
        {
            cell.viewNme.text = @"Followers";
        }
        return cell;
        
    }
    
    return nil;
    
}

#pragma mark-
#pragma mark- IBActionMethods
-(IBAction) navigateToredLiningScreen:(id)sender
{
     refershDataFromFollowingNFoolowers = NO;
    FavVentListVC *favVentListvc = [[FavVentListVC alloc]initWithNibName:@"FavVentListVC" bundle:nil];
    [self.navigationController pushViewController:favVentListvc animated:YES];
}
/*** method to referesh Latest vents  *****/
-(IBAction) LatestVentScreen:(id)sender
{
     refershDataFromFollowingNFoolowers = NO;
    LatestVentsVC *latestventsVc = [[LatestVentsVC alloc]initWithNibName:@"LatestVentsVC" bundle:nil];
    [self.navigationController pushViewController:latestventsVc animated:YES];
}

/*** method to navigate to  activity screen *****/
-(IBAction)navigateToActivityScreen:(id)sender
{
     refershDataFromFollowingNFoolowers = NO;
    
    ActivityVC *activityVC = [[ActivityVC alloc]initWithNibName:@"ActivityVC" bundle:nil];
    [self.navigationController pushViewController:activityVC animated:YES];
}

/*** method to navigate to  user profile screen *****/
-(IBAction) navigateToMyProfileScreen:(id)sender
{
    
    if([CommonFunctions reachabiltyCheck])
    {
        [CommonFunctions showActivityIndicatorWithText:@"Refreshing data"];
        [self performSelector:@selector(fetchdata) withObject:nil afterDelay:1.0f];
        
        [self hidePopUpMenu];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [tblView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    else
    {
        [self hidePopUpMenu];
        [CommonFunctions showNotificationBanner:self.view setVentLvl:1 setTitle:NETWORK_ERROR setYpos:10.0f setHeight:50.0f setNumOfLines:1];
    }
    
    
    
}

#pragma mark - UIActionSheet Delegate Methods

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == EDIT_PROFILE_ACTION_SHEET)
    {
        if (buttonIndex == 0) // Edit profile
        {
            EditProfileVC *epvc = [[EditProfileVC alloc] initWithNibName:@"EditProfileVC" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:epvc animated:YES];
        }
    }
}

#pragma mark-
#pragma mark- Memory management methods

-(void)viewDidUnload
{
    [super viewDidUnload];
    
    [self unregisterForNotifications];
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


@end
