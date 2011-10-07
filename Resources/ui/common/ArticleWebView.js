exports.ArticleWebView = function() {
	var instance = Ti.UI.createWebView({
		url:'http://sports.yahoo.com/'
	});
	
	Ti.App.addEventListener('app:article.selected', function(e) {
		instance.url = e.url;
	});
	
	return instance;
};
