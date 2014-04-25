(function() {
  angular.module("zj.namedRoutes", []).provider("$NamedRouteService", [
    "$locationProvider", function($locationProvider) {
      var prefix;
      prefix = !$locationProvider.html5Mode() ? $locationProvider.hashPrefix() : "";
      this.$get = [
        '$rootScope', '$route', '$location', '$log', function($rootScope, $route, $location, $log) {
          var routeService, type;
          type = function(obj) {
            var classToType;
            if (obj === void 0 || obj === null) {
              return String(obj);
            }
            classToType = {
              '[object Boolean]': 'boolean',
              '[object Number]': 'number',
              '[object String]': 'string',
              '[object Function]': 'function',
              '[object Array]': 'array',
              '[object Date]': 'date',
              '[object RegExp]': 'regexp',
              '[object Object]': 'object'
            };
            return classToType[Object.prototype.toString.call(obj)];
          };
          return routeService = {
            reverse: function(routeName, options) {
              var routes;
              routes = routeService.match(routeName);
              if (routes.length === 1) {
                return routeService.resolve(options, routes[0]);
              } else if (routes.length === 0) {
                throw new Error('Route ' + routeName + ' not found');
              }
              throw new Error('Multiple routes matching ' + routeName + ' were found');
            },
            match: function(routeName) {
              var routes;
              routes = [];
              angular.forEach($route.routes, function(config, route) {
                if (config.name === routeName) {
                  return routes.push(route);
                }
              });
              return routes;
            },
            resolve: function(options, route) {
              var count, pattern;
              pattern = /(\:\w+)/g;
              if (route === void 0) {
                throw new Error("Can't resolve undefined into a route");
              }
              count = 0;
              return prefix + route.replace(pattern, function() {
                var match, offset, output;
                match = arguments[0], offset = arguments[arguments.length - 1];
                if (type(options) === 'array') {
                  output = options[count];
                  count++;
                  return output;
                } else if (type(options) === 'object') {
                  return options[match.slice(1)];
                }
              });
            }
          };
        }
      ];
      return this;
    }
  ]).directive('namedUrl', [
    '$log', '$NamedRouteService', function($log, $NamedRouteService) {
      return {
        restrict: "AC",
        link: function(scope, element, attributes) {
          var attribute, newKey, options, url;
          options = {};
          for (attribute in attributes) {
            if (!(attribute.indexOf('kwarg') === 0)) {
              continue;
            }
            newKey = attribute.splice(0, 5);
            newKey = newKey.charAt(0).toLowerCase() + newKey.slice(1);
            options[newKey] = attributes[attribute];
          }
          url = $NamedRouteService.reverse(attributes.namedUrl, options);
          return element.attr('href', url);
        }
      };
    }
  ]).filter('url', [
    '$route', '$NamedRouteService', function($route, $NamedRouteService) {
      return function(input, options) {
        return $NamedRouteService.reverse(input, options);
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=named-routes.js.map
