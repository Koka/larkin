import Ember from 'ember';
import { CanMixin } from 'ember-can';

export default Ember.Route.extend(CanMixin, {
  beforeModel() {
      this._super(...arguments);
      if (!this.can('see list of loads')) {
        return this.transitionTo('unauthorized');
      }
  }
});
