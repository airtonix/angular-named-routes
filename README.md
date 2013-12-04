# Angular Named Routes

Let not repeat ourselves ok?


## Demo

http://embed.plnkr.co/bsQ9zn/preview

## Usage

In your routes

```
    config( ['$routeProvider', function($routeProvider){
      $routeProvider
        .when('/products/:cat/:id', {
            controller: 'OptionalController',
            template: '/static/javascripts/application/templates/optional-template.html',
            name: 'item-detail'
        })
        .otherwise({ redirectTo: "/" });
```

In your templtes

```
 <a data-named-route='item-detail' data-kwarg-id='1' data-kwarg-cat='fish'>Salmon Info</a>
```

Should turn into : 
```
  <a href="#/products/fish/1/">Salmon Info</a>
```

## Contributors

Inspired by a code snippet by g00fy @stackoverflow: 
  - http://stackoverflow.com/a/16368629/454615
  
