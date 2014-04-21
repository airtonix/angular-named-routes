beforeEach module "ngRoute"
beforeEach module "zj.namedRoutes"
beforeEach( module ($routeProvider) ->
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
  return
)