'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var _ = require('underscore');


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
      type: 'confirm',
      name: 'useAuth',
      message: 'Would you like to add authorized user login?  Answering yes enable passport login to an authorized /account page',
      default: true
    }
  ];

  this.prompt(prompts, function (props) {
    this.useAuth = props.useAuth;

    cb();
  }.bind(this));
};

BooterGenerator.prototype.app = function app() {

  // *** BASIC FILES ***
  this.template('_package.json', 'package.json', {
    name: this.appname
  });
  this.template('_app.coffee', 'app.coffee', {
    defaultDbConnectionPath: this.appname,
    useAuth: this.useAuth
  });
  this.copy('_Gruntfile.coffee', 'Gruntfile.coffee');
  this.copy('_gitignore', '.gitignore');
  
  // *** SERVER ***
  this.mkdir('server');
  
  // models
  this.mkdir('server/models');
  
  // templates AKA views
  this.mkdir('server/templates');
  this.mkdir('server/templates/public');
  this.copy('_templates/public/layout.jade', 'server/templates/public/layout.jade');
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
    
    // account
    this.copy('_controllers/account_controller.coffee', 'server/controllers/account_controller.coffee');
    this.mkdir('server/templates/account');
    this.copy('_templates/account/layout.jade', 'server/templates/account/layout.jade');
    this.copy('_templates/account/index.jade', 'server/templates/account/index.jade');

    // admin
    this.copy('_controllers/admin_controller.coffee', 'server/controllers/admin_controller.coffee');
    this.mkdir('server/templates/admin');
    this.copy('_templates/admin/layout.jade', 'server/templates/admin/layout.jade');
    this.copy('_templates/admin/index.jade', 'server/templates/admin/index.jade');
    this.copy('_templates/admin/show_account.jade', 'server/templates/admin/show_account.jade');
  }
  
  // *** CLIENT ***
  this.directory('_client', 'client');
  
  // *** TESTS ***
  this.directory('_test', 'test');
};
