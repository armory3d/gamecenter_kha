var project = new Project('gamecenter_kha');

if (platform === Platform.iOS) {
	project.addLib('GameKit');
	project.addFile('ios/gamecenterkore/**');
	project.addIncludeDir('ios/gamecenterkore');
}

return project;
