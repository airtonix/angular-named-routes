"use strict";

// Angular Named Routes
// https://github.com/airtonix/angular-named-routes
// https://github.com/airtonix/angular-named-routes/blob/master/angular.named-routes.js

var zj = angular.module("zj.namedRoutes", []);

zj.config(["$locationProvider", function($locationProvider) {
    zj.constant("NamedRoutesPrefix", ($locationProvider.html5Mode() ? '' : '#'));
}]);

zj.factory("$NamedRouteService", ["$rootScope", "$route", "NamedRoutesPrefix",
    function($rootScope, $route, NamedRoutesPrefix){
        return {
            reverse: function (routeName, options) {
                /* Step through routes,
                 pick one with matching name,
                 replace placeholders with supplied arguments,
                 return built url.
                 */
                var routes = this.match(routeName);
                if (routes.length == 1) {
                    return this.resolve(routes[0], options);
                }else if (routes.length === 0) {
                    throw new Error('Route ' + routeName + ' not found');
                }
                throw new Error('Multiple routes matching ' + routeName + ' were found');
            },

            match: function(routeName){
                var routes = [];
                angular.forEach($route.routes, function (config, route) {
                    if(config.name === routeName){
                        routes.push(route);
                    }
                });
                return routes;
            },

            resolve: function(route, options) {
                var parts = route.split('/');
                var attributes = angular.copy(options);
                var required = '';
                var extra = '';

                // Required attributes
                for (var i in parts) {
                    var part = parts[i];
                    if (part[0] === ':') {
                        var name = part.replace(':', '');
                        if (attributes[name] === undefined) throw new Error('Attribute \'' + name + '\' was not given for route \'' + route + '\'');
                        parts[i] = encodeURIComponent(attributes[name]);
                        delete attributes[name];
                    }
                }
                required += parts.join('/');

                // Extra attributes
                if (attributes) {
                    for (var key in attributes) {
                        extra += key + '=' + encodeURIComponent(attributes[key]).replace(/%20/g, '+') + '#';
                    }
                }

                return NamedRoutesPrefix + required + (extra ? '?' + extra : '');
            }
        };
    }
]);

/* Usage example:
 <a route="item-detail">Details</a>
 */
zj.directive('route', ["$NamedRouteService",
    function($NamedRouteService) {
        return {
            restrict: "A",
            link: function(scope, element, attributes){
                var url = $NamedRouteService.reverse(attributes.route, {});
                element.attr('href', url);
            }
        };
    }
]);

/* Usage example:
 <a link route-name="item-detail" route-params="{id:13}">Details</a>
 <button link route-name="submit">Submit</button>
 <link route-name="home">Home</link>
 */
zj.directive('link', ["$NamedRouteService", "$window",
    function($NamedRouteService, $window) {
        function updateLink(element, routeName, params) {
            var url = $NamedRouteService.reverse(routeName, params);
            var tagName = element[0].nodeName;

            if (tagName == 'A' || tagName == 'LINK') {
                element.attr('href', url);
                return;
            }
            
            element.unbind('click').click( function(event) {
                event.preventDefault();
                event.stopPropagation();
                $window.location = url;
            });
        };

        return {
            restrict: "AE",
            scope: {
                params: '=routeParams'
            },
            replace: true,
            transclude: true,
            template: function(tElement) {
                var tagName = tElement[0].nodeName;
                if (tElement[0].nodeName == 'LINK') tagName = 'A';
                return '<'+tagName+' ng-transclude></'+tagName+'>';
            },
            link: function(scope, element, attributes) {
                if (attributes.routeParams) {
                    scope.$watch('params', function(value) {
                        if (value != null && typeof value === 'object') {
                            for (var key in value) if (value[key] === undefined) return;
                            updateLink(element, attributes.routeName, value);
                        }
                    });
                } else {
                    updateLink(element, attributes.routeName, {});
                }
            }
        };
    }
]);

/* Usage example:
 <a href="[[ 'item-detail' | route:{id:13} ]]">Details</a>
 <form action="[[ 'item-detail' | route:{id:13} ]]">
 */
zj.filter('route', ["$NamedRouteService",
    function($NamedRouteService) {
        return function(input, options){
            return $NamedRouteService.reverse(input, options);
        };
    }
]);
