# Angular Named Routes

Let not repeat ourselves ok?

## Install

[![Build Status](https://secure.travis-ci.org/airtonix/angular-named-routes.png?branch=master)](https://travis-ci.org/airtonix/angular-named-routes)


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
 <a data-named-route='item-detail' data-kwarg-id='1' data-kwarg-cat='fish'>Salmon Info</a>
```

Or
```
 <a data-named-route='item-detail' data-args='[1,"fish"]'>Salmon Info</a>
```

Should turn into :
```
  <a href="#!/products/fish/1/">Salmon Info</a>
```

## Tests

1. setup nodejs and npm
2. git clone this repo
3. `$ npm install`
4. `$grunt`

Tests are in `./src/tests`, still needs tests for filter and directive.

The Gruntfile contains : 

```
$ grunt build

  - Run tests
  - Compile coffeescript.

$ grunt dist

  - Run tests
  - Compile coffeescript
  - Bump the version in bower and npm manifests
  - Push to your github repos master branch.
  
$ grunt test

  - Runs tests in watch mode

$ grunt travis

  - Runs a single test with only PhantomJs

```

## Contributors

  - https://github.com/vmaatta
  - https://github.com/Resseguie

Inspired by a code snippet by g00fy @stackoverflow: 
  - http://stackoverflow.com/a/16368629/454615
