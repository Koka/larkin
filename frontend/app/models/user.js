import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  name : DS.attr(),
  login : DS.attr(),
  role : DS.attr(),

  isDispatcher: Ember.computed.equal('role', 'dispatcher'),
  isDriver: Ember.computed.equal('role', 'driver')
});
