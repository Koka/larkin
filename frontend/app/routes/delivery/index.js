import Ember from 'ember';
import { CanMixin } from 'ember-can';

export default Ember.Route.extend(CanMixin, {
  currentUser: Ember.inject.service(),

  beforeModel() {
    return this.get('currentUser').load();
  },

  redirect() {
    if (this.can('see list of orders')) {
      this.transitionTo("delivery.orders");
    } else if (this.can('see list of loads')) {
      this.transitionTo("delivery.loads");
    } else if (this.can('see list of routelists')) {
      this.transitionTo("delivery.routelists");
    } else {
      this.transitionTo("unauthorized");
    }
  }
});
