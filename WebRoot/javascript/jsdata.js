document.write('<form id=\'subF\' action=\'\' method=\'POST\'>');
document.write('<input name=\'jsdata\' id=\'jsdata\' type=\'hidden\' />');
document.write('<input name=\'round\' id=\'round\' type=\'hidden\' />');
document.write('</form>');
//----------JSData----------------
function __jsdata_item() {
	var zone;
	var key;
	var val;
}
var jsitem = __jsdata_item;
var __jsdata_items = new Array();

function put(zone, key, val) {
	var it = get(zone, key);
	if (it == null) {
		it = new __jsdata_item();
		it.zone = zone;
		it.key = key;
		it.val = val;
		__jsdata_items.push(it);
	} else {
		__jsdata_items[it.index].val = val;
	}

}

function get(zone, key) {
	for (var i = __jsdata_items.length - 1; i >= 0; i--) {
		var it = __jsdata_items[i];
		if (it.zone == zone && it.key == key) {
			it.index = i;
			return it;
		}
	}
	return null;
}

function getVal(zone, key) {
	for (var i = __jsdata_items.length - 1; i >= 0; i--) {
		var it = __jsdata_items[i];
		if (it.zone == zone && it.key == key) {
			it.index = i;
			return it.val;
		}
	}
	return null;
}

function getJsdataByEncodedString() {
	var str = '[';
	for (var i = __jsdata_items.length - 1; i >= 0; i--) {
		var it = __jsdata_items[i];
		if(it.zone == 'globle' || it.zone == 'request'){
			var valt = it.val;
			if(valt.indexOf('back') > -1 && valt.indexOf('target') > -1 && valt.indexOf('params') > -1) str = str + '{\'zone\':\'' + it.zone + '\',\'key\':\'' + it.key + '\',\'val\':' + it.val + '}';
			else str = str + '{\'zone\':\'' + it.zone + '\',\'key\':\'' + it.key + '\',\'val\':\'' + it.val + '\'}';
			if (i != 0)
				str += ',';
		}
	}
	str += ']';
	str = encodeURIComponent(str.indexOf(',]') > -1 ? str.replace(',]', ']') : str);	
	return str;
}

function fillWithJson(str) {
	var jt = eval(str);
	for (var i = 0; i < jt.length; i++) {
		put(jt[i].zone, jt[i].key, jt[i].val);
	}
}

function skip(url){
	window.location.href = url;
}

function go(url){
	act(url, 'no');
}

function round(url){
	act(url, 'yes');
}

function act(url, flag){
	$g('subF').action = url;
	$g('jsdata').value = getJsdataByEncodedString();
	$g('round').value = flag;
	setTimeout(function(){$g('subF').submit();}, 500);
}

function act_hid(url, flag){
	var inputwin = document.createElement('input');
	var inputrod = document.createElement('input');
	inputwin.type = 'hidden';
	inputwin.name = 'jsdata';
	inputwin.value = getJsdataByEncodedString();
	inputrod.type = 'hidden';
	inputrod.name = 'round';
	inputrod.value = flag;
	var formredwin = document.createElement('form');
	formredwin.method = 'POST';
	document.body.appendChild(formredwin);
	formredwin.appendChild(inputwin);
	formredwin.appendChild(inputrod);
	formredwin.action = url;
	formredwin.submit();
	formredwin.parentNode.removeChild(formredwin);
}
// -------------end JSData-----------------