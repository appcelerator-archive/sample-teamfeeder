exports.AndroidWindow = function() {
	var ToolTipView = require('ui/common/ToolTipView'),
		NewsTableView = require('ui/common/NewsTableView'),
		ArticleWebView = require('ui/common/ArticleWebView'),
		TeamChooserTableView = require('ui/common/TeamChooserTableView');
	
	var instance = Ti.UI.createWindow({
		backgroundColor:'#fff',
		navBarHidden:false,
		title:'Team Feeder',
		exitOnClose: true,
		activity: {
			onCreateOptionsMenu : function(e) {
				var menu = e.menu;
				var m1 = menu.add({ 
					title: 'Choose A Team...',
					icon: Ti.Android.R.drawable.ic_menu_preferences
				});
				m1.addEventListener('click', function(e) {
					var win = Ti.UI.createWindow({
						title:'Choose a Team...',
						navBarHidden:false,
						backgroundColor:'#fff'
					});
					win.add(new TeamChooserTableView(function() {
						win.close();
					}));
					win.open({modal:true});
				});
			}
		}
	});
	
	var tableView = new NewsTableView();
	instance.add(tableView);
	
	var articleWindow = Ti.UI.createWindow({
		title:'View Article',
		navBarHidden:false
	});
	articleWindow.add(new ArticleWebView());
	
	Ti.App.addEventListener('app:article.selected', function() {
		articleWindow.open();
	});
	
	if (!globals.creditsShown) {
		var tooltip = new ToolTipView();
		instance.add(tooltip);
	}
	
	return instance;
};
