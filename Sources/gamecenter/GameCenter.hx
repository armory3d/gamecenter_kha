package gamecenter;

#if ios
@:headerCode('
#include <GameCenterKore.h>
')
#end

class GameCenter {

	// TODO: use __cpp__
	#if ios
	@:functionCode('return GameCenterKore::init();')
	#end
	public static function init():Int {
		return 0;
	}

	#if ios
	@:functionCode('GameCenterKore::showLeaderboard(leaderboardID);')
	#end
	public static function showLeaderboard(leaderboardID:String):Void {
	}

	#if ios
	@:functionCode('GameCenterKore::reportScore(leaderboardID, score);')
	#end
	public static function reportScore(leaderboardID:String, score:Int):Void {
	}

	#if ios
	@:functionCode('GameCenterKore::reportAchievement(achievementID, percent);')
	#end
	public static function reportAchievement(achievementID:String, percent:Float):Void {
	}

	#if ios
	@:functionCode('GameCenterKore::resetAchievements();')
	#end
	public static function resetAchievements() {
	}
}
