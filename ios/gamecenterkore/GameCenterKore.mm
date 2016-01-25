// Based on https://github.com/openfl/extension-gamecenter

#include <GameCenterKore.h>
#import <GameKit/GameKit.h>
#import <gpg/GooglePlayGames.h>
#import "Kore/KoreAppDelegate.h"

typedef void (*FunctionType)();

@interface GKViewDelegate : NSObject <GKGameCenterControllerDelegate>
{
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)viewController;

@property (nonatomic) FunctionType onGameCenterFinished;

@end


@implementation GKViewDelegate

@synthesize onGameCenterFinished;

- (id)init {
    self = [super init];
    return self;
}

- (void)dealloc {
    //[super dealloc];
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)viewController {
	[viewController dismissViewControllerAnimated:YES completion:^{
		[viewController.view.superview removeFromSuperview];
		//[viewController release];
		onGameCenterFinished();
    }];
}

@end



namespace GameCenterKore {

	GKViewDelegate* viewDelegate;

	void gcAuthenticationChanged(CFNotificationCenterRef center, void* observer, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
		//if(!isGameCenterAvailable())
	    //{
		//	return;
		//}
		
		/*if([GKLocalPlayer localPlayer].isAuthenticated)
	    {      
			NSLog(@"Game Center: You are logged in to game center.");
		}
	    else
	    {
			NSLog(@"Game Center: You are NOT logged in to game center.");
		}*/
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

	void authenticateLocalUser() {
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
	        	//NSLog(@"failed");
				//sendGameCenterEvent("auth-failed", "");
			}
		}];
	}

	bool isUserAuthenticated() {
		return ([GKLocalPlayer localPlayer].isAuthenticated);
	}

	void registerForAuthenticationNotification() {
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

	void showLeaderboard(const char* leaderboardID) {
		//NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		NSString* strID = [[NSString alloc] initWithUTF8String:leaderboardID];

		GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
	    if (gameCenterController != nil) {
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

	void showAchievements() {
		GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
	    if (gameCenterController != nil) {
	        gameCenterController.gameCenterDelegate = viewDelegate;
	        gameCenterController.viewState = GKGameCenterViewControllerStateAchievements;

	        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	        [window addSubview:gcVC.view];
	        [gcVC presentViewController:gameCenterController animated:YES completion:nil];
	    }
	}

	void gameCenterViewDismissed() {
	    [gcVC.view removeFromSuperview];
	}

	void reportScore(const char* leaderboardID, int score) {
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
					//NSLog(@"Game Center: Error occurred reporting score-");
					//NSLog(@"  %@", [error userInfo]);
					//sendGameCenterEvent("score-failed", categoryID);
				}
	            
	            else
	            {
					//NSLog(@"Game Center: Score was successfully sent");
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
					//NSLog(@"Game Center: Error occurred reporting achievement-");
					//NSLog(@"  %@", [error userInfo]);
					//sendGameCenterEvent("achieve-failed", achievementID);
				}
	            
	            else
	            {
					//NSLog(@"Game Center: Achievement report successfully sent");
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
	            //NSLog(@"  %@", [error userInfo]);
	            //sendGameCenterEvent("achieve-reset-failed", "");
	        }
	        
	        else {
	            //sendGameCenterEvent("achieve-reset-success", "");
	        }
	    }];
	}


	// Realtime multiplayer
	void startQuickGame() {
		GPGMultiplayerConfig *config = [[GPGMultiplayerConfig alloc] init];
	    // Could also include variants or exclusive bitmasks here
	    config.minAutoMatchingPlayers = 1;//totalPlayers - 1;
	    config.maxAutoMatchingPlayers = 1;//totalPlayers - 1;
	    config.variant = 1;

	    // Show waiting room UI
	    [[GPGLauncherController sharedInstance] presentRealTimeWaitingRoomWithConfig:config];
	}

	void startInviteGame() {
		[[GPGLauncherController sharedInstance] presentRealTimeInviteWithMinPlayers:2 maxPlayers:2];
	}

	void showInvitations() {

	}

	void signInWithClientID(const char* clientID, bool silent) {
		NSString* nsID = [[NSString alloc] initWithUTF8String:clientID];

		if (silent) {
			[[GPGManager sharedInstance] signInWithClientID:nsID silently:YES];
		}
		else {
			[[GPGManager sharedInstance] signInWithClientID:nsID silently:NO];
		}
	}

	void signOut() {
		[[GPGManager sharedInstance] signOut];
	}

	void sendReliableDataToOthers(int data) {
		NSMutableData *gameMessage = [[NSMutableData alloc] init];
		
		// Turns out the Android version sends this as a byte.
		Byte tinyData = (Byte)(data & 0xFF);
		[gameMessage appendBytes:&tinyData length:sizeof(Byte)];

		KoreAppDelegate* appd = (KoreAppDelegate*)[[UIApplication sharedApplication]delegate];
		GPGRealTimeRoom* roomToTrack = [appd getRoomToTrack];

		[roomToTrack sendReliableDataToOthers:[gameMessage copy]];
	}

	int getReceivedData() {
		KoreAppDelegate* appd = (KoreAppDelegate*)[[UIApplication sharedApplication]delegate];
		int result = [appd getReceivedData];
		return result;
	}

	bool getGameStarted() {
		KoreAppDelegate* appd = (KoreAppDelegate*)[[UIApplication sharedApplication]delegate];
		bool result = [appd getGameStarted];
		return result;
	}

	const char* getLocalParticipantId() {
		KoreAppDelegate* appd = (KoreAppDelegate*)[[UIApplication sharedApplication]delegate];
		const char* result = [appd getLocalParticipantId];
		return result;
	}

	const char* getOpponentParticipantId() {
		KoreAppDelegate* appd = (KoreAppDelegate*)[[UIApplication sharedApplication]delegate];
		const char* result = [appd getOpponentParticipantId];
		return result;
	}

	void leaveRoom() {
		KoreAppDelegate* appd = (KoreAppDelegate*)[[UIApplication sharedApplication]delegate];
		GPGRealTimeRoom* roomToTrack = [appd getRoomToTrack];

		[roomToTrack leave];
	}

	bool getGameDisconnected() {
		return false;
	}

	bool getPlaySignedIn() {
		KoreAppDelegate* appd = (KoreAppDelegate*)[[UIApplication sharedApplication]delegate];
		bool result = [appd getPlaySignedIn];
		return result;
	}
}
