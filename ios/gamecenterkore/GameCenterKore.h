#pragma once

namespace GameCenterKore {

	int init();
	bool isGameCenterAvailable();
	void authenticateLocalUser();
	bool isUserAuthenticated();
	void registerForAuthenticationNotification();
	
	void showLeaderboard(const char* leaderboardID);
	void reportScore(const char* leaderboardID, int score);
	
	void reportAchievement(const char* achievementID, float percent);
	void resetAchievements();
}
