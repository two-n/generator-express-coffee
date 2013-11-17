fs = require 'fs'
util = require 'util'

module.exports = (grunt) ->
  
  # register external tasks
  grunt.loadNpmTasks 'grunt-express'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-env'
  
  BUILD_PATH = 'server/client_build'
  APP_PATH = 'client'
  DEV_BUILD_PATH = "#{BUILD_PATH}/development"
  JS_DEV_BUILD_PATH = "#{DEV_BUILD_PATH}/js"
  PRODUCTION_BUILD_PATH = "#{BUILD_PATH}/production"
  SERVER_PATH = "server"
  
  grunt.initConfig
  
    # run tests with mocha test, mocha test:unit, or mocha test:controllers
    mochaTest:
      unit:
        options:
          reporter: 'spec'
        src: ['test/unit/*']
      controllers:
        options:
          reporter: 'spec'
        src: ['test/controllers/*']
        
    # express server
    express:
      test:
        options:
          server: './app'
          port: 5000
      development:
        options:
          server: './app'
          port: 3000
     
    # build CSS with stylus
    # build CSS with stylus
    less:
      development:
        files:
          "server/client_build/development/stylesheets/main.css": "client/stylus/main.less"
        options:
          paths: ["#{APP_PATH}/stylus"]
    
    watch:
      stylus:
        files: ["#{APP_PATH}/stylus/*.styl", "#{APP_PATH}/stylus/*/*.styl"]
        tasks: 'stylus:development' 
    
  grunt.registerTask 'development', [
    'less:development'
  ]     
        
  grunt.registerTask 'default', [
    # 'env:development'
    'development'
    'express:development'
    'watch'
  ]      