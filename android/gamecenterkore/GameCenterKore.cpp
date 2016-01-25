#include <GameCenterKore.h>

#include <Kore/Android.h>

namespace GameCenterKore {

	int init() {
		return 0;
	}

	void showLeaderboard(const char* leaderboardID) {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);

		jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "showLeaderboard", "(Ljava/lang/String;)V");
        jstring jid = env->NewStringUTF(leaderboardID);

        env->CallStaticVoidMethod(cls, methodId, jid);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();
	}

	void showAchievements() {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);

		jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "showAchievements", "()V");

        env->CallStaticVoidMethod(cls, methodId);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();
	}

	void reportScore(const char* leaderboardID, int score) {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);

	    jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "reportScore", "(Ljava/lang/String;I)V");
        jstring jid = env->NewStringUTF(leaderboardID);

        env->CallStaticVoidMethod(cls, methodId, jid, score);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();
	}

	void reportAchievement(const char* achievementID, float percent) {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);
		
		jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "reportAchievement", "(Ljava/lang/String;)V");
        jstring jid = env->NewStringUTF(achievementID);

        env->CallStaticVoidMethod(cls, methodId, jid);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();
	}

	void resetAchievements() {
		
	}



	void startQuickGame() {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);

		jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "startQuickGame", "()V");

        env->CallStaticVoidMethod(cls, methodId);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();
	}

	void startInviteGame() {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);

		jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "startInviteGame", "()V");

        env->CallStaticVoidMethod(cls, methodId);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();
	}

	void showInvitations() {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);

		jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "showInvitations", "()V");

        env->CallStaticVoidMethod(cls, methodId);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();
	}

	void sendReliableDataToOthers(int data) {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);

		jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "sendReliableDataToOthers", "(I)V");

        env->CallStaticVoidMethod(cls, methodId, data);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();
	}

	int getReceivedData() {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);

		jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "getReceivedData", "()I");

        int result = env->CallStaticIntMethod(cls, methodId);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();

        return result;
	}

	bool getGameStarted() {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);

		jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "getGameStarted", "()Z");

        bool result = env->CallStaticBooleanMethod(cls, methodId);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();

        return result;
	}

	const char* getLocalParticipantId() {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);

		jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "getLocalParticipantId", "()Ljava/lang/String;");

        jstring returnString = (jstring)env->CallStaticObjectMethod(cls, methodId);
        const char *result = env->GetStringUTFChars(returnString, NULL);
        //env->ReleaseStringUTFChars(returnString, result);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();

        return result;
	}

	const char* getOpponentParticipantId() {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);

		jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "getOpponentParticipantId", "()Ljava/lang/String;");

        jstring returnString = (jstring)env->CallStaticObjectMethod(cls, methodId);
        const char *result = env->GetStringUTFChars(returnString, NULL);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();

        return result;
	}

	void leaveRoom() {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);

		jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "leaveRoom", "()V");

        env->CallStaticVoidMethod(cls, methodId);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();
	}

	bool getGameDisconnected() {
		JNIEnv* env;
		KoreAndroid::getActivity()->vm->AttachCurrentThread(&env, NULL);

		jclass cls = KoreAndroid::findClass(env, "gamecenterkore.GameCenterKore");

        jmethodID methodId = env->GetStaticMethodID(cls, "getGameDisconnected", "()Z");

        bool result = env->CallStaticBooleanMethod(cls, methodId);

        KoreAndroid::getActivity()->vm->DetachCurrentThread();

        return result;
	}
}
