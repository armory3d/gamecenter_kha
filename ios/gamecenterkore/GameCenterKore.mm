// Based on https://github.com/openfl/extension-gamecenter

#include <GameCenterKore.h>
#import <GameKit/GameKit.h>

typedef void (*FunctionType)();

@interface GKViewDelegate : NSObject <GKGameCenterControllerDelegate>
{
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)viewController;

@property (nonatomic) FunctionType onGameCenterFinished;

@end


@implementation GKViewDelegate

@synthesize onGameCenterFinished;

- (id)init 
{
    self = [super init];
    return self;
}

- (void)dealloc 
{
    //[super dealloc];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)viewController
{
	[viewController dismissViewControllerAnimated:YES completion:^{
		[viewController.view.superview removeFromSuperview];
		//[viewController release];
		onGameCenterFinished();
    }];
}

@end



namespace GameCenterKore {

	GKViewDelegate* viewDelegate;

	void gcAuthenticationChanged(CFNotificationCenterRef center, void* observer, CFStringRef name, const void* object, CFDictionaryRef userInfo)
	{
		//if(!isGameCenterAvailable())
	    //{
		//	return;
		//}
		
		if([GKLocalPlayer localPlayer].isAuthenticated)
	    {      
			NSLog(@"Game Center: You are logged in to game center.");
		}
	    else
	    {
			NSLog(@"Game Center: You are NOT logged in to game center.");
		}
	}


	void gameCenterViewDismissed();
	UIViewController *gcVC;

	int init() {

		gcVC = [[UIViewController alloc] init];

		if (isGameCenterAvailable()) {
			viewDelegate = [[GKViewDelegate alloc] init];
			viewDelegate.onGameCenterFinished = &gameCenterViewDismissed;
	        authenticateLocalUser();
	        //isUserAuthenticated();
			return 0;
		}
		else return 1;
	}

	bool isGameCenterAvailable() {

		Class gcClass = (NSClassFromString(@"GKLocalPlayer"));    
		NSString* reqSysVer = @"4.1";   
		NSString* currSysVer = [[UIDevice currentDevice] systemVersion]; 
		BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);   
		
		return (gcClass && osVersionSupported);
	}

	void authenticateLocalUser() 
	{
	    //if(!isGameCenterAvailable())
	    //{
		//	return;
		//}
		
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) 
	    {     
			if(error == nil)
	        {
	        	//NSLog(@"hello");
				registerForAuthenticationNotification();
				//sendGameCenterEvent("auth-success", "");
			}
	        
	        else
	        {
	        	NSLog(@"failed");
				//sendGameCenterEvent("auth-failed", "");
			}
		}];
	}

	bool isUserAuthenticated()
	{
		return ([GKLocalPlayer localPlayer].isAuthenticated);
	}

	void registerForAuthenticationNotification()
	{
		CFNotificationCenterAddObserver
		(
	    	CFNotificationCenterGetLocalCenter(),
	     	NULL,
	     	&gcAuthenticationChanged,
	     	(CFStringRef)GKPlayerAuthenticationDidChangeNotificationName,
	     	NULL,
	     	CFNotificationSuspensionBehaviorDeliverImmediately
	    );
	}

	void showLeaderboard(const char* leaderboardID)
	{
		//NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		NSString* strID = [[NSString alloc] initWithUTF8String:leaderboardID];

		GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
	    if (gameCenterController != nil)
	    {
	        gameCenterController.gameCenterDelegate = viewDelegate;
	        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
	        //gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeToday;
	        gameCenterController.leaderboardIdentifier = strID;

	        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	        [window addSubview:gcVC.view];
	        [gcVC presentViewController:gameCenterController animated:YES completion:nil];
	    }

	    //[strID release];
		//[pool drain];
	}

	void gameCenterViewDismissed() {
	    [gcVC.view removeFromSuperview];
	}

	void reportScore(const char* leaderboardID, int score)
	{
	    //NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		NSString* strID = [[NSString alloc] initWithUTF8String:leaderboardID];
		//GKScore* scoreReporter = [[[GKScore alloc] initWithCategory:strID] autorelease];
	    GKScore* scoreReporter = [[GKScore alloc] initWithCategory:strID];
	    
		if(scoreReporter)
	    {
			scoreReporter.value = score;
			
			[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) 
	        {   
				if(error != nil)
	            {
					NSLog(@"Game Center: Error occurred reporting score-");
					NSLog(@"  %@", [error userInfo]);
					//sendGameCenterEvent("score-failed", categoryID);
				}
	            
	            else
	            {
					NSLog(@"Game Center: Score was successfully sent");
					//sendGameCenterEvent("score-success", categoryID);
				}
			}];   
		}
	    
		//[strID release];
		//[pool drain];
	}

	void reportAchievement(const char* achievementID, float percent) {
		//NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		NSString* strAchievement = [[NSString alloc] initWithUTF8String:achievementID];
		//GKAchievement* achievement = [[[GKAchievement alloc] initWithIdentifier:strAchievement] autorelease];
	    GKAchievement* achievement = [[GKAchievement alloc] initWithIdentifier:strAchievement];
	    
		if(achievement)
	    {
	    	/*if(percent >= 1)
	    	{
	    		achievement.showsCompletionBanner = YES;
	    	}*/
	    	
			achievement.percentComplete = percent;
			[achievement reportAchievementWithCompletionHandler:^(NSError *error)
	        {
				if(error != nil)
	            {
					NSLog(@"Game Center: Error occurred reporting achievement-");
					NSLog(@"  %@", [error userInfo]);
					//sendGameCenterEvent("achieve-failed", achievementID);
				}
	            
	            else
	            {
					NSLog(@"Game Center: Achievement report successfully sent");
					//sendGameCenterEvent("achieve-success", achievementID);
				}
	            
			}];
		}
	    
	    //else 
	    //{
		//	sendGameCenterEvent("achieve-failed", achievementID);
		//}
		
		//[strAchievement release];
		//[pool drain];
	}

	void resetAchievements() {

	    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
	        
	        if(error != nil) {
	            NSLog(@"  %@", [error userInfo]);
	            //sendGameCenterEvent("achieve-reset-failed", "");
	        }
	        
	        else {
	            //sendGameCenterEvent("achieve-reset-success", "");
	        }
	    }];
	}
}
