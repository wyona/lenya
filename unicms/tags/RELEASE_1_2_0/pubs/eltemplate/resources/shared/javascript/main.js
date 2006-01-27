function toggleLayer(id, visibility) {
          
	  var divs = document.getElementsByTagName("DIV");
          for(i = 0; i < divs.length; i++) {
            if (divs[i].id == id && divs[i].className == "tooltip") 
              { 
                var clone = divs[i].cloneNode(true);
              }
            }  
          var tooltips = document.getElementById("tooltips");
          
	  if (tooltips.hasChildNodes()) tooltips.removeChild(tooltips.childNodes.item(0));
         
	  var tooltip = tooltips.appendChild(clone);
	  tooltip.style.visibility = visibility;
}
