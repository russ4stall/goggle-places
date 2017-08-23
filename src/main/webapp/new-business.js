$(document).ready(function () {
    $("#phone").mask("?(999) 999-9999");
    $("#bizName").focus(geolocate);

    var bizViewModel = new BizViewModel();
    ko.applyBindings(bizViewModel);

    var autocomplete = new google.maps.places.Autocomplete(document.getElementById('bizName'), { types: ['establishment'] });

    autocomplete.addListener('place_changed', function () {
        bizViewModel.loadPlace(this.getPlace());
        $("#bizPic").attr('src', bizViewModel.imgUrl());
    });

    function geolocate() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {
                var geolocation = {
                    lat: position.coords.latitude,
                    lng: position.coords.longitude
                };
                var circle = new google.maps.Circle({
                    center: geolocation,
                    radius: position.coords.accuracy
                });
                autocomplete.setBounds(circle.getBounds());
            });
        }
    }
});

function parseAddress(address_components) {
    var address = {};
    address_components.forEach(function (c) {
        switch (c.types[0]) {
            case 'street_number':
                address.streetNumber = c.short_name;
                break;
            case 'route':
                address.streetName = c.short_name;
                break;
            case 'locality':
                address.city = c.short_name;
                break;
            case 'administrative_area_level_1':
                address.state = c.short_name;
                break;
            case 'postal_code':
                address.zip = c.short_name;
                break;
            case 'country':
                address.country = c.short_name;
                break;
        }
    });
    return address;
}

var BizViewModel = function () {
    this.name = ko.observable("");
    this.phone = ko.observable("");
    this.address1 = ko.observable("");
    this.address2 = ko.observable("");
    this.city = ko.observable("");
    this.state = ko.observable("");
    this.zip = ko.observable("");
    this.placeId = ko.observable("");
    this.imgUrl = ko.observable("");

    this.loadPlace = function (place) {
        let address = parseAddress(place.address_components);
        this.name(place.name);
        this.phone(place.formatted_phone_number);
        this.address1(address.streetNumber + " " + address.streetName);
        this.city(address.city);
        this.state(address.state);
        this.zip(address.zip);
        this.placeId(place.id);
        this.imgUrl(place.photos[0].getUrl({ maxWidth: 640 }));
    }
}