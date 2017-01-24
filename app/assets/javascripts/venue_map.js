if (document.getElementById('venue_map')) {
  (function () {
    var myLatlng = new google.maps.LatLng(51.4944422, -2.6614699),
        mapCenter = new google.maps.LatLng(51.4944422, -2.6614699),
        mapCanvas = document.getElementById('venue_map'),
        mapOptions = {
          center: mapCenter,
          zoom: 13,
          scrollwheel: false,
          draggable: false,
          disableDefaultUI: true,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        },
        map = new google.maps.Map(mapCanvas, mapOptions),
        contentString =
          '<div id="content">'+
          '<div id="siteNotice">'+
          '</div>'+
          '<a target="_blank" href="https://www.google.co.uk/maps/place/Kings+Weston+House/@51.4944422,-2.6614699,15z/">' +
          '<h1 id="firstHeading" class="firstHeading">Kings Westen House</h1>'+
          '<div id="bodyContent"'+
          '<p>Bristol, BS11 0UR</p>'+
          '</a>' +
          '</div>'+
          '</div>',
        infowindow = new google.maps.InfoWindow({
          content: contentString,
          maxWidth: 300
        }),
        marker = new google.maps.Marker({
          position: myLatlng,
          map: map,
          title: 'Kings Westen House'
        });

    return {
      init: function () {
        map.set('styles', [{
          featureType: 'landscape',
          elementType: 'geometry',
          stylers: [
            { hue: '#ffff00' },
            { saturation: 30 },
            { lightness: 10}
          ]}
        ]);

        google.maps.event.addListener(marker, 'click', function () {
          infowindow.open(map,marker);
        });

        google.maps.event.addDomListener(window, 'resize', function() {
          map.setCenter(mapCenter);
        });

      }
    };
  }()).init();

}

