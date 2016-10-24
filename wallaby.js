module.exports = function (wallaby) {
  return {

    files: [
      'node_modules/angular/angular.js',
      'node_modules/angular-route/angular-route.js',
      'node_modules/angular-mocks/angular-mocks.js',
      'src/angular-named-routes.coffee',
    ],

    tests: [
      'tests/unit/common.coffee',
      'tests/unit/*.spec.coffee'
    ],

    compilers: {
     '**/*.coffee': wallaby.compilers.coffeeScript({})
    },

    env: {
      runner: require('phantomjs-prebuilt').path
    }

  };
};