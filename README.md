
A generator for [Yeoman](http://yeoman.io).

#About

This is a Yeoman generator to create a boilerplate express app (written in CoffeeScript) that optionally enables authorized user login with Passport.  The resulting app uses Grunt to control development tasks.

## Install

First, make sure you have Yeoman installed, with

    $ npm install -g yo
    
From then on, you can get information about Yeoman and your installed generators with

    $ yo --help
    
Then, install this generator with

    $ npm install -g generator-express-coffee
    
Time to actually create your app.  Create a directory for the app, and navigate into it.  Then, execute the generator.

    $ mkdir my_new_app
    $ cd my_new_app
    $ yo express-coffee:app
    
Start your app in development environment on port 3000

    $ grunt
    
Happy Coding!

## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License)
