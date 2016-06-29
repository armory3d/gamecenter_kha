package com.ktxsoftware.kore;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.opengl.GLES20;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.Window;
import android.view.WindowManager;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.games.Game;
import com.google.android.gms.games.Games;
import com.google.android.gms.games.GamesActivityResultCodes;
import com.google.android.gms.games.Player;
import com.google.android.gms.games.request.GameRequest;
import com.google.android.gms.games.request.GameRequestBuffer;
import com.google.android.gms.games.request.OnRequestReceivedListener;
import com.google.android.gms.games.request.Requests;
import com.google.android.gms.games.request.Requests.LoadRequestsResult;
import com.google.android.gms.games.request.Requests.UpdateRequestsResult;
import com.google.android.gms.plus.Plus;
import com.google.example.games.basegameutils.BaseGameUtils;
import android.widget.Toast;

public class KoreActivity extends Activity implements SensorEventListener,
                                                      GoogleApiClient.ConnectionCallbacks,
                                                      GoogleApiClient.OnConnectionFailedListener

{


    public volatile static boolean paused = true;
	private AudioTrack audio;
	private Thread audioThread;
	private int bufferSize;
	private KoreView view;
	
	public static Object sensorLock = new Object();
	private SensorManager sensorManager;
	private Sensor accelerometer, gyro;
	
	private static KoreActivity instance;

	private GoogleApiClient mGoogleApiClient;

    private static int RC_SIGN_IN = 9001;

    private boolean mResolvingConnectionFailure = false;
    private boolean mAutoStartSignInFlow = true;
    private boolean mSignInClicked = false;
	
/*	private MagnetSensor mMagnetSensor;
	private NfcSensor mNfcSensor;
	private DistortionRenderer mDistortion;
	private HeadMountedDisplay mHmd;
	private FieldOfView mFov;
	private float mDistance;
	
	private CardboardDeviceParams mParams;
	
	private HeadMountedDisplayManager hmdManager;
	
	public HeadTracker mHeadTracker; */
	
	
	
	public static KoreActivity getInstance() {
		return instance;
	}
	
	@Override
	protected void onCreate(Bundle state) {
		super.onCreate(state);
		instance = this;
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
		setContentView(view = new KoreView(this));
		bufferSize = AudioTrack.getMinBufferSize(44100, AudioFormat.CHANNEL_OUT_STEREO, AudioFormat.ENCODING_PCM_16BIT) * 2;
		audio = new AudioTrack(AudioManager.STREAM_MUSIC, 44100, AudioFormat.CHANNEL_OUT_STEREO, AudioFormat.ENCODING_PCM_16BIT, bufferSize, AudioTrack.MODE_STREAM);
		
		sensorManager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);
		accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
		gyro = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE);
		
		/*
		// Cardboard setup
		mMagnetSensor = new MagnetSensor(this);
		mMagnetSensor.setOnCardboardTriggerListener(this);
		

		mNfcSensor = NfcSensor.getInstance(this);
		mNfcSensor.addOnCardboardNfcListener(this);
		
		mNfcSensor.onNfcIntent(getIntent());
		
		
		
		WindowManager windowManager = (WindowManager)getApplicationContext().getSystemService("window");
		
		ScreenParams screenParams = new ScreenParams(windowManager.getDefaultDisplay());
		Log.d("FM", screenParams.toString());
		
		mParams = new CardboardDeviceParams();
		
		
		this.hmdManager = new HeadMountedDisplayManager(this);

		
		mHmd = hmdManager.getHeadMountedDisplay();
		
		
		
		
		
		mDistortion = new DistortionRenderer();
		mDistortion.setTextureFormat(GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE);
		mDistortion.setRestoreGLStateEnabled(true);

		mDistance = 0.1f;
		
		Log.d("FM", mHmd.getCardboardDeviceParams().getDistortion().toString());

		

		mFov = new FieldOfView();
		float angle = 45.0f;
		mFov.setBottom(angle);
		mFov.setLeft(angle);
		mFov.setRight(angle);
		mFov.setTop(angle);
		
		// Log.d("FM", "Width: " + mHmd.getScreenParams().getWidth());
		
		mDistortion.onFovChanged(mHmd, mFov, mFov, mDistance);
		
		
		
		mHeadTracker = HeadTracker.createFromContext(this);
		mHeadTracker.startTracking();
		
		*/
		
		view.queueEvent(new Runnable() {
			@Override
			public void run() {
				KoreLib.onCreate();
			}
		});

        mGoogleApiClient = new GoogleApiClient.Builder(this)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .addApi(Plus.API).addScope(Plus.SCOPE_PLUS_LOGIN)
                .addApi(Games.API).addScope(Games.SCOPE_GAMES)
                .build();
	}
	
	/*
	public void DistortionBeforeFrame() {
		mDistortion.beforeDrawFrame();
	}
	
	public void DistortionAfterFrame() {
		mDistortion.afterDrawFrame();
	}
	
	public void DistortTexture(int texId) {
		mDistortion.undistortTexture(texId);
	}
	*/

	@Override
	public void onConnected(Bundle connectionHint) {
		// The player is signed in. Hide the sign-in button and allow the
		// player to proceed.
		// Toast.makeText(KoreActivity.this, "HELLO1!", Toast.LENGTH_LONG).show();
	}

    @Override
    public void onConnectionSuspended(int i) {
        // Toast.makeText(KoreActivity.this, "HELLO2!", Toast.LENGTH_LONG).show();

		// Attempt to reconnect
		mGoogleApiClient.connect();
    }

    @Override
    public void onConnectionFailed(ConnectionResult connectionResult) {
        // Toast.makeText(KoreActivity.this, "HELLO3!", Toast.LENGTH_LONG).show();

		if (mResolvingConnectionFailure) {
			// already resolving
			return;
		}

		// if the sign-in button was clicked or if auto sign-in is enabled,
		// launch the sign-in flow
		if (mSignInClicked || mAutoStartSignInFlow) {
			mAutoStartSignInFlow = false;
			mSignInClicked = false;
			mResolvingConnectionFailure = true;

			// Attempt to resolve the connection failure using BaseGameUtils.
			// The R.string.signin_other_error value should reference a generic
			// error string in your strings.xml file, such as "There was
			// an issue with sign-in, please try again later."
			if (!BaseGameUtils.resolveConnectionFailure(this,
					mGoogleApiClient, connectionResult,
					RC_SIGN_IN, "Issue with sign-in error!")) {
				mResolvingConnectionFailure = false;
			}
		}

		// Put code here to display the sign-in button
    }
	
	@Override
	protected void onStart() {
        super.onStart();

        view.queueEvent(new Runnable() {
            @Override
			public void run() {
				KoreLib.onStart();
			}
		});

        mGoogleApiClient.connect();
	}
	
	@Override
	protected void onPause() {
		super.onPause();
		view.onPause();
		sensorManager.unregisterListener(this);
		paused = true;
		audio.pause();
		audio.flush();
		
		view.queueEvent(new Runnable() {
			@Override
			public void run() {
				KoreLib.onPause();
			}
		});
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		view.onResume();
		sensorManager.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_NORMAL);
		sensorManager.registerListener(this, gyro, SensorManager.SENSOR_DELAY_NORMAL);
		
		if (audioThread != null) {
			try {
				audioThread.join();
			}
			catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		paused = false;
		audio.play();
		Runnable audioRunnable = new Runnable() {
			public void run() {
				Thread.currentThread().setPriority(Thread.MIN_PRIORITY);
				byte[] audioBuffer = new byte[bufferSize / 2];
				for (;;) {
					if (paused) return;
					KoreLib.writeAudio(audioBuffer, audioBuffer.length);
					int written = 0;
					while (written < audioBuffer.length) {
						written += audio.write(audioBuffer, written, audioBuffer.length);
					}
				}
			}
		};
		audioThread = new Thread(audioRunnable);
		audioThread.start();
		
		//mMagnetSensor.start();
	   // mNfcSensor.onResume(this);
	    
	    // TOD: Set all the events correctly.
		
		view.queueEvent(new Runnable() {
			@Override
			public void run() {
				KoreLib.onResume();
			}
		});
	}
	
	@Override
	protected void onStop() {
		super.onStop();
		
		//mMagnetSensor.stop();
		//mNfcSensor.onPause(this);
		view.queueEvent(new Runnable() {
			@Override
			public void run() {
				KoreLib.onStop();
			}
		});

		mGoogleApiClient.disconnect();
	}
	
	@Override
	protected void onRestart() {
		super.onRestart();
		
		//mMagnetSensor.start();
		//mNfcSensor.onResume(this);
		
		view.queueEvent(new Runnable() {
			@Override
			public void run() {
				KoreLib.onRestart();
			}
		});
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		
		view.queueEvent(new Runnable() {
			@Override
			public void run() {
				KoreLib.onDestroy();
			}
		});
	}
	
	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		super.onConfigurationChanged(newConfig);
		
		/*switch (newConfig.orientation) {
		case Configuration.ORIENTATION_LANDSCAPE:
			
			break;
		case Configuration.ORIENTATION_PORTRAIT:
			
			break;
			
		}*/
	}

	@Override
	public void onAccuracyChanged(Sensor sensor, int value) {
		
	}

	@Override
	public void onSensorChanged(SensorEvent e) {
		if (e.sensor == accelerometer) {
			view.accelerometer(e.values[0], e.values[1], e.values[2]);
		}
		else if (e.sensor == gyro) {
			view.gyro(e.values[0], e.values[1], e.values[2]);
		}
	}
	
	/*
	@Override
	public void onInsertedIntoCardboard(CardboardDeviceParams paramCardboardDeviceParams) {
		// TODO: Update the params
		hmdManager.updateCardboardDeviceParams(paramCardboardDeviceParams);
		mHmd = hmdManager.getHeadMountedDisplay();
		mDistortion.onFovChanged(mHmd, mFov, mFov, mDistance);
		Log.d("FM", "Inserted into cardboard");
	}

	@Override
	public void onRemovedFromCardboard() {
		
	}
	
	protected void onNfcIntent(Intent intent)
	{
		mNfcSensor.onNfcIntent(intent);
	}
	
	@Override
	public void onCardboardTrigger() {
		// Emulate a touch using the cardboard trigger
		KoreTouchEvent down = new KoreTouchEvent(0, 0, 0, 0);
		KoreTouchEvent up = new KoreTouchEvent(0, 0, 0, 2);
		synchronized(KoreView.inputLock) {
			KoreView.touchEvents.add(down);
			KoreView.touchEvents.add(up);
		}

	}
	
	*/


	protected void onActivityResult(int requestCode, int resultCode,
									Intent intent) {
		if (requestCode == RC_SIGN_IN) {
			mSignInClicked = false;
			mResolvingConnectionFailure = false;
			if (resultCode == RESULT_OK) {
				mGoogleApiClient.connect();
			} else {
				// Bring up an error dialog to alert the user that sign-in
				// failed. The R.string.signin_failure should reference an error
				// string in your strings.xml file that tells the user they
				// could not be signed in, such as "Unable to sign in."
				//BaseGameUtils.showActivityResultError(this,
				//		requestCode, resultCode, "Unable to sign in!");
			}
		}
	}
	
}
