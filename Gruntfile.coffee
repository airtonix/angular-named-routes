module.exports = (grunt) ->

  require('matchdep').filter('grunt-*').forEach(grunt.loadNpmTasks)
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  path = require("path")

  @paths =
    build: "./build"
    dist: "./dist"
    src: "./src"

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'
    bower: grunt.file.readJSON 'bower.json'

    paths: @paths

    clean:
      build:
        src: [ "<%= paths.build %>" ]

    coffee:
      build:
        options:
          sourceMap: true
          sourceMapDir: '<%= paths.build %>/lib/'
        files: [
          expand: true
          cwd: '<%= paths.src %>/lib/'
          src: '**/*.coffee'
          dest: '<%= paths.build %>/lib/'
          ext: '.js'
        ]

    karma:
      options:
        frameworks: ['jasmine']
        browsers: ['PhantomJS']
        reporters: ['progress', ]
        files: [
          'bower_components/angular/angular.js'
          'bower_components/angular-route/angular-route.js'
          'bower_components/angular-mocks/angular-mocks.js'
          'src/lib/*.coffee'
          'src/tests/unit/common.coffee'
          'src/tests/unit/**/*.spec.{js,coffee}'
        ]

        preprocessors:
          'src/**/*.coffee': ['coffee']

        coffeePreprocessor:
          options:
            bare: true
            sourceMap: false
            transformPath: (path) ->
              path.replace /\.coffee$/, '.js'

      continuous:
        options:
          autoWatch: true

      single:
        options:
          singleRun: true
          autoWatch: false

      travis:
        singleRun: true

    bump:
      options:
        files: ['./package.json', './bower.json']
        updateConfigs: ['pkg', 'bower']
        syncVersions: true
        tag: true
        createTag: true
        commit: true
        push: false

      dist:
        push: true
        pushTo: 'origin master'


  grunt.registerTask 'build', [
    'clean'
    'karma:single'
    'coffee'
  ]

  grunt.registerTask 'dist', [
    'build'
  ]

  grunt.registerTask 'test', [
    'karma:continuous'
  ]

  grunt.registerTask 'travis', [
    'karma:travis'
  ]

  grunt.registerTask 'default', [ 'test']