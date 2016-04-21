var map1;


Template.googleMaps.rendered = function () {
  initMap();
};


Template.googleMaps.helpers({
  scheduled: function() {
    return Scheduled.find({});
  },
  denied: function() {
    return Denied.find({});
  },
  addMapMarker: function(pickupAddress, name, pickupTime) {
    var mygc = new google.maps.Geocoder();
    mygc.geocode({'address' : pickupAddress}, function(results, status){

        var latitude = results[0].geometry.location.lat();
        var longitude = results[0].geometry.location.lng();
        var latLng = new google.maps.LatLng(latitude, longitude);

        var marker = new google.maps.Marker({
          position: latLng,
          map: map1,
        });
        marker.setIcon('https://maps.google.com/mapfiles/ms/icons/green-dot.png');
        var infowWndow = new google.maps.InfoWindow({
          content: "<strong>" + name + " @ " + pickupTime + "</strong><br>" + pickupAddress
        });
        google.maps.event.addListener(marker, 'click', function() {
          infowWndow.open(map1, marker);
        });

    });
  }
});

initMap = function() {
  var mapOptions1 = {
      zoom: 13,
      center: new google.maps.LatLng(44.044824, -123.072567),
      // Style for Google Maps
      styles: [{
          "featureType": "water",
          "stylers": [{"saturation": 43}, {"lightness": -11}, {"hue": "#0088ff"}]
      }, {
          "featureType": "road",
          "elementType": "geometry.fill",
          "stylers": [{"hue": "#ff0000"}, {"saturation": -100}, {"lightness": 99}]
      }, {
          "featureType": "road",
          "elementType": "geometry.stroke",
          "stylers": [{"color": "#808080"}, {"lightness": 54}]
      }, {
          "featureType": "landscape.man_made",
          "elementType": "geometry.fill",
          "stylers": [{"color": "#ece2d9"}]
      }, {
          "featureType": "poi.park",
          "elementType": "geometry.fill",
          "stylers": [{"color": "#ccdca1"}]
      }, {
          "featureType": "road",
          "elementType": "labels.text.fill",
          "stylers": [{"color": "#767676"}]
      }, {
          "featureType": "road",
          "elementType": "labels.text.stroke",
          "stylers": [{"color": "#ffffff"}]
      }, {"featureType": "poi", "stylers": [{"visibility": "off"}]}, {
          "featureType": "landscape.natural",
          "elementType": "geometry.fill",
          "stylers": [{"visibility": "on"}, {"color": "#b8cb93"}]
      }, {"featureType": "poi.park", "stylers": [{"visibility": "on"}]}, {
          "featureType": "poi.sports_complex",
          "stylers": [{"visibility": "on"}]
      }, {"featureType": "poi.medical", "stylers": [{"visibility": "on"}]}, {
          "featureType": "poi.business",
          "stylers": [{"visibility": "simplified"}]
      }]
  };

  // Get all html elements for map
  var mapElement1 = document.getElementById('map1');

  // Create the Google Map using elements
  map1 = new google.maps.Map(mapElement1, mapOptions1);

  // Create marker
  var marker = new google.maps.Marker({
    map: map1,
    position: new google.maps.LatLng(44.044824, -123.072567),
    title: 'Area of Service'
  });

  // Add circle overlay and bind to marker
  var circle = new google.maps.Circle({
    map: map1,
    radius: 4828.03,    // 3 miles in meters
    fillColor: '#'
  });
  circle.bindTo('center', marker, 'position');

} // end initMap
