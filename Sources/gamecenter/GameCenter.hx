package gamecenter;

@:headerCode('
#include <GameCenterKore.h>
')

class GameCenter {

	// TODO: use __cpp__
	@:functionCode('return GameCenterKore::init();')
	public static function init():Int {
		return 0;
	}

	@:functionCode('GameCenterKore::showLeaderboard(leaderboardID);')
	public static function showLeaderboard(leaderboardID:String):Void {
	}

	@:functionCode('GameCenterKore::reportScore(leaderboardID, score);')
	public static function reportScore(leaderboardID:String, score:Int):Void {
	}

	@:functionCode('GameCenterKore::reportAchievement(achievementID, percent);')
	public static function reportAchievement(achievementID:String, percent:Float):Void {
	}

	@:functionCode('GameCenterKore::resetAchievements();')
	public static function resetAchievements() {
	}
}
