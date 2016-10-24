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
          MESSAGES =
            manyFound: (name) ->
              return 'Multiple routes matching ' + name + ' were found'
            notFound: (name) ->
              return 'Route ' + routeName + ' not found'
            unresolvable: ->
              return 'Can not resolve undefined into a route'

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

          routeService = {
            html5Mode: -> $locationProvider.html5Mode()
            isHtml5Mode: ->
              mode = @html5Mode()
              return typeof mode is 'boolean' and mode or mode.enabled

            getPrefix: ->
              return @isHtml5Mode() and
                "##{$locationProvider.hashPrefix()}" or ""

            reverse: (routeName, options) ->
              routes = routeService.match(routeName)
              if routes.length == 1
                return routeService.resolve routes[0], options
              else if routes.length is 0
                throw new Error MESSAGES.notFound(routeName)
              throw new Error MESSAGES.manyFound(routeName)

            match: (routeName) ->
              routes = []
              angular.forEach $route.routes, (config, route) ->
                if config.name is routeName
                  routes.push route
              return routes

            resolve: (route, options) ->
              pattern = /(\:\w+\*?)/g
              if route is undefined
                throw new Error(MESSAGES.unresolvable(routeName))

              count = 0
              @getPrefix() + route.replace pattern, (match, ..., offset) ->

                # If the last character of `match` is an asterisk,
                # we're dealing with a largecode and need to remove it
                # in order to support named-route directives
                if match.charAt(match.length - 1) == '*'
                  match = match.substring(0, match.length - 1)

                if type(options) is 'array'
                  output = options[count]
                  count++
                  return output
                else if type(options) is 'object'
                  return options[match.slice(1)]
          }
      ]

      return this

    ]

    .directive 'namedRoute', [
      '$log'
      '$NamedRouteService'
      ($log, $NamedRouteService) ->
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
