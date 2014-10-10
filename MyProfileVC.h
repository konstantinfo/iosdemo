//
//  MyProfileVC.h
//  VENT
//
//  Created by Latika Tiwari on 10/5/13.
//  Copyright (c) 2013 Konstant Info. All rights reserved.
//
/**
 A ViewController used to show my profile
 it conforms UITableViewDataSource and  UITableViewDelegate protocols
 */
#import <UIKit/UIKit.h>

@interface MyProfileVC : UIViewController <UITableViewDelegate,UITableViewDataSource, UIActionSheetDelegate>
{
    BOOL showPopUpMenu;
    NSTimer *timer;
    int selectedIndex;
    NSIndexPath *indexPathToBeDelete;
}

/**
 property declaration that declares instance of UIButton,
 is used to navigate most popular screen
 */
@property (nonatomic ,strong) IBOutlet UIButton *redLingBtn;
/**
 property declaration that declares instance of NSLayoutConstraint,
 is used to set the top constraint of pop menu in respect of table view
 */
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *popViewTopSpaceToSV;
/*
property declaration that declares instance of UIButton,
is used to navigate latest vent screen
*/
@property (nonatomic ,strong) IBOutlet UIButton *LatestVentBtn;
/**
 property declaration that declares instance of UIButton,
 is used to navigate activity screen
 */
@property (nonatomic ,strong) IBOutlet UIButton *activityBtn;
/**
 property declaration that declares instance of UIButton,
 is used to navigate user's profile screen
 */
@property (nonatomic ,strong) IBOutlet UIButton *profileBtn;
/**
 property declaration that declares instance of UIView,
 is used to represent the pop up menu with animation to navigate on different screens
 */
@property (nonatomic ,strong) IBOutlet UIView *headerView;
/**
 property declaration that declares instance of UITableView,
 is used to show my profile
 */
@property (nonatomic ,strong) IBOutlet UITableView *tblView;
/**
 property declaration that declares instance of UIRefreshControl,
 to referesh table data
 */
@property (nonatomic ,strong) UIRefreshControl *refreshControl;
/**
 property declaration that declares instance of NSMutableArray,
 is used to store information of the user
 */
@property (nonatomic ,strong) NSMutableArray *userInfoArr;
/**
 property declaration that declares instance of NSMutableDictionary,
 is used to store information of the user
 */
@property (nonatomic ,strong) NSMutableDictionary *userInfoDict;

@property (nonatomic) BOOL shouldDeleteSelectedIndex;
/**
 InstanceMethod,
 Method to set up custom navigation bar
 */
-(void) setUpForNavigationBar;
/**
 InstanceMethod,
 Method to set activity badge on pop up menu
 and nav bar left abutton (add button or cross button)
 */
-(void)setBadgeOnView;
/**
 Instance Method
 Method to navigate on search screeen in response of search button,
 @param sender, id type that is id of search button
 */
-(void) searchScreen:(id)sender;
/**
 Instance Method,
 Method to fav vent in fav button response,
 @param sender , id type to send id of button
 */
-(void) addFav:(id)sender;
/**
 Instance Method,
 Method to fav vent
 @param timerForFav, NSTimer type to pass user info
 */
-(void) callFavAPI:(NSTimer *)timerr;
/**
 Instance Method,
 Method that sends request to server to fav vent
 @param indexPath, NSIndexPath type to pass index path of UITableView
 */
-(void)callFavFromServer:(NSIndexPath *)indexPath;
/**
 Instance Method
 Method to refersh table view after getting success response from fav api,
 @param indexPath, NSIndexPath type to reload particular custom cell
 */
-(void) refreshTableForFav:(NSIndexPath *)indexPath;
/**
 Instance Method
 Method to set custom height of latest vent custom cell according to,
 vent description
 */
-(float) setHeight:(int)indx;
/**
 Instance Method
 Method to show custom alert view with drop down animation
 in case of getting response from server or in case of network failure
 @param bannerTxt , NSString contains alert text that we are getting from server,
 @param ypos , float data type to set y postion of alert text,
 @param customHeight, float data type to set custom height of custom alert view according to text,
 @param setNumOfLines, int data type to set num of lines according to alert text
 */
-(void) setNotificationBanner:(NSString *)bannerTxt :(float) ypos setHeight:(float)customHeight setnumOfLines:(int)nol;
/**
 Instance Method,
 Method to refresh data from server
 */
-(void)fetchUserProfileData;
/**
 Instance Method,
 Method to fetch data from server
 */
-(void)fetchdata;
/**
 Instance Method,
 Method to fetch data from server
 */
-(void) fetchDataFromServer;
/**
 Instance Method,
 Method to show alert message in case of getting no response from server
 */
-(void) showServerErrorMsg;
/**
 Instance Method,
 Method to show alert messages in case of getting any error from server
 @param errorInfoDict,NSDictionary that contains error messages from server
 */
-(void) showErrorMsg:(NSDictionary *)errorInfoDict;
/**
 Instance Method,
 Method to show table view after getting response from server
 */
-(void) showTblView;
/**
 InstanceMethod,
 Method to refesh table view
 */
-(void) refreshTable;
/**
 Instance Method,
 Method to remove activity indicator after getting respose from server
 */
-(void) removeIndicator;
/**
 Instance Method,
 Method to navigate to post vent screen ,
 @param sender, id type to pass id of button
 */
-(void) navigateToPostVentScreen:(id)sender;
/**
 IBAction methods to navigate latest vent , activity ,user profile
 and post vent screen
 */
-(IBAction) LatestVentScreen:(id)sender;
-(IBAction) navigateToActivityScreen:(id)sender;
-(IBAction) navigateToMyProfileScreen:(id)sender;


-(IBAction) navigateToredLiningScreen:(id)sender;

@end
