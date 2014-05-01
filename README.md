# Angular Named Routes

Let not repeat ourselves ok?

## Install

<iframe src="//benschwarz.github.io/bower-badges/embed.html?pkgname=angular-named-routes" width="160" height="32" allowtransparency="true" frameborder="0" scrolling="0"></iframe>

`$ bower install angular-named-routes`

## Usage

In your routes

```
angular.module('yourModule', ['zj.namedRoutes'])

    .config([
        '$routeProvider',
        '$locationProvider',
        function($routeProvider, $locationProvider){

            // use hashbang fallback mode
            $locationProvider.hashPrefix("#!")
            $locationProvider.html5Mode(false)

            $routeProvider
                .when('/products/:cat/:id', {
                        controller: 'OptionalController',
                        template: '/static/javascripts/application/templates/optional-template.html',
                        name: 'item-detail'
                    })
                .otherwise({ redirectTo: "/" });
        }]);
```

In your templtes

```
 <a data-named-url='item-detail' data-kwarg-id='1' data-kwarg-cat='fish'>Salmon Info</a>
```

or

```
 <a href={{ {id:1, cat:'fish'} | url:'item-detail' }}>Salmon Info</a>
```

Should turn into :
```
  <a href="#!/products/fish/1/">Salmon Info</a>
```

## Tests

1. setup nodejs and npm
2. git clone this repo
3. `$ npm install`

Tests are in `./src/tests`, still needs tests for filter and directive.


## Contributors

Inspired by a code snippet by g00fy @stackoverflow: 
  - http://stackoverflow.com/a/16368629/454615
