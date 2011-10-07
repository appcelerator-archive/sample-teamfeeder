exports.iPadWindow = function() {
	var instance = Ti.UI.createWindow({
		backgroundColor:'#ffffff'
	});
	
	var NewsFeedView = require('ui/ipad/NewsFeedView'),
		NewsItemView = require('ui/ipad/NewsItemView'),
		ToolTipView = require('ui/common/ToolTipView');
	
	var newsFeedView = new NewsFeedView();
	instance.add(newsFeedView);
	
	var newsItemView = new NewsItemView();
	instance.add(newsItemView);
	
	if (!globals.creditsShown) {
		var tooltip = new ToolTipView();
		newsItemView.add(tooltip);
	}
	
	return instance;
};
