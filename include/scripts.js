
var current_el = null;
var loading;
var began = false      
function getItems(input, response){	

	if (response != ''){ 		
	    // Response mode	
	    //alert(response)    
        current_el.innerHTML = response;
        loading.style.display = 'none'
	}else{
		// Input mode			
		var url  = "process_request.asp?p=" + input + "&hash=" + Math.random();
		//alert(url)
		loadXMLDoc(url);		
	}
}

function loadItems(id,c){ 
	var img = null;
	if(arguments.length<2){
		c = "C" + id;
		img = document.getElementById("I"+id);
	}
	//alert(c)
	current_el = document.getElementById(c);
	if(current_el.style.display == 'none'){
		current_el.style.display = ''
		if(img){if(img.src.indexOf("Off") == -1){img.src = "../images/minus.gif"}else{img.src = "../images/minusOff.gif"}};
	}else{
		current_el.style.display = 'none'
		if(img){if(img.src.indexOf("Off") == -1){img.src = "../images/plus.gif"}else{img.src = "../images/plusOff.gif"}};
	}
	if(current_el.innerHTML == ''){
		loading.style.display = ''
		getItems(id,'');		
	}
}

function buildTree(id){
	if (!began){
		loading = document.getElementById("Loading")
		document.getElementById(id).style.display = 'none';
		began = true;
	}
	loadItems(0,id)
}

