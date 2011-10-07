exports.NewsItemView = function() {
	var instance = Ti.UI.createView({
		left:250,
		right:0,
		borderColor:globals.style.ypurple,
		borderWidth:4
	});
	
	var ArticleWebView = require('ui/common/ArticleWebView');
	
	var newsWebView = new ArticleWebView();
	instance.add(newsWebView);
	
	return instance;
};
