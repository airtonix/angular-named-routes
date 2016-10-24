angular.module "zj.namedRoutes", []

  ###
   * Configuration provider
   * @example
   * angular.module('yourModule', ['zj.namedRoutes'])
   *
   *    .config([
   *      '$routeProvider',
   *      '$locationProvider',
   *       function($routeProvider, $locationProvider){
   *
   *           // use hashbang fallback mode
   *           $locationProvider
   *               .hashPrefix("!")
   *               .html5Mode(false);
   *
   *           $routeProvider
   *               .when('/products/:cat/:id', {
   *                       controller: 'OptionalController',
   *                       template: '/static/javascripts/application/templates/optional-template.html',
   *                       name: 'item-detail'
   *                   })
   *               .otherwise({ redirectTo: "/" });
   *       }]);
  ###
  .provider "$NamedRouteService", [
    "$locationProvider"
    ($locationProvider) ->
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
            ###
             * backwards compatiable check for html5mode
             * @return {Boolean} [description]
            ###
            html5Mode: -> $locationProvider.html5Mode()
            isHtml5Mode: ->
              mode = @html5Mode()
              return typeof mode is 'boolean' and mode or mode.enabled

            ###
             * return the prefix based on html5mode
             * @return {[type]} [description]
            ###
            getPrefix: ->
              return @isHtml5Mode() and "#" + $locationProvider.hashPrefix() or ""

            ###
             * turns a routeName (and options) into a useable url
             * @param  {[type]} routeName [description]
             * @param  {[type]} options   [description]
             * @return {[type]}           [description]
            ###
            reverse: (routeName, options) ->
              routes = routeService.match(routeName);
              if routes.length == 1
                return routeService.resolve routes[0], options
              else if routes.length is 0
                throw new Error 'Route ' + routeName + ' not found'
              throw new Error 'Multiple routes matching ' + routeName + ' were found'

            ###
             * given a routeName, return a route object;
             * @param  {[type]} routeName [description]
             * @return {[type]}           [description]
            ###
            match: (routeName) ->
              routes = []
              angular.forEach $route.routes, (config, route) ->
                if config.name is routeName
                  routes.push route
              return routes

            ###
             * Given a route object and options, return a rendered url
             * @param  {[type]} route   [description]
             * @param  {[type]} options [description]
             * @return {[type]}         [description]
            ###
            resolve: (route, options) ->
              pattern = /(\:\w+\*?)/g
              if route is undefined
                throw new Error("Can't resolve undefined into a route")

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

      ]

      return this

    ]

    ###
     * named-route
     * @param {Any} data-kwarg-* Named keyword arguments to replace url placeholders
     * @param {Array} data-args  List of arguments to drop into url param placeholders
     * @example
     *
     *      <a data-named-route='item-detail'
     *         data-args='["fish",1]'>Salmon Info</a>
     *
     *      <a href='#!/products/fish/1/'
     *         data-named-route='item-detail'
     *         data-kwarg-id='1'
     *         data-kwarg-cat='fish'>Salmon Info</a>
     *
     *      <a data-named-route='item-detail'
     *         data-kwarg-id='1'
     *         data-kwarg-cat='fish'>Salmon Info</a>
     *
    ###
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

    ###
     * Route filter
     * @example
     *
     *     {{ 'item-detail' | route:{id:1, cat:'fish'} }}
     *
     *     {{ 'item-detail' | route:['fish', 1] }}
     *
    ###
    .filter 'route', [
      '$route'
      '$NamedRouteService'
      ($route, $NamedRouteService) ->
        (name, options) ->
          $NamedRouteService.reverse name, options
    ]
