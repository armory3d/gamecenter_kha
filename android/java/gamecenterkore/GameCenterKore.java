package gamecenterkore;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.WindowManager;

import com.google.android.gms.games.Games;
import com.google.android.gms.games.multiplayer.Participant;
import com.google.android.gms.games.multiplayer.realtime.RoomConfig;
import com.ktxsoftware.kore.KoreActivity;

public class GameCenterKore {
    
	public static void showLeaderboard(String leaderboardID) {
		KoreActivity inst = KoreActivity.getInstance();

		if (!inst.mGoogleApiClient.isConnected()) return;

		// inst.startActivityForResult(
		// 	Games.Leaderboards.getLeaderboardIntent(inst.mGoogleApiClient, leaderboardID),
		// 	100/*REQUEST_LEADERBOARD*/);

		inst.startActivityForResult(
			Games.Leaderboards.getAllLeaderboardsIntent(inst.mGoogleApiClient),
			100/*REQUEST_LEADERBOARD*/);
	}

	public static void showAchievements() {
		KoreActivity inst = KoreActivity.getInstance();

		if (!inst.mGoogleApiClient.isConnected()) return;

		inst.startActivityForResult(
			Games.Achievements.getAchievementsIntent(inst.mGoogleApiClient),
        	200/*REQUEST_ACHIEVEMENTS*/);
	}

	public static void reportScore(String leaderboardID, int score) {
		KoreActivity inst = KoreActivity.getInstance();

		if (!inst.mGoogleApiClient.isConnected()) return;

		Games.Leaderboards.submitScore(inst.mGoogleApiClient, leaderboardID, score);
	}

	public static void reportAchievement(String achievementID) {
		KoreActivity inst = KoreActivity.getInstance();

		if (!inst.mGoogleApiClient.isConnected()) return;

		Games.Achievements.unlock(inst.mGoogleApiClient, achievementID);
	}


	public static void startQuickGame() {
		KoreActivity inst = KoreActivity.getInstance();

		if (!inst.mGoogleApiClient.isConnected()) return;

		// auto-match criteria to invite one random automatch opponent.
	    // You can also specify more opponents (up to 3).
	    Bundle am = RoomConfig.createAutoMatchCriteria(1, 1, 0);

	    // build the room config:
	    RoomConfig.Builder roomConfigBuilder = makeBasicRoomConfigBuilder(inst);
	    roomConfigBuilder.setAutoMatchCriteria(am);
	    roomConfigBuilder.setVariant(1);
	    RoomConfig roomConfig = roomConfigBuilder.build();

	    // create room:
	    Games.RealTimeMultiplayer.create(inst.mGoogleApiClient, roomConfig);

	    // prevent screen from sleeping during handshake
		//inst.runOnUiThread(new Runnable() {
		//	@Override
		//	public void run() {
		//	}
		//});
	    //inst.getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

	    // go to game screen
	}

	public static void startInviteGame() {
		KoreActivity inst = KoreActivity.getInstance();

		if (!inst.mGoogleApiClient.isConnected()) return;
		
		// launch the player selection screen
		// minimum: 1 other player; maximum: 1 other player
		Intent intent = Games.RealTimeMultiplayer.getSelectOpponentsIntent(inst.mGoogleApiClient, 1, 1);
		inst.startActivityForResult(intent, 10000); // RC_SELECT_PLAYERS
	}

	public static void showInvitations() {
		KoreActivity inst = KoreActivity.getInstance();

		if (!inst.mGoogleApiClient.isConnected()) return;
		
		// launch the intent to show the invitation inbox screen
		Intent intent = Games.Invitations.getInvitationInboxIntent(inst.mGoogleApiClient);
		inst.startActivityForResult(intent, 10001); // RC_INVITATION_INBOX
	}

	// create a RoomConfigBuilder that's appropriate for your implementation
	private static RoomConfig.Builder makeBasicRoomConfigBuilder(KoreActivity inst) {
		return RoomConfig.builder(inst)
				.setMessageReceivedListener(inst)
				.setRoomStatusUpdateListener(inst);
	}

	public static int getReceivedData() {
		KoreActivity inst = KoreActivity.getInstance();

		int result = inst._receivedData;
		inst._receivedData = 0;
		return result;
	}

	public static boolean getGameStarted() {
		KoreActivity inst = KoreActivity.getInstance();

		if (!inst.mGoogleApiClient.isConnected()) return false;

		boolean result = inst._gameStarted;
		inst._gameStarted = false;
		return result;
	}

	static byte[] mMsgBuf = new byte[1];

	public static void sendReliableDataToOthers(int data) {
		mMsgBuf[0] = (byte)(data & 0xFF);

		KoreActivity inst = KoreActivity.getInstance();

		if (!inst.mGoogleApiClient.isConnected()) return;

		for (Participant p : inst.mParticipants) {
		    if (!p.getParticipantId().equals(inst.mMyId)) {
		        Games.RealTimeMultiplayer.sendReliableMessage(inst.mGoogleApiClient, null, mMsgBuf,
		                inst.mRoomId, p.getParticipantId());
		    }
		}
	}

	public static String getLocalParticipantId() {
		KoreActivity inst = KoreActivity.getInstance();
		return inst.mMyId;
	}

	public static String getOpponentParticipantId() {
		KoreActivity inst = KoreActivity.getInstance();
		return inst.mOpponentId;
	}

	public static void leaveRoom() {
		KoreActivity inst = KoreActivity.getInstance();

		if (!inst.mGoogleApiClient.isConnected()) return;

		if (inst.mRoomId != null) {
			Games.RealTimeMultiplayer.leave(inst.mGoogleApiClient, inst, inst.mRoomId);
		}
	}

	public static boolean getGameDisconnected() {
		KoreActivity inst = KoreActivity.getInstance();

		boolean result = inst._gameDisconnected;
		inst._gameDisconnected = false;
		return result;
	}
}
