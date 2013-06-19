angular.module("zj.namedRoutes", []).
    factory("$NamedRouteService", function($rootScope, $route, $Application, $log){
        var routeService = {
            reverse: function (routeName, options) {
                /*  1. Step through routes,
                        build list of matching routes,
                    2. replace placeholders with supplied arguments,
                    3. return built url.
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
                // 1. pick matching routes
                    routes = []
                    angular.forEach($route.routes,function (config,route) {
                        if(config.name===routeName){
                            routes.push(route);
                        }
                    });
                    return routes;
                },
            resolve: function(options, route) {
                // 2. replace placholders with supplied arguments
                    var parts = route.split('/');
                    for (var i = 0; i < parts.length; i++) {
                        var part = parts[i];
                        if (part[0] === ':') {
                            parts[i] = options[part.replace(':', '')];
                            if (parts[i] == undefined) throw Error('Attribute \'' + part + '\' was not given for route \'' + route + '\'')
                        }
                    }
                    // TODO: instead of hardcoding the hash here, workout a way to do
                    //       this based on the application config.
                    return "#" + parts.join('/');
                }
            }

        return routeService;
    }).

    directive('zjNamedRoute', function($log, $NamedRouteService){
            /*  Given that the following route exists :
                    .when('/products/:cat/:id', {
                        controller: 'OptionalController',
                        template: '/static/javascripts/application/templates/optional-template.html',
                        name: 'item-detail'
                    })

                And that an element is present :
                    <a data-zj-named-route='item-detail'
                    data-zj-named-kwargs='{pk: 1, category:"fish"}' # or
                    data-zj-named-args='[1, "fish"]'
                    data-zj-named-target='href'>Salmon Info</a>

                Return the following
                    <a href="#/products/fish/1/">Salmon Info</a>
             */
            return {
                restrict: "AC",
                link: function(scope, element, attributes){
                    var targetAttribute = 'zjNamedTarget' in attributes?attributes.zjNamedTarget:'href'
                    element.attr(targetAttribute,
                        $NamedRouteService.reverse(attributes.zjNamedRoute, attributes.zjNamedArgs))
                }
            }
        }).

    filter('resolveroute', function ($route, $NamedRouteService) {
            /*
                <a data-ng-href="'something'|resolveroute">Something</a>
             */
            return function(input, options){
                return $NamedRouteService.reverse(input, options);
            };
        });