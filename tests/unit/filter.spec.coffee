describe 'namedRoutes.filters', ->
  $filterProvider = null
  filter = null

  beforeEach(inject (_$filter_) ->
    $filterProvider = _$filter_
    filter = $filterProvider 'route'
    )

  it "angular $filter should be testable", ->
    expect($filterProvider).to.be.defined

  it "our filter should exist", ->
    expect(filter).to.be.defined

  it "should resolve a basic url without args or kwargs", ->
      path = filter 'product-list'
      expect path
        .to.be.defined
      expect path
        .to.equal "/products"

  it "should resolve a basic url with a single arg", ->
    path = filter "product-detail", [16]
    expect path
      .to.be.defined
    expect path
      .to.equal "/product/16"

  it "should resolve a basic url with multiple args", ->
    path = filter "product-category", ["fish",34]
    expect path
      .to.be.defined
    expect path
      .to.equal "/products/fish/34"

  it "should resolve a basic url with a single kwarg", ->
    path = filter "product-detail", id: 16
    expect path
      .to.be.defined
    expect path
      .to.equal "/product/16"

  it "should resolve a basic url with a multiple kwargs", ->
    path = filter "product-category",
      page: 34
      tag: 'fish'

    expect path
      .to.be.defined
    expect path
      .to.equal "/products/fish/34"



