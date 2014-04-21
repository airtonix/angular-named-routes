angular.module "zj.namedRoutes", []

  .provider "$NamedRouteService", [
    "$locationProvider"
    ($locationProvider) ->
      # pull prefix as set by the project integrator :
      # angular.module('yourmodule', ['zj.namedRoutes'])
      #   .config([
      #     '$locationProvider',
      #     function($locationProvider){
      #         $locationProvider.hashPrefix("#!")
      #         $locationProvider.html5Mode(false)
      #          ...

      prefix = if not $locationProvider.html5Mode() then $locationProvider.hashPrefix() else ""

      this.$get = [
        '$rootScope'
        '$route'
        '$location'
        '$log'
        ($rootScope, $route, $location, $log) ->
          type = (obj) ->
            if obj == undefined or obj == null
              return String obj
            classToType =
              '[object Boolean]': 'boolean'
              '[object Number]': 'number'
              '[object String]': 'string'
              '[object Function]': 'function'
              '[object Array]': 'array'
              '[object Date]': 'date'
              '[object RegExp]': 'regexp'
              '[object Object]': 'object'
            classToType[Object.prototype.toString.call(obj)]

          routeService =
            reverse: (routeName, options) ->
              # /* Step through routes,
              #     pick one with matching name,
              #     replace placeholders with supplied arguments,
              #     return built url.
              # */
              routes = routeService.match(routeName);
              if routes.length == 1
                  return routeService.resolve options, routes[0]
              else if routes.length is 0
                  throw new Error 'Route ' + routeName + ' not found'
              throw new Error 'Multiple routes matching ' + routeName + ' were found'

            match: (routeName) ->
              routes = []
              angular.forEach $route.routes, (config, route) ->
                  if config.name is routeName
                      routes.push route
              return routes

            resolve: (options, route) ->
              pattern = /(\:\w+)/g

              if route is undefined
                throw new Error("Can't resolve undefined into a route")

              count = 0
              prefix + route.replace pattern, (match, ..., offset) ->
                if type(options) is 'array'
                  output = options[count]
                  count++
                  return output
                else if type(options) is 'object'
                  return options[match.slice(1)]

      ]
      return this
    ]

    .directive 'namedUrl', [
      '$log'
      '$NamedRouteService'
      ($log, $NamedRouteService) ->
        # /* Given that the following route exists :
        #         .when('/products/:cat/:id', {
        #             controller: 'OptionalController',
        #             template: '/static/javascripts/application/templates/optional-template.html',
        #             name: 'item-detail'
        #         })

        #    And that an element is present :
        #      <a data-named-url='item-detail'
        #      data-named-args='["fish", 1]'
        #      data-named-target='href'>Salmon Info</a>

        #      return the following
        #      <a href="#/products/fish/1/">Salmon Info</a>
        #  */
        restrict: "AC"
        link: (scope, element, attributes) ->
            options = {}
            for key in attributes
              if key.indexOf('kwarg') is 0
                newKey = key.splice 0, 5
                newKey = newKey.charAt(0).toLowerCase() + newKey.slice(1)
                options[newKey] = attributes[key]

            url = $NamedRouteService.reverse attributes.namedUrl, options
            element.attr 'href', url

      ]

    .filter 'url', [
      '$route'
      '$NamedRouteService'
      ($route, $NamedRouteService) ->
        (input, options) ->
          $NamedRouteService.reverse input, options
    ]
