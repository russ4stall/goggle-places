<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Creepin'</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css" integrity="sha384-rwoIResjU2yc3z8GV/NPeZWAv56rSmLldC3R/AZzGRnGxQQKnKkoFVhFQhNUwEyJ"
            crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.4.0/js/tether.min.js" integrity="sha384-DztdAPBWPRXSA/3eYEEUWrWCy7G5KFbe8fFjk5JAIxUYHKkDx6Qin1DkWx51bBrb"
            crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/js/bootstrap.min.js" integrity="sha384-vBWWzlZJ8ea9aCX4pEW3rVHjgjt7zpkNpZk+02D9phzyeVkE+jo0ieGizqPLForn"
            crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/knockout/3.4.2/knockout-min.js"></script>

    </head>

    <body class="mt-5">
        <div class="container">
            <div class="row">
                <div class="col-3">
                    <label for="">Search</label>
                    <input class="form-control" type="text" name="searchTerm" data-bind="value: searchTerm">
                </div>
                <div class="col-3">
                    <label for="">Type</label>
                    <input class="form-control" type="text" name="type" data-bind="value: type">
                </div>
                <div class="col-2">
                    <button type="button" class="btn btn-primary" data-bind="click: search">Search</button>
                </div>
            </div>
            <div class="row mt-5">
                <div class="col">
                    <table id="place-table" class="table table-sm table-responsive">
                        <thead>
                            <tr>
                                <th>Place Id</th>
                                <th>Icon</th>
                                <th>Name</th>
                                <th>Vicinity</th>
                                <th>Image Ref</th>
                            </tr>
                        </thead>
                        <tbody data-bind="foreach: places">
                            <tr>
                                <td data-bind="text: $data.placeId"></td>
                                <td>
                                    <img width="20px" data-bind="attr: {src: $data.icon}">
                                </td>
                                <td data-bind="text: $data.name"></td>
                                <td data-bind="text: $data.vicinity"></td>
                                <td data-bind="text: $data.imageRef"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="row" data-bind="visible: nextPageToken() != undefined">
                <div class="col">
                    <button type="button" class="btn btn-primary" data-bind="click: nextPage">Load More</button>
                </div>
            </div>
        </div>

        <script>
            var Place = function (placeId, name, icon, imageRef, vicinity) {
                var self = this;
                this.placeId = ko.observable(placeId);
                this.name = ko.observable(name);
                this.icon = ko.observable(icon);
                this.imageRef = ko.observable(imageRef);
                this.vicinity = ko.observable(vicinity);
            };

            var ViewModel = function () {
                var self = this;
                this.places = ko.observableArray();
                this.searchTerm = ko.observable();
                this.type = ko.observable();
                this.latitude = ko.observable();
                this.longitude = ko.observable();
                this.nextPageToken = ko.observable();

                this.nextPage = function () {
                    var reqParams = {
                        searchTerm: this.searchTerm(),
                        type: this.type(),
                        latitude: this.latitude(),
                        longitude: this.longitude(),
                        nextPageToken: this.nextPageToken()
                    }
                    
                    self.getSearchResults(reqParams);
                }

                this.search = function () {
                    var reqParams = {
                        searchTerm: this.searchTerm(),
                        type: this.type(),
                        latitude: this.latitude(),
                        longitude: this.longitude()
                    }

                    self.places.removeAll();
                    self.getSearchResults(reqParams);
                };

                this.getSearchResults = function (reqParams) {
                    $.getJSON("/api/places", reqParams, function (data) {
                        self.nextPageToken(data.nextPageToken);
                        $.each(data.results, function (key, p) {
                            var imageRef = "";
                            if (p.photos != undefined) {
                                imageRef = p.photos[0].photoReference;
                            }

                            self.places.push(new Place(p.placeId, p.name, p.icon, imageRef, p.vicinity));
                        });
                    });
                }
            };

            $(document).ready(function () {
                var viewModel = new ViewModel();
                ko.applyBindings(viewModel);

                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(function (position) {
                        viewModel.latitude(position.coords.latitude);
                        viewModel.longitude(position.coords.longitude);
                    });
                }

            });
        </script>
    </body>

    </html>