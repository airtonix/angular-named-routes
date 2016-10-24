beforeEach module "ngRoute"
beforeEach module "zj.namedRoutes"
beforeEach( module ($routeProvider, $locationProvider) ->

  $locationProvider.html5Mode(true)

  $routeProvider

    .when "/products",
      name: "product-list"
      controller: angular.noop

    .when "/product/:id",
      name: "product-detail"
      controller: angular.noop

    .when "/products/:tag/:page",
      name: "product-category"
      controller: angular.noop

    .when "/categories/:categoryPath*",
      name: "product-category-detail"
      controller: angular.noop

    .when "/categories/:categoryPath*\/search/:query",
      name: "product-category-search"
      controller: angular.noop

  return
)
