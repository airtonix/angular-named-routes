(function() {
  angular.module("zj.namedRoutes", []).provider("$NamedRouteService", [
    "$locationProvider", function($locationProvider) {
      this.$get = [
        '$rootScope', '$route', '$location', '$log', function($rootScope, $route, $location, $log) {
          var prefix, routeService, type;
          prefix = !$locationProvider.html5Mode() ? "#" + $locationProvider.hashPrefix() : "";
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
                return routeService.resolve(routes[0], options);
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
            resolve: function(route, options) {
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
  ]).directive('namedRoute', [
    '$log', '$NamedRouteService', function($log, $NamedRouteService) {
      return {
        restrict: "AC",
        link: function(scope, element, attributes) {
          var attribute, newKey, options, url, _ref;
          options = {};
          for (attribute in attributes) {
            if (!(attribute.indexOf('kwarg') === 0)) {
              continue;
            }
            newKey = attribute.slice(5);
            newKey = newKey.charAt(0).toLowerCase() + newKey.slice(1);
            options[newKey] = attributes[attribute];
            if (((_ref = attributes['$$observers']) != null ? _ref[attribute] : void 0) != null) {
              attributes.$observe(attribute, (function(value) {
                var url;
                options[this.key] = value;
                if (attributes.args != null) {
                  options = attributes.args.replace(/[\[\]\"\'\s]+/g, '').split(",");
                }
                url = $NamedRouteService.reverse(attributes.namedRoute, options);
                return element.attr('href', url);
              }).bind({
                key: newKey
              }));
            }
          }
          if (attributes.args != null) {
            options = attributes.args.replace(/[\[\]\"\'\s]+/g, '').split(",");
          }
          url = $NamedRouteService.reverse(attributes.namedRoute, options);
          return element.attr('href', url);
        }
      };
    }
  ]).filter('route', [
    '$route', '$NamedRouteService', function($route, $NamedRouteService) {
      return function(name, options) {
        return $NamedRouteService.reverse(name, options);
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=named-routes.js.map
