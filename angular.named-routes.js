angular.module("zj.namedRoutes", [])
    // as a non standard way to fix html5Mode
    // set this to something like :
    // .constant("NamedRoutesPrefix", "#!")
    .constant("NamedRoutesPrefix", "")
    .factory("$NamedRouteService", function($rootScope, $route, $location, $Application, $log, NamedRoutesPrefix){
        var routeService = {
            reverse: function (routeName, options) {
                    /* Step through routes,
                        pick one with matching name,
                        replace placeholders with supplied arguments,
                        return built url.
                    */
                    var routes = routeService.match(routeName);
                    if (routes.length == 1) {
                        return routeService.resolve(options, routes[0]);
                    }else if (routes.length == 0) {
                        throw Error('Route ' + routeName + ' not found');
                    }
                    throw Error('Multiple routes matching ' + routeName + ' were found');
                },

            match: function(routeName){
                    routes = []
                    angular.forEach($route.routes,function (config,route) {
                        if(config.name===routeName){
                            routes.push(route);
                        }
                    });
                    return routes;
                },
            resolve: function(options, route) {
                    var parts = route.split('/');
                    for (var i = 0; i < parts.length; i++) {
                        var part = parts[i];
                        if (part[0] === ':') {
                            parts[i] = options[part.replace(':', '')];
                            if (parts[i] == undefined) throw Error('Attribute \'' + part + '\' was not given for route \'' + route + '\'')
                        }
                    }
                    var output = parts.join('/');
                    return NamedRoutesPrefix+output
                }
            }

        return routeService;
    })

    .directive('namedUrl', function($log, $NamedRouteService){
            /* Given that the following route exists :
                    .when('/products/:cat/:id', {
                        controller: 'OptionalController',
                        template: '/static/javascripts/application/templates/optional-template.html',
                        name: 'item-detail'
                    })

               And that an element is present :
                 <a data-named-url='item-detail'
                 data-named-args='["fish", 1]'
                 data-named-target='href'>Salmon Info</a>

                 return the following
                 <a href="#/products/fish/1/">Salmon Info</a>
             */
            return {
                restrict: "AC",
                link: function(scope, element, attributes){
                    var options = {};
                    var newKey;
                    for(var key in attributes){
                        if(key.indexOf(kwarg)==0){
                            newKey = key.replace('kwarg','');
                            newKey = newKey.charAt(0).toUpperCase() + newKey.slice(1);
                            options[newKey] = attributes[key];
                        }
                    }
                    var url = $NamedRouteService.reverse(attributes.namedUrl, options)
                    element.attr('href', url)
                }
            }
        })

    .filter('url', function ($route, $NamedRouteService) {
            return function(input, options){
                return $NamedRouteService.reverse(input, options);
            };
        });
