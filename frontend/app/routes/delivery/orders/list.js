import Ember from 'ember';

export default Ember.Route.extend({
  moment: Ember.inject.service(),

  model() {
    return this.store.query('Order', { outdated: false });
  },

  setupController(controller) {
    this._super.apply(this, arguments);
    controller.set('currentDate', this.get('moment').moment().add(1, 'days'));
  }
});
