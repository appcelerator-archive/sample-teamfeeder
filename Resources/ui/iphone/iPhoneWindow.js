exports.iPhoneWindow = function() {
	var ToolTipView = require('ui/common/ToolTipView'),
		NewsTableView = require('ui/common/NewsTableView'),
		TeamChooserTableView = require('ui/common/TeamChooserTableView'),
		ArticleWebView = require('ui/common/ArticleWebView');
	
	var instance = Ti.UI.createWindow({
		backgroundColor:'#ffffff'
	});
	
	var teamNewsWindow = Ti.UI.createWindow({
		title:'Team Feeder',
		backgroundColor:'#ffffff',
		barColor:globals.style.ypurple
	});
	
	var tableView = new NewsTableView();
	teamNewsWindow.add(tableView);
	
	var navGroup = Ti.UI.iPhone.createNavigationGroup({
		window: teamNewsWindow
	});
	instance.add(navGroup);
	
	var articleWindow = Ti.UI.createWindow({
		title:'View Article',
		barColor:globals.style.ypurple
	});
	articleWindow.add(new ArticleWebView());
	
	Ti.App.addEventListener('app:article.selected', function() {
		navGroup.open(articleWindow);
	});
	
	var teams = Titanium.UI.createButton({
		title:'Teams',
		style:Titanium.UI.iPhone.SystemButtonStyle.BORDERED
	});
	teams.addEventListener('click', function() {
		var teamChooserTableView = new TeamChooserTableView();
		var teamChooserWindow = Ti.UI.createWindow({
			title: 'Choose a Team...',
			barColor: globals.style.ypurple
		});
		teamChooserWindow.add(teamChooserTableView);
		navGroup.open(teamChooserWindow);
	});
	teamNewsWindow.setRightNavButton(teams);
	
	if (!globals.creditsShown) {
		var tooltip = new ToolTipView();
		instance.add(tooltip);
	}
	
	return instance;
};
