fs = require 'fs'
util = require 'util'

module.exports = (grunt) ->
  
  # register external tasks
  grunt.loadNpmTasks 'grunt-express'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-env'
  
  BUILD_PATH = 'build'
  APP_PATH = 'app'
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
          
    # watch:
    #  # coffee:
    #  #   files: ["#{APP_PATH}/coffee/*.coffee", "#{APP_PATH}/coffee/*/*.coffee","#{APP_PATH}/coffee/*/*/*.coffee"]
    #  #   tasks: 'coffee:development'
    #  # stylus:
    #  #   files: ["#{APP_PATH}/stylus/*.styl", "#{APP_PATH}/stylus/*/*.styl"]
    #  #   tasks: 'stylus:development'
    #  # jade:
    #  #   files: ["#{APP_PATH}/index.jade", "#{APP_PATH}/partials/*.jade", "#{APP_PATH}/partials/**/*.jade"]
    #  #   tasks: ['jade:development', 'clientTemplates']          
        
  grunt.registerTask 'default', [
    # 'env:development'
    # 'development'
    'express:development'
    # 'watch'
  ]      