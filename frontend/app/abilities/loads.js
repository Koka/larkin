import Ember from 'ember';
import { Ability } from 'ember-can';

export default Ability.extend({
  currentUser: Ember.inject.service(),

  canSeeList: Ember.computed('currentUser.user.isDispatcher', function() {
    return this.get('currentUser.user.isDispatcher');
  })
});
