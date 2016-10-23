describe "namedRoutes.service", ->
  $route = null
  $location = null
  $service = null

  beforeEach(inject (_$route_, _$location_, _$NamedRouteService_) ->
      $route = _$route_
      $location_ = _$location_
      $service = _$NamedRouteService_
    )

  it "service should be available", ->
    expect $service
      .toBeDefined()

  it "should resolve a routename", ->
    expect $service.reverse "product-list"
      .toEqual "/products"

  it "should resolve a routename with args", ->
    expect $service.reverse "product-detail", [16]
      .toEqual "/product/16"

  it "should resolve a routename with kwargs", ->
    expect $service.reverse "product-detail", id: 16
      .toEqual "/product/16"

  it "should resolve a routename with many args", ->
    expect $service.reverse "product-category", ["fish", 34]
      .toEqual "/products/fish/34"

  it "should resolve a routename with many kwargs", ->
    expect $service.reverse "product-category",
        tag: "fish"
        page: 34
      .toEqual "/products/fish/34"

  it "should resolve a routename with a largecode", ->
    expect $service.reverse "product-category-detail",
      categoryPath: "fish/halibut"
    .toEqual "/categories/fish/halibut"

  it "should resolve a routename with a largecode and kwarg", ->
    expect $service.reverse "product-category-search",
      categoryPath: "fish/halibut",
      query: "steak"
    .toEqual "/categories/fish/halibut/search/steak"
