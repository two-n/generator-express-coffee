'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');


var BooterGenerator = module.exports = function BooterGenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    this.installDependencies({
      skipInstall: options['skip-install'],
      bower: false
    });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(BooterGenerator, yeoman.generators.Base);

BooterGenerator.prototype.askFor = function askFor() {
  var cb = this.async();

  // have Yeoman greet the user.
  console.log(this.yeoman);

  var prompts = [
    {
      name: 'applicationName',
      message: 'What do you want to call your app?',
      default: 'my_cool_app'
    },
    {
      type: 'confirm',
      name: 'useMongoose',
      message: "Would you like your app to have a MongoDB database? Answering 'yes' will connect your app to a database with Mongoose.  Answering 'no' will do nothing, and make no database.",
      default: true
    },
    {
      type: 'confirm',
      name: 'useAuth',
      message: 'Would you like to add admin & user login?  Warning:  I will need to create a user object in your db.  I can only do this if you have a db enabled.',
      default: true
    }
  ];

  this.prompt(prompts, function (props) {
    this.useMongoose = props.useMongoose;
    this.useAuth = props.useAuth;

    cb();
  }.bind(this));
};

BooterGenerator.prototype.app = function app() {

  // *** BASIC FILES ***
  this.copy('_package.json', 'package.json');
  this.copy('_app.coffee', 'app.coffee'); // app file AKA The Queen Bee
  this.copy('_Gruntfile.coffee', 'Gruntfile.coffee');
  
  // *** SERVER ***
  this.mkdir('server');
  
  // models
  this.mkdir('server/models');
  
  // templates AKA views
  this.mkdir('server/templates');
  this.mkdir('server/templates/public');
  this.copy('_templates/public/index.jade', 'server/templates/public/index.jade');
  
  // controllers
  this.mkdir('server/controllers');
  this.copy('_controllers/public_controller.coffee', 'server/controllers/public_controller.coffee');
  
  //  *** AUTH *** could maybe be separate generator
  if (this.useAuth) {
    // basic auth and login
    this.copy('_controllers/auth_controller.coffee', 'server/controllers/auth_controller.coffee');
    this.copy('_models/user.coffee', 'server/models/user.coffee');
    this.copy('_templates/public/login.jade', 'server/templates/public/login.jade');
    this.copy('_templates/public/signup.jade', 'server/templates/public/signup.jade');
    
    // admin stuff
    this.copy('_controllers/admin_controller.coffee', 'server/controllers/admin_controller.coffee');
    this.mkdir('server/templates/admin');
    this.template('_templates/admin/index.jade', 'server/templates/admin/index.jade');
  }
  
  // *** CLIENT ***
  this.mkdir('client');
  
  // stylus
  this.mkdir('client/less');
  this.copy('_client/less/main.less', 'client/stylus/main.less');
  this.mkdir('client/less/vendor');
  this.copy('_client/less/vendor/bootstrap.less', 'client/stylus/vendor/bootstrap.less');
  this.copy('_client/less/gatekeeper.less', 'client/stylus/gatekeeper.less');
  
};
