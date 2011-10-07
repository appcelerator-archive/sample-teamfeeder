Ti.UI.setBackgroundColor('#ffffff');

//monkey patch "require" in the global scope
require('lib/require').monkeypatch(this);

//globally accessible and useful data - should strive
//for one or zero global variables.
var globals = {
	selectedTeam: (Ti.App.Properties.hasProperty('selectedTeam')) ? Ti.App.Properties.getString('selectedTeam') : 'min',
	creditsShown: Ti.App.Properties.hasProperty('creditsShown'),
	osname: Ti.Platform.osname,
	teamData: require('data/teamData').teamData,
	style: {
		ypurple:'#912CEE'
	}
};

(function() {
	var WindowObject;
	if (globals.osname === 'ipad') {
		WindowObject = require('ui/ipad/iPadWindow');
	}
	else if (globals.osname === 'iphone') {
		WindowObject = require('ui/iphone/iPhoneWindow');
	}
	else {
		WindowObject = require('ui/android/AndroidWindow');
	}
	new WindowObject().open();
})();


