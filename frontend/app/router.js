import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('login');
  this.route('delivery', function() {
    this.route('orders', function() {
      this.route('list');
      this.route('outdated');
    });
    this.route('loads');
    this.route('routelists');
  });
});

export default Router;
