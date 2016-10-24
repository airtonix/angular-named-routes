# Angular Named Routes

Let not repeat ourselves ok?


## Install

[![Build Status](https://secure.travis-ci.org/airtonix/angular-named-routes.png?branch=master)](https://travis-ci.org/airtonix/angular-named-routes)

`$ npm install angular-named-routes`


## Usage

In your routes

```
angular.module('yourModule', ['zj.namedRoutes'])

    .config([
        '$routeProvider',
        '$locationProvider',
        function($routeProvider, $locationProvider){

            // use hashbang fallback mode
            $locationProvider
                .hashPrefix("!")
                .html5Mode(false);

            $routeProvider
                .when('/products/:cat/:id', {
                        controller: 'OptionalController',
                        template: '/static/javascripts/application/templates/optional-template.html',
                        name: 'item-detail'
                    })
                .otherwise({ redirectTo: "/" });
        }]);
```

In your templates, you can use either of directive or filter.

- Directive assumes the creation of an attribute `href` (todo: allow control of this)
- Filter is usables anywhere.


### Directive

with keyword arguments :
```
 <a data-named-route='item-detail'
    data-kwarg-id='1'
    data-kwarg-cat='fish'>Salmon Info</a>
```

results in :
```
  <a href='#!/products/fish/1/'
     data-named-route='item-detail'
     data-kwarg-id='1'
     data-kwarg-cat='fish'>Salmon Info</a>
```

with positional arguments :
```
 <a data-named-route='item-detail'
    data-args='["fish",1]'>Salmon Info</a>
```

results in :
```
  <a href='#!/products/fish/1/'
     data-named-route='item-detail'
     data-args='["fish",1]'>Salmon Info</a>
```


### Filter

with keyword arguments : 
```
{{ 'item-detail' | route:{id:1, cat:'fish'} }}
```

or, with positional arguments :
```
{{ 'item-detail' | route:['fish', 1] }}
```

results in :
```
"#!/products/fish/1/"
```

(remember we set `$locationProvider.hashPrefix("#!")` in our `$routeProvider` above.)


## Contributing

1. Be polite.
2. Create ticket explaining bug or feature request.
3. Fork.
4. Write tests.
5. Implement code.
6. Update documentation.


## Tests

1. setup nodejs and npm (nodist on windows, nvm on linux)
2. git clone this repo
3. `$ npm install`
4. `$ npm run test`

Tests are in `./tests`.


## Todo

- generate README from jsdocs using `documentation.js`
- write tests for Angular 1.3-5
- Assess use cases in Angular 2


## Contributors

  - https://github.com/vmaatta
  - https://github.com/Resseguie
  - https://github.com/moretti
  - https://github.com/malero

Inspired by a code snippet by g00fy @stackoverflow: 
  - http://stackoverflow.com/a/16368629/454615
