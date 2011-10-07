exports.NewsTableView = function(callback) {
	var instance = Ti.UI.createTableView({
		data:[{title:'News Feed Loading...'}],
		backgroundSelectedColor:globals.style.ypurple
	});
	
	var net = require('data/network');
	
	function getFeedData() {
		net.fetchFeedData('', function(results) {
			instance.setData(results);
		});
	}
	
	instance.addEventListener('click', function(e) {
		Ti.App.fireEvent('app:article.selected', {
			title: e.title,
			url: e.rowData.feedUrl
		});
	});
	
	//initially populate the table view
	getFeedData();
	
	return instance;
};
