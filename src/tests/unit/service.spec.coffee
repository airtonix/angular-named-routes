describe "$NamedRouteService", ->

  it "service should be available", ->
    inject [
      '$route'
      '$location'
      '$NamedRouteService'
      ($route, $location, $NamedRouteService) ->
        expect $NamedRouteService
          .toBeDefined()
        return
    ]

  it "should resolve a routename", ->
    inject [
      '$route'
      '$location'
      '$NamedRouteService'
      ($route, $location, $NamedRouteService) ->
        expect $NamedRouteService.reverse "product-list"
          .toEqual "/products"
        return
    ]

  it "should resolve a routename with args", ->
    inject [
      '$route'
      '$location'
      '$NamedRouteService'
      ($route, $location, $NamedRouteService) ->
        expect $NamedRouteService.reverse "product-detail", [16]
          .toEqual "/product/16"
        return
    ]

  it "should resolve a routename with kwargs", ->
    inject [
      '$route'
      '$location'
      '$NamedRouteService'
      ($route, $location, $NamedRouteService) ->

        expect $NamedRouteService.reverse("product-detail", { id: 16 })
          .toEqual "/product/16"
        return
    ]

  it "should resolve a routename with many args", ->
    inject [
      '$route'
      '$location'
      '$NamedRouteService'
      ($route, $location, $NamedRouteService) ->
        expect $NamedRouteService.reverse("product-category", ["fish",34])
          .toEqual "/products/fish/34"
        return
    ]

  it "should resolve a routename with many kwargs", ->
    inject [
      '$route'
      '$location'
      '$NamedRouteService'
      ($route, $location, $NamedRouteService) ->
        expect $NamedRouteService.reverse("product-category", {tag: "fish", page: 34})
          .toEqual "/products/fish/34"
        return
    ]

  return