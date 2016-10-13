angular.module "zj.namedRoutes", []

  .provider "$NamedRouteService", [
    "$locationProvider"
    ($locationProvider) ->
      this.$get = [
        '$rootScope'
        '$route'
        '$location'
        '$log'
        ($rootScope, $route, $location, $log) ->
          # pull prefix as set by the project integrator :
          # angular.module('yourmodule', ['zj.namedRoutes'])
          #   .config([
          #     '$locationProvider',
          #     function($locationProvider){
          #         $locationProvider
          #           .html5Mode(false)
          #           .hashPrefix("!");
          #
          prefix = if not $locationProvider.html5Mode() then "#" + $locationProvider.hashPrefix() else ""

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
                  return routeService.resolve routes[0], options
              else if routes.length is 0
                  throw new Error 'Route ' + routeName + ' not found'
              throw new Error 'Multiple routes matching ' + routeName + ' were found'

            match: (routeName) ->
              routes = []
              angular.forEach $route.routes, (config, route) ->
                  if config.name is routeName
                      routes.push route
              return routes

            resolve: (route, options) ->
              pattern = /(\:\w+\*?)/g
              if route is undefined
                throw new Error("Can't resolve undefined into a route")

              count = 0
              prefix + route.replace pattern, (match, ..., offset) ->

                # If the last character of `match` is an asterisk, we're dealing with a largecode
                if match.indexOf('*') == match.length-1
                  match = match.substring(0, match.length-1)

                if type(options) is 'array'
                  output = options[count]
                  count++
                  return output
                else if type(options) is 'object'
                  return options[match.slice(1)]

      ]
      return this
    ]

    .directive 'namedRoute', [
      '$log'
      '$NamedRouteService'
      ($log, $NamedRouteService) ->
        # /* Given that the following route exists :
        #         .when('/products/:cat/:page', {
        #             controller: 'OptionalController',
        #             template: '/static/javascripts/application/templates/optional-template.html',
        #             name: 'item-detail'
        #         })

        #    And that an element is present :
        #      <a data-named-url='item-detail'
        #         data-kwarg-cat='fish'
        #         data-kwarg-page='34'>Salmon Info</a>

        #      return the following
        #      <a href="#/products/fish/34/">Salmon Info</a>

        #    or if an element is present :
        #      <a data-named-url='item-detail'
        #         data-args='["fish",34]'>Salmon Info</a>

        #      return the following
        #      <a href="#/products/fish/34/">Salmon Info</a>

        #  */
        restrict: "AC"
        link: (scope, element, attributes) ->
            options = {}

            for attribute of attributes when attribute.indexOf('kwarg') is 0
              newKey = attribute.slice 5
              newKey = newKey.charAt(0).toLowerCase() + newKey.slice(1)
              options[newKey] = attributes[attribute]

            if attributes.args?
              options = attributes.args.replace(/[\[\]\"\'\s]+/g, '').split(",")

            url = $NamedRouteService.reverse attributes.namedRoute, options
            element.attr 'href', url

      ]

    .filter 'route', [
      '$route'
      '$NamedRouteService'
      ($route, $NamedRouteService) ->
        (name, options) ->
          $NamedRouteService.reverse name, options
    ]
