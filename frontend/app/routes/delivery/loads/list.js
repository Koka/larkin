import Ember from 'ember';

export default Ember.Route.extend({
  moment: Ember.inject.service(),

  model() {
    return this.store.findAll('Truck');
  },

  setupController(controller) {
    this._super.apply(this, arguments);
    controller.set('currentDate', this.get('moment').moment());

    this.store.query('Order', { completed: true, outdated: false }).then(orders => {
      controller.get('pendingOrders').clear();
      controller.get('pendingOrders').addObjects(orders);
    });
  }
});
