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
