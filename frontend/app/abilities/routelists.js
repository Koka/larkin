import Ember from 'ember';
import { Ability } from 'ember-can';

export default Ability.extend({
  currentUser: Ember.inject.service(),

  canSeeList: Ember.computed('currentUser.user.isDispatcher', 'currentUser.user.isDriver', function() {
    return this.get('currentUser.user.isDispatcher') || this.get('currentUser.user.isDriver');
  }),

  canEditStops: Ember.computed('currentUser.user.isDispatcher', function() {
    return this.get('currentUser.user.isDispatcher');
  })
});
