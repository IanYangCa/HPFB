function setWatermarkBorder(){
	var watermarks = $(".Watermark");
	if(watermarks){
		//watermarks.forEach(initialWatermark);
		initialWatermark(watermarks, 1);
	}
}
function initialWatermark(item, index){
	var table = $(item).find('table');
	if(table){
		var watermarkText = $(item).find(".WatermarkTextStyle");
		var characters = (watermarkText.text()).length;
		var width = Math.sqrt($(table).height()*$(table).height()+$(table).width()*$(table).width())*0.9;
		var angle = Math.atan2($(table).height(),$(table).width())*180/Math.PI;
		var v_offset = $(table).height()/2 + $(watermarkText).height()/2; //$(table).height() / 2 + Math.cos(angle)*width/2;
		var h_offset = - (width - $(table).width())/2; //Math.sin(angle)*width/2 + $(table).width()/2;
		$(watermarkText).css("width", width);
		$(watermarkText).css({top : v_offset, left: h_offset});
		$(watermarkText).css("font-size", width / characters * 2 + "px");
		$(watermarkText).show();
		$(watermarkText).css({'transform' :  'rotate(-' + angle + 'deg)'});
	}
}
function twoColumnsDisplay(){
	$("#pageHeader").html(
			"<p class=\"pageTitle\">" 
			+ $("#pageTitle").html() + "</p><p>"
			+ "<span class=\"approveDate\">" 
			+ $("#approveDate").html() + "</span>"
			+ "<span class=\"marketStatus\">Market Status:</span>" 
			+ "<span class=\"revisionDate\">" + $("#revisionDate").html() + "</span></p>"
	);
	$("#toc").css('height', ($(window).height() - $("#pageHeader").height() - 10) + 'px');
	
	$("#toc").html(
			"<a href='#titlePage'><h1 style='text-transform:uppercase;'>" + $("#titlePage").attr("toc") + "<h1></a>" +
			"<a href='#440'><h1 style='text-transform:uppercase;'>" + $(".Section[data-sectioncode='440'] h2").html() + "</h1></a>" +
			$("#tableOfContent").html()
	);
	$("#spl").css('height', ($(window).height() - $("#pageHeader").height() - 10) + 'px');
	$("#tableOfContent").hide();
	$(".leftColumn h1").css("white-space","nowrap");
	$(".leftColumn h2").css("white-space","nowrap");
	$(".leftColumn h3").css("white-space","nowrap");
	$(".leftColumn h4").css("white-space","nowrap");
	$(".leftColumn h5").css("white-space","nowrap");
	$(".leftColumn h1").css("font-size","18px");
	$(".leftColumn h2").css("font-size","16px");
	$(".leftColumn h3").css("font-size","14px");
	$(".leftColumn h4").css("font-size","14px");
	$(".leftColumn h5").css("font-size","14px");
}