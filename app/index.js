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

  var prompts = [{
    type: 'confirm',
    name: 'someOption',
    message: 'Would you like to enable this option?',
    default: true
  }];

  this.prompt(prompts, function (props) {
    this.someOption = props.someOption;

    cb();
  }.bind(this));
};

BooterGenerator.prototype.app = function app() {
  this.mkdir('server');

  // index files
  this.copy('_package.json', 'package.json');
  this.copy('_app.coffee', 'app.coffee');
  this.copy('_Gruntfile.coffee', 'Gruntfile.coffee');
  
  // controllers
  this.mkdir('server/controllers');
  this.copy('_controllers/public_controller.coffee', 'server/controllers/public_controller.coffee');
  
  // templates
  this.mkdir('server/templates');
  this.mkdir('server/templates/public');
  this.copy('_templates/public/index.jade', 'server/templates/public/index.jade');
};
