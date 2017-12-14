function setWatermarkBorder(){
	var watermarks = document.getElementsByClassName('Watermark');
	if(watermarks && ! watermarks.empty()){
		watermarks.forEach(initialWatermark());
	}
}
function initialWatermark(item, index){
	var table = item.getElementsByTagName('table');
	var tableBorder = table.getBoundingClientRect();
	item.style.left = tableBorder.left;
	item.style.top = tableBorder.top;
	item.style.right = tableBorder.right;
	item.style.bottom = tableBorder.bottom;
}