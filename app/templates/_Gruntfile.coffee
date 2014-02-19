fs = require 'fs'
util = require 'util'

module.exports = (grunt) ->
  
  # register external tasks
  grunt.loadNpmTasks 'grunt-express'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-sass'
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

    clean:
      development: [DEV_BUILD_PATH]
      production: [PRODUCTION_BUILD_PATH]

    coffee:
      development:
        options:
          sourceMap: true
        files: [
          expand: true
          cwd: "#{APP_PATH}/coffee"
          dest: "#{DEV_BUILD_PATH}/js"
          src: ["*.coffee", "**/*.coffee"]
          ext: ".js"
        ]

    copy:
      development:
        files: [
          { expand: true, cwd: "#{APP_PATH}/public", src:['**'], dest: DEV_BUILD_PATH }
        ]
      # production:
      #   files: [
      #     { expand: true, cwd: DEV_BUILD_PATH, src:['**'], dest: PRODUCTION_BUILD_PATH },
      #   ]
  
    # run tests with mocha test, mocha test:unit, or mocha test:controllers
    mochaTest:
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
    
    sass:
      development:
        files:
          "server/client_build/development/stylesheets/main.css": "client/scss/main.scss"
    
    watch:
      sass:
        files: ["client/scss/**/*.scss"]
        tasks: 'sass:development' 
      coffee:
        files: "client/coffee/**/*.coffee"
        tasks: 'coffee:development'
        
  grunt.registerTask 'test', [
    'development'
    'express:test'
    'mochaTest:controllers'
  ]
    
  grunt.registerTask 'development', [
    'clean:development'
    'copy:development'
    'sass:development'
    'coffee:development'
  ]     
        
  grunt.registerTask 'default', [
    # 'env:development'
    'development'
    'express:development'
    'watch'
  ]
