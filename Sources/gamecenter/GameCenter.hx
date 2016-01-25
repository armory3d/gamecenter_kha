package gamecenter;

#if (sys_ios || sys_android_native)
@:headerCode('
#include <GameCenterKore.h>
')
#end

class GameCenter {

	// TODO: use __cpp__
	#if (sys_ios || sys_android_native)
	@:functionCode('return GameCenterKore::init();')
	#end
	public static function init():Int {
		return 0;
	}


	// Achievements and leaderboards
	#if (sys_ios || sys_android_native)
	@:functionCode('GameCenterKore::showLeaderboard(leaderboardID);')
	#end
	public static function showLeaderboard(leaderboardID:String):Void {
	}

	#if (sys_ios || sys_android_native)
	@:functionCode('GameCenterKore::showAchievements();')
	#end
	public static function showAchievements():Void {
	}

	#if (sys_ios || sys_android_native)
	@:functionCode('GameCenterKore::reportScore(leaderboardID, score);')
	#end
	public static function reportScore(leaderboardID:String, score:Int):Void {
	}

	#if (sys_ios || sys_android_native)
	@:functionCode('GameCenterKore::reportAchievement(achievementID, percent);')
	#end
	public static function reportAchievement(achievementID:String, percent:Float):Void {
	}

	#if (sys_ios || sys_android_native)
	@:functionCode('GameCenterKore::resetAchievements();')
	#end
	public static function resetAchievements() {
	}


	// Realtime multiplayer - play services
	#if (sys_ios || sys_android_native)
	@:functionCode('GameCenterKore::startQuickGame();')
	#end
	public static function startQuickGame() {
	}

	#if (sys_ios || sys_android_native)
	@:functionCode('GameCenterKore::startInviteGame();')
	#end
	public static function startInviteGame() {
	}

	#if (sys_ios || sys_android_native)
	@:functionCode('GameCenterKore::showInvitations();')
	#end
	public static function showInvitations() {
	}

	#if sys_ios
	@:functionCode('GameCenterKore::signInWithClientID(clientID, silent);')
	#end
	public static function signInWithClientID(clientID:String, silent:Bool) {
	}

	#if sys_ios
	@:functionCode('GameCenterKore::signOut();')
	#end
	public static function signOut() {
	}

	#if (sys_ios || sys_android_native)
	@:functionCode('GameCenterKore::sendReliableDataToOthers(data);')
	#end
	public static function sendReliableDataToOthers(data:Int) {
	}

	#if (sys_ios || sys_android_native)
	@:functionCode('return GameCenterKore::getReceivedData();')
	#end
	public static function getReceivedData():Int {
		return 0;
	}

	#if (sys_ios || sys_android_native)
	@:functionCode('return GameCenterKore::getGameStarted();')
	#end
	public static function getGameStarted():Bool {
		return false;
	}
	
	#if (sys_ios || sys_android_native)
	@:functionCode('return GameCenterKore::getLocalParticipantId();')
	
	public static function getLocalParticipantId():cpp.ConstCharStar {
		return null;
	}
	#end

	#if (sys_ios || sys_android_native)
	@:functionCode('return GameCenterKore::getOpponentParticipantId();')
	
	public static function getOpponentParticipantId():cpp.ConstCharStar {
		return null;
	}
	#end

	#if (sys_ios || sys_android_native)
	@:functionCode('GameCenterKore::leaveRoom();')
	#end
	public static function leaveRoom() {
	}

	#if (sys_ios || sys_android_native)
	@:functionCode('return GameCenterKore::getGameDisconnected();')
	#end
	public static function getGameDisconnected():Bool {
		return false;
	}

	#if sys_ios
	@:functionCode('return GameCenterKore::getPlaySignedIn();')
	#end
	public static function getPlaySignedIn() {
		return false;
	}
}
