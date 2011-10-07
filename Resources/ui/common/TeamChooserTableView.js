exports.TeamChooserTableView = function(callback) {		
	//loop team data and populate the table view
	var data = [];
	for (var key in globals.teamData) {
		var team = globals.teamData[key];
		var rowdata = {
			title: team.name,
			leftImage: team.image,
			feedURL: team.feed,
			color:'#000'
		};
		if (globals.selectedTeam === key) {
			rowdata.hasCheck = true;
		}
		data.push(rowdata);
	}
	
	var instance = Ti.UI.createTableView({data:data});
	
	return instance;
};
