//console.log("Loading Script")
var START=true;
var galleryNames = [];


var rollState = {
	maxPics:7,
	firstPictureArrayPosition:0
}



var galleryState = {
	currentGalleryName:"",
	galleryPage:0,
	currentPicture:false,
	firstPicture:false,
	firstPictureInRoll:false,
	galleryCaption:false,
	maxPics:5,
	rollUnitWidth:124,
	galleryLength:0,
	maxPicsInRoll:7,
	rollSliding:false,
	maxPictureWidth:"900px",
	maxPictureHeight:"800px",
	randomSlideshowTimer:false
}

var displayData = {
	menuSize:250,
	thumbSize:225,
	contentWidth:900,
	screenWidth:false,
	screenHeight:false
}

var galleryStorage = new Array();
var galleryData = new Array();
var picturesArray = new Array();
function galleryUnit(id,image, src,src_thumb,title,caption,last,next,position,galleryName) {
	this.id = id;
	this.imageDOM = image;
	this.src = src;
	this.src_thumb = src_thumb;
	this.title = title;
	this.caption = caption;
	this.last = last;
	this.next = next;
	this.position=position;
	this.galleryName=galleryName;
};

var addImage = function(src,id,title) {
	var li     = new Element('li', {'class': 'thumb-page'});
	var link   = new Element('a', {'class': 'thumb-link','href': '#'+id}).inject(li);
	var thumb    = new Element('img', {'id':id,'src': src,'class':'mini'}).inject(link);
	var footer = new Element('span').inject(thumb,'after');
	footer.addClass('title');
	footer.set('text', title);
	li.addEvent('click', function(e) {loadPic(id)});
	return li;
}


function loadGallery(gallery) {
	galleryData=galleryStorage[gallery];

	Array.each(galleryStorage[gallery], function(picture, id){

		document.getElementById("content").appendChild(picture.imageDOM.clone(true,true)); //"true,true" : keep content, keep id
	});
	initMouseOverThumb();
	
}

function initMouseOverThumb(){
	Array.each($$('img.mini'), function(thumb, index){
	thumb.set('tween', {transition: Fx.Transitions.Quint.easeOut, duration:500});
		  thumb.addEvents({
		    mouseenter: function(){
				thumb.tween('padding-top', 15);
			},
		    mouseout: function(){
				thumb.tween('padding-top', 0);
			},
		    click:function(){
//				PelletStudio.displayPic(thumb.id);
			}

		})
	});
}




