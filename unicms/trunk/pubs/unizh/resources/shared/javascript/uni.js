
  // MathML support
  window.addEventListener("load", fixMathMLNamespace, false);


  function changeIcontext(msg){
    document.getElementById("icontext").innerHTML = msg;
    if(msg == '') {
      document.getElementById("icontext").className = "icontextnobg";
    } else {
      document.getElementById("icontext").className = "icontextbg";
    }
  }

  // google map functions

  var baseIcon = new GIcon();
  baseIcon.image = "http://www.weboffice.uzh.ch/projekte/unicms/google/images/markers/marker.png";
  baseIcon.shadow = "http://www.weboffice.uzh.ch/projekte/unicms/google/images/markers/shadow50.png";
  baseIcon.iconSize = new GSize(20, 34);
  baseIcon.shadowSize = new GSize(37, 34);
  baseIcon.iconAnchor = new GPoint(9, 34);
  baseIcon.infoWindowAnchor = new GPoint(9, 2);
  baseIcon.infoShadowAnchor = new GPoint(18, 25);

  function GMultiMapload(maps) {
    if (GBrowserIsCompatible()) {
      for (var i in maps) {
        var map = GMapload(maps[i]);
      }
    }
  }

  function GMapload(mapData) {
    var center = new GLatLng(mapData.center.lat, mapData.center.lng);
    var map = new GMap2(document.getElementById(mapData.id));
    map.setCenter(center, mapData.scale);
    map.setMapType(mapData.type);
    if (mapData.control == "large") {
      map.addControl(new GLargeMapControl());
    }
    else {
      map.addControl(new GSmallMapControl());
    }
    if (mapData.typeControl) {
      map.addControl(new GMapTypeControl());
    }
    for (var i in mapData.markers) {
      var index = i - 0 + 1;
      var point = new GLatLng(mapData.markers[i].lat, mapData.markers[i].lng);
      map.addOverlay(createMarker(point, index, mapData.markers[i].label, mapData.numbered));
    }

    return map;
  }

  function createMarker(point, index, label, numbered) {
    var icon = new GIcon(baseIcon);
    if ( numbered && index && index > 0 ) {
      icon.image = "http://www.weboffice.uzh.ch/projekte/unicms/google/images/markers/marker" +  index +".png";
    }
    else {
      icon.image = "http://www.weboffice.uzh.ch/projekte/unicms/google/images/markers/marker.png";
    }
    var marker = new GMarker(point, icon);
    if (label != "") {
      GEvent.addListener(marker, "click", function() {marker.openInfoWindowHtml(label, {maxWidth: 100});});
    }

    return marker;
  }

  // mathML support

  /* March 19, 2004 MathHTML (c) Peter Jipsen http://www.chapman.edu/~jipsen
  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at
  your option) any later version.
  This program is distributed in the hope that it will be useful, but 
  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License 
  (at http://www.gnu.org/copyleft/gpl.html) for more details.*/


  function fixMathMLNamespace() {

    var mmlnode = document.getElementsByTagName("math");
    var st,str,node,newnode;

    for (var i=0; i<mmlnode.length; i++)
      if (document.createElementNS!=null)
        mmlnode[i].parentNode.replaceChild(convertMath(mmlnode[i]),mmlnode[i]);
      else { // convert for IE
        str = "";
        node = mmlnode[i];
        while (node.nodeName!="/MATH") {
          st = node.nodeName.toLowerCase();
          if (st=="#text") str += node.nodeValue;
          else {
            str += (st.slice(0,1)=="/" ? "</m:"+st.slice(1) : "<m:"+st);
            if (st.slice(0,1)!="/") 
              for(var j=0; j < node.attributes.length; j++)
                if (node.attributes[j].nodeValue!="italic" &&
                  node.attributes[j].nodeValue!="" &&
                  node.attributes[j].nodeValue!="inherit" &&
                  node.attributes[j].nodeValue!=undefined)
                  str += " "+node.attributes[j].nodeName+"="+
                     "\""+node.attributes[j].nodeValue+"\"";
            str += ">";
          }

          node = node.nextSibling;
          node.parentNode.removeChild(node.previousSibling);
        }
        str += "</m:math>";
        newnode = document.createElement("span");
        node.parentNode.replaceChild(newnode,node);
        newnode.innerHTML = str;
      }
  }


  function convertMath(node) {// for Gecko
     if (node.nodeType==1) {
       var newnode = document.createElementNS("http://www.w3.org/1998/Math/MathML",
       node.nodeName.toLowerCase());

       for(var i=0; i < node.attributes.length; i++)
         newnode.setAttribute(node.attributes[i].nodeName,

       node.attributes[i].nodeValue);

       for (var i=0; i<node.childNodes.length; i++) {
         var st = node.childNodes[i].nodeValue;
         if (st==null || st.slice(0,1)!=" " && st.slice(0,1)!="\n")    
         newnode.appendChild(convertMath(node.childNodes[i]));
       }
      return newnode;
    } else {
      return node;
    }
  } 

