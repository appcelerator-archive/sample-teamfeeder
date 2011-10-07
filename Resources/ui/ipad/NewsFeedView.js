exports.NewsFeedView = function() {
	var instance = Ti.UI.createView({
		width:250,
		left:0
	});
	
	var NewsTableView = require('ui/common/NewsTableView'),
		TeamChooserTableView = require('ui/common/TeamChooserTableView');
	
	var toolBarItems = [];
	
	var flexSpace = Titanium.UI.createButton({
		systemButton:Titanium.UI.iPhone.SystemButton.FLEXIBLE_SPACE
	});
	
	var teams = Titanium.UI.createButton({
		title:'Teams',
		style:Titanium.UI.iPhone.SystemButtonStyle.BORDERED
	});
	teams.addEventListener('click', function() {
		var popover = Ti.UI.iPad.createPopover({
			width: 250,
			height: 400,
			title: 'Choose a Team...',
			arrowDirection: Ti.UI.iPad.POPOVER_ARROW_DIRECTION_UP
		});
		
		popover.add(new TeamChooserTableView());
		
		popover.show({
			animated:true,
			view:teams
		});
	});
	
	var label = Ti.UI.createLabel({
		text:'Team News Feed',
		color:'#ffffff',
		font: {
			fontWeight:'bold',
			fontSize:18
		}
	});
	
	toolBarItems.push(flexSpace,label,flexSpace,teams);
	
	var toolbar = Ti.UI.createToolbar({
		items:toolBarItems,
		barColor:globals.style.ypurple,
		height:44,
		top:0
	});
	instance.add(toolbar);
	
	var feedTableView = new NewsTableView();
	feedTableView.top = 44;
	instance.add(feedTableView);
	
	return instance;
};
