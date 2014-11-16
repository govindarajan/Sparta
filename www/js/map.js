function drawMap()
    {
        var latlng = new google.maps.LatLng(currentLatitude,currentLongitude);
        var mapOptions = {
            zoom:10,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.HYBRID,
			zoomControl: true,
            zoomControlOptions: {
              style: google.maps.ZoomControlStyle.SMALL,
			  position: google.maps.ControlPosition.LEFT_TOP
            },
        };

        if (boolTripTrack==true)
        {
            _map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
        }
    }
</code></td></tr></table>

<p>Finally, once the map is drawn, the geolocation coordinates are plotted using this code.  </p>
<table><tr><td><code>
	var suc = function(p){
		console.log("geolocation success",4);

		if( _map == null ) {
			currentLatitude = p.coords.latitude;
			currentLongitude = p.coords.longitude;
			drawMap();
		}

	  	var myLatLng = new google.maps.LatLng(p.coords.latitude, p.coords.longitude);
	  	var beachMarker = new google.maps.Marker({
		  position: myLatLng,
		  map: _map
		});

		if( _llbounds == null )
			_llbounds = new google.maps.LatLngBounds(new google.maps.LatLng(p.coords.latitude, p.coords.longitude));
		else
			_llbounds.extend(new google.maps.LatLng(p.coords.latitude, p.coords.longitude));
		_map.fitBounds(_llbounds);
	};

	var fail = function(){
		console.log("Geolocation failed. \nPlease enable GPS in Settings.",1);
	};
