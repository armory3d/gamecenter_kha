var project = new Project('gamecenter_kha');

if (platform === Platform.iOS) {
	project.addLib('GameKit');
	project.addLib('AddressBook');
	project.addLib('AssetsLibrary');
	project.addLib('CoreData');
	project.addLib('CoreLocation');
	project.addLib('CoreMotion');
	project.addLib('CoreTelephony');
	project.addLib('CoreText');
	project.addLib('Foundation');
	project.addLib('MediaPlayer');
	project.addLib('QuartzCore');
	project.addLib('Security');
	project.addLib('SystemConfiguration');
	//project.addLib('libc++.dylib');
	//project.addLib('libz.dylib');
	project.addLib('SafariServices'); // optional
	project.addLib('ios/GoogleOpenSource.framework');
	project.addLib('ios/GoogleSignIn.framework');
	project.addLib('ios/gpg.framework');
	project.addFile('ios/gamecenterkore/**');
	project.addIncludeDir('ios/gamecenterkore');
}
else if (platform === Platform.Android) {
	project.addFile('android/gamecenterkore/**');
	project.addIncludeDir('android/gamecenterkore');
	project.addJavaDir('android/java');
}

return project;
