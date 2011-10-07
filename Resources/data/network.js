exports.fetchFeedData = function(url, callback) {
	//mock data
	setTimeout(function() {
		var results = [
			{
				title:'Orioles Team Report',
				feedUrl:'http://us.rd.yahoo.com/sports/rss/mlb/SIG=122aj2du0/*http%3A//sports.yahoo.com/mlb/news?slug=teamreports-2011-mlb-bal',
				color:'#000',
				hasChild:true,
				selectedBackgroundColor:globals.style.ypurple
			},
			{
				title:'Epstein\'s blunders paved way for Boston\'s collapse',
				feedUrl:'http://us.rd.yahoo.com/sports/rss/mlb/SIG=12ptlggeu/*http%3A//sports.yahoo.com/mlb/news?slug=jp-passan_10_degrees_red_sox_choke_blame_091911',
				color:'#000',
				hasChild:true,
				selectedBackgroundColor:globals.style.ypurple
			},
			{
				title:'MLB Notebook: Twins officially shut down Morneau',
				feedUrl:'http://us.rd.yahoo.com/sports/rss/mlb/SIG=13h7u71nk/*http%3A//sports.yahoo.com/mlb/news?slug=sportsxchange-000416102_mlb-notebook-twins-officially-shut-down-morneau',
				color:'#000',
				hasChild:true,
				selectedBackgroundColor:globals.style.ypurple
			},
			{
				title:'Simon, Orioles lose to Angels 11-2 (AP)',
				feedUrl:'http://us.rd.yahoo.com/sports/rss/mlb/SIG=11kedbjuc/*http%3A//sports.yahoo.com/mlb/news?slug=ap-orioles',
				color:'#000',
				hasChild:true,
				selectedBackgroundColor:globals.style.ypurple
			}
		];
		callback.call(this,results);
	},2000);
	
	/*
	//This will load an RSS feed...
	var xhr = Ti.Network.createHTTPClient();
	xhr.onload = function() {
		var itemList = this.responseXML.documentElement.getElementsByTagName("item");
		for (var i = 0, l = itemList.length; i < l; i++) {
			var results = [];
			//iterate result list...
			callback.call(xhr,results);
		}
	};
	xhr.open('GET', url);
	xhr.send();
	*/
};
