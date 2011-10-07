exports.ToolTipView = function() {
	var instance = Ti.UI.createView({
		bottom:10,
		height:150,
		width:250
	});
	
	var box = Ti.UI.createView({
		top:15,
		right:15,
		bottom:15,
		left:15,
		borderWidth:2,
		borderRadius:(globals.osname === 'android') ? 0 : 5,
		borderColor:globals.style.ypurple,
		backgroundColor:'#ffffff',
		layout:'vertical'
	});
	instance.add(box);
	
	box.add(Ti.UI.createLabel({
		top:10,
		text:'Powered By',
		height:24,
		font: {
			fontSize:12
		},
		color:'#787878',
		textAlign:'center'
	}));
	
	box.add(Ti.UI.createImageView({
		image:'images/ysports.jpg',
		height:55,
		width:154
	}));
	
	var close = Ti.UI.createImageView({
		image:'images/close.png',
		height:40,
		width:40,
		top:0,
		right:0
	});
	instance.add(close);
	
	close.addEventListener('click', function() {
		instance.animate({
			bottom:-200,
			duration:1000
		});
	});
	
	return instance;
};