var PelletStudio = {
	storedHash:"",
	start: function(){

      if (!$('content')) return;



  		function parseGalleryJSON(request) {
			var last=false;
			var next=false;
			var id=false;
			var title=false;
	        Array.each(request, function(gallery, g_index){
	    			galleryStorage[gallery.id]=new Array();
	    			galleryNames[gallery.id]=gallery.name;
	
	          Array.each(gallery.pictures, function(picture, p_index){
	
	            
							if (!galleryState.firstPicture) galleryState.firstPicture=id;
							next=false;
							id=picture.id;
							src=picture.url;
							src_thumb=picture.thumb_url;
							title=picture.title;
							caption=picture.caption;
							
	
							galleryStorage[gallery.id][id]=
								new galleryUnit(
									id,
									addImage(src_thumb,id),
									src,
	                src_thumb,
									title,
									caption,
									last,
									next,
									p_index,
									gallery.id
							)
							picturesArray[id]=galleryStorage[gallery.id][id];
							if (last) galleryStorage[gallery.id][last].next=id;
							last=id;
	
	
	
	          })          
	        })
					PelletStudio.galleriesLoaded();
      }



		var ajax = new Request.JSON( {
			url : 'gallery.json',
			method: 'get',
			encoding: 'utf-8',
			onSuccess: parseGalleryJSON
		}).send();

		if (window.location.hash.length==0 && $('hash')) {
			PelletStudio.storedHash=$('hash').className;
			window.location.hash=PelletStudio.storedHash;			
		} else {
			PelletStudio.storedHash = window.location.hash;
		}
		window.setInterval(function () {
		    if (window.location.hash != PelletStudio.storedHash) {
			PelletStudio.storedHash = window.location.hash;
			PelletStudio.hashChanged(PelletStudio.storedHash);
		    }
		}, 250);

		var menuFX = new Fx.Tween('title', {property: 'opacity',duration:1500});
		menuFX.start(0,1).chain(
			function(){
				var whiteScreenFX = new Fx.Tween('white-screen', {property: 'opacity',duration:1500});
				whiteScreenFX.start(1,0).chain(
				function(){
				$('white-screen').style.display="none";
				$('menu').style.zIndex=2;
				})
			}
		);

		PelletStudio.getWindowSize();
		PelletStudio.resizeContents();
	},
	getWindowSize : function() {
		var winW = 630, winH = 460;
		if (document.body && document.body.offsetWidth) {
		 winW = document.body.offsetWidth;
		 winH = document.body.offsetHeight;
		}
		if (document.compatMode=='CSS1Compat' &&
		    document.documentElement &&
		    document.documentElement.offsetWidth ) {
		 winW = document.documentElement.offsetWidth;
		 winH = document.documentElement.offsetHeight;
		}
		if (window.innerWidth && window.innerHeight) {
		 winW = window.innerWidth;
		 winH = window.innerHeight;
		}
		displayData.screenWidth=winW;
		displayData.screenHeight=winH;

	},
	resizeContents : function() {
	
		if (displayData.screenWidth-displayData.menuSize<900) {
//			Asset.css('../css/smallScreen.css', {id: 'myStyle', title: 'myStyle'});
//			galleryState.maxPicsInRoll=5;
		} else if (displayData.screenWidth-displayData.menuSize>1300) {
			Asset.css('../css/wideScreen.css', {id: 'myStyle', title: 'myStyle'});
//			galleryState.maxPicsInRoll=5;
		} 
	},//TODO change hardcode
	hashChanged : function () {
		switch (PelletStudio.storedHash) {
		 case "#main": //rien et main
		 case "":
			$('content').empty();
			Element('div', {'id':"random-picture"}).inject($('content'));
			PelletStudio.displayRandomPictures();
			 break;
		 case "#portraits":
			PelletStudio.displayGallery(1);
			 break;
		 case "#nature":
			PelletStudio.displayGallery(2);
			 break;
		 case "#fine_art":
			PelletStudio.displayGallery(3);
			 break;
		 case "#wellington":
			PelletStudio.displayGallery(4);
			 break;
		 case "#about":
			PelletStudio.displayAbout();
			break;
		 case "#contact":
			PelletStudio.displayContact();
			break;
		 default:
			var picture = picturesArray[PelletStudio.storedHash.substring(1)];
			if (picture) {
				if (!$(picture.id)) // Si la miniature n'est pas actuellement définie dans le DOM, on ne recharge pas la gallerie
					PelletStudio.displayGallery(picture.galleryName);
				PelletStudio.displayPic(picture.id);
			} else {
				Element('div', {'id':"random-picture"}).inject($('content'));
				PelletStudio.displayRandomPictures();
			}
			break;
		}
	},
	displayRandomPictures:function() {
		if (!$('random-picture') || galleryState.randomSlideshowTimer!=false) {
			return;
		}
		var picture = picturesArray.flatten().getRandom();


		if ($('pic-frame')) {
			var myFx = new Fx.Tween('pic-frame', {property: 'opacity',duration:'long'});
			myFx.start(1,0).chain(function(){
				$('pic-frame').empty();
				Element('img', {'id':"p"+picture.id,'src': picture.src,'class':'pic'}).inject($('pic-frame'));
				this.start(0,1).chain(
				    function(){ 
					galleryState.randomSlideshowTimer=setTimeout("galleryState.randomSlideshowTimer=false;PelletStudio.displayRandomPictures()",5000); 
					}
			);

			});
			return;
		}

		var roll     = new Element('div', {'id':'roll'}).inject($('content'));
		var frame    = new Element('div', {'id':'pic-frame'}).inject($('content'));
		new Element('div', {'id':'frame-glass'}).inject($('content'));
		Element('img', {'id':"p"+picture.id,'src': picture.src,'class':'pic'}).inject($('pic-frame'));

		var myFx = new Fx.Tween('pic-frame', {property: 'opacity',duration:'long'});
		myFx.start(0,1).chain(
		    function(){ 
			setTimeout("PelletStudio.displayRandomPictures()",5000); 
			}
		);

//		$('pic-frame').set('tween', {transition: Fx.Transitions.Quint.easeOut, duration:'long'});
//		$('pic-frame').tween('opacity', 1).delay(5000).chain(displayRandomPictures);

		


		START=false;
	},//TODO change about page
	displayAbout:function() {
		$('content').empty();
		var about    = new Element('div', {'id':'about'}).inject($('content'));
		about.set("html","<strong>On Location Photoshoot - portrait / children / family - $175 </strong><br><br>\
I can come and setup a mobile studio at any location within the Wellington Region for a photoshoot. Choose a meaningful place to make a truly personal experience of this moment. Each photoshoot will take 40 to 50 minutes.<br>\
<br>\
You will get a minimum of 15 high resolution photos (a mix of B&W and colour) in a digital format. I can arrange for canvas prints and enlargements.</br></br>\
After the first 20kms a $1 per km travel charge may apply.\
<!--br><br><br><strong>Events / Sports - POA </strong><br><br-->\
");

	},//TODO change contact page
	displayContact:function() {
		$('content').empty();
		var about    = new Element('div', {'id':'contact'}).inject($('content'));
		about.set("html","<center><strong>Julien Pellet - Wellington</strong><br>\
021 028 66409<br><A HREF='mailto:contact@julienpellet.com'>contact@julienpellet.com</A></center>");
		
	},

	displayPic : function (pictureId){
		if($('pic-frame')) {

			var myFx = new Fx.Tween('pic-frame', {property: 'opacity'});
			myFx.start(1,0).chain(
				function(){
					$('pic-frame').empty();
					var src=galleryData[pictureId].src;
					Element('img', {'id':"p"+pictureId,'src': src,'class':'pic'}).inject($('pic-frame'));

					$('pic-frame').set('tween', {transition: Fx.Transitions.Quint.easeOut, duration:'long'});
					$('pic-frame').tween('opacity', 1);
				});
		} else {

			$('content').empty();
			PelletStudio.displayRoll();

			if (galleryData[pictureId].position>=galleryState.maxPicsInRoll) {

				var decalage=galleryData[pictureId].position+galleryState.maxPicsInRoll-galleryState.galleryLength;
				if (decalage<0)
					decalage=0;
					

				$('roll-prev').style.visibility="hidden";
				$('roll-next').style.visibility="hidden";


//				if ($(pictureId).style.display=="none")
				Array.each(galleryData, function(picture, id){
					if(picture.position<galleryData[pictureId].position-decalage) 
					{
						$(picture.id.toString()).style.display="none";
						$(picture.id.toString()).tween('width',0);
						$('roll-prev').style.visibility="visible";
						galleryState.firstPictureInRoll=picture.next;
					}					
					else if(picture.position>galleryData[pictureId].position+6)
					{
//						$(picture.id.toString()).style.display="none";
//						$(picture.id.toString()).tween('width',0);
						$('roll-next').style.visibility="visible";
					}
				});

			}

			var src=galleryData[pictureId].src;
			Element('img', {'id':"p"+pictureId,'src': src,'class':'pic'}).inject($('pic-frame'));

			$('pic-frame').set('tween', {transition: Fx.Transitions.Quint.easeOut, duration:'long'});
			$('pic-frame').tween('opacity', 1);
			new Element('div', {'id':'frame-glass'}).inject($('content'));

		}

		galleryState.currentPicture = pictureId;
		$(pictureId.toString()).tween("opacity",1);
		$(pictureId.toString()).removeEvents("mouseout");
		

	},
	displayRoll : function (pictureId){

		var roll     = new Element('div', {'id':'roll'}).inject($('content'));
		var frame    = new Element('div', {'id':'pic-frame'}).inject($('content'));
				
		new Element('div',{'id':'roll-next'}).inject(roll);
		new Element('div',{'id':'roll-prev'}).inject(roll);

		$('roll-next').addEvent('click', function(e) {PelletStudio.rollNext()});
		$('roll-prev').addEvent('click', function(e) {PelletStudio.rollPrev()});
		

		new Element('div',{'id':'roll-container'}).inject(roll);

		galleryState.firstPictureInRoll=false;

		Array.each(galleryData, function(picture, id){
			if (!galleryState.firstPictureInRoll) {
				galleryState.firstPictureInRoll=id;
			}

			var container = new Element('div', {'class': 'thumb-roll-container','id': 'roll-'+id});//.inject(li);;
			var link   = new Element('a', {'class': 'thumb-roll','href': '#'+id}).inject(container);

			var thumb = picture.imageDOM.getElementsByTagName('img')[0].clone(true,true).inject(link);

			var footer = new Element('span').inject(thumb,'after');
			footer.addClass('title');
//			footer.set('text', title);

			var footer = new Element('span').inject(thumb,'after');
			footer.addClass('title');
//			footer.set('text', title);


			thumb.set('tween', {transition: Fx.Transitions.Quint.easeOut, duration:750});
			thumb.addEvents({
			    mouseenter: function(){
					if (!galleryState.rollSliding)
						thumb.tween('opacity', 1);
				},
			    mouseout: function(){
					if (!galleryState.rollSliding)
						thumb.tween('opacity', 0.5);
				},
			    click:function(){
					if (galleryState.currentPicture) {
						$(galleryState.currentPicture.toString()).tween('opacity', 0.5);
						$(galleryState.currentPicture.toString()).addEvents({
						    mouseout: function(){
								this.tween('opacity', 0.5);
							}});
					}
					thumb.removeEvents("mouseout");
//					PelletStudio.displayPic(thumb.id);
				}
			});

			$('roll-container').appendChild(container); //"true,true" : keep content, keep id
		});

		if (!galleryData[galleryState.firstPictureInRoll].last) {
			$('roll-prev').style.visibility="hidden";
		}

		if (galleryState.galleryLength<=galleryState.maxPicsInRoll) {
			$('roll-next').style.visibility="hidden";
		}
		

//		galleryState.rollUnitWidth=$(galleryState.firstPictureInRoll.toString()).width;


	},
	rollNext : function(){
		if (galleryData[galleryState.firstPictureInRoll].next) {
			$('roll-prev').style.visibility="visible";
			
			var thumbId=galleryState.firstPictureInRoll.toString();
			var myFx = new Fx.Tween(thumbId, {property: 'width'});
			myFx.start(galleryState.rollUnitWidth,0).chain(
				function(){
					$(thumbId.toString()).style.display="none";
				}
			);


			galleryState.firstPictureInRoll = galleryData[galleryState.firstPictureInRoll].next;

			if(galleryData[galleryState.firstPictureInRoll].position+galleryState.maxPicsInRoll>=galleryState.galleryLength) {
				$('roll-next').style.visibility="hidden";
			}

		}

	},
	rollPrev : function(){
		var prevPicId = galleryData[galleryState.firstPictureInRoll.toString()].last;
		//console.log(prevPicId);
		if (prevPicId) {
			
			galleryState.rollSliding=true;
			$('roll-next').style.visibility="visible";
			$(prevPicId.toString()).style.display="";


			var myFx = new Fx.Tween(prevPicId, {property: 'width'});
			
			//TODO fixed bug here			
			myFx.start(0,galleryState.rollUnitWidth).chain(
				function(){
					galleryState.rollSliding=false;					
				}
			);
			


//			$(prevPicId.toString()).set('tween', {transition: Fx.Transitions.Quint.easeOut});
//			$(prevPicId.toString()).tween('width', galleryState.rollUnitWidth);


			galleryState.firstPictureInRoll=prevPicId;
			if (!galleryData[galleryState.firstPictureInRoll.toString()].last) {
				$('roll-prev').style.visibility="hidden";
			}
		}
	},
	galleriesLoaded:function() {
		PelletStudio.hashChanged();
	},
		
	displayGallery:function(galleryName){
		$('content').empty();

		galleryState.galleryLength=galleryStorage[galleryName].flatten().length;
		loadGallery(galleryName);
	}
}
window.addEvent('load', PelletStudio.start);

