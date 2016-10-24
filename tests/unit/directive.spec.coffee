describe 'namedRoutes.directives', ->
  $scope = null
  $compile = null

  beforeEach(inject (_$rootScope_, _$compile_) ->
    $scope = _$rootScope_
    $compile = _$compile_
  )

  compileLink = (markup, scope) ->
    el = $compile(markup)(scope)
    scope.$digest()
    el

  it "resolves a simple routename", ->
    markup = "<a data-named-route='product-list'>Products</a>"
    element =  compileLink markup, $scope

    expect element
      .to.be.defined
    expect element.attr('href')
      .to.be.defined
    expect element.attr('href')
      .to.equal "/products"

  it "should resolve a routename with args", ->
    markup = "<a data-named-route='product-detail' data-args='[16]'>Products #16</a>"
    element =  compileLink markup, $scope

    expect element
      .to.be.defined
    expect element.attr('href')
      .to.be.defined
    expect element.attr('href')
      .to.equal "/product/16"

  it "should resolve a routename with kwargs", ->
    markup = "<a data-named-route='product-detail' data-kwarg-id='16'>Products #16</a>"
    element =  compileLink markup, $scope

    expect element
      .to.be.defined
    expect element.attr('href')
      .to.be.defined
    expect element.attr('href')
      .to.equal "/product/16"

  it "should resolve a routename with many args", ->
    markup = """<a data-named-route='product-category' data-args='["fish", 34]'>Products #16</a>"""
    element =  compileLink markup, $scope

    expect element
      .to.be.defined
    expect element.attr('href')
      .to.be.defined
    expect element.attr('href')
      .to.equal "/products/fish/34"

  it "should resolve a routename with many kwargs", ->
    markup = """<a data-named-route='product-category' data-kwarg-tag='fish' data-kwarg-page='34'>Products tagged Fish. (page 34)</a>"""
    element =  compileLink markup, $scope

    expect element
      .to.be.defined
    expect element.attr('href')
      .to.be.defined
    expect element.attr('href')
      .to.equal "/products/fish/34"

  it "should resolve a routename with a largecode", ->
    markup = """<a data-named-route='product-category-detail' data-kwarg-category-path='fish/halibut'>Halibut Category</a>"""
    element =  compileLink markup, $scope

    expect element
      .to.be.defined
    expect element.attr('href')
      .to.be.defined
    expect element.attr('href')
      .to.equal "/categories/fish/halibut"

  it "should resolve a routename with a largecode and kwarg", ->
    markup = """<a data-named-route='product-category-search' data-kwarg-category-path='fish/halibut' data-kwarg-query='steak'>Halibut Category Search</a>"""
    element =  compileLink markup, $scope

    expect element
      .to.be.defined
    expect element.attr('href')
      .to.be.defined
    expect element.attr('href')
      .to.equal "/categories/fish/halibut/search/steak"
