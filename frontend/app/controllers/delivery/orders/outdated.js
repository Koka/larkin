import Ember from 'ember';

export default Ember.Controller.extend({
  orders: Ember.inject.service(),

  actions : {

    editOrder(order) {
      this.transitionToRoute('delivery.orders.edit', order.get('id'), 'outdated');
    },

    cancelOrder(order) {
      this.get('orders').cancelOrder(order).then(() => {
        this.get('model').removeObject(order);
      });
    }
  }
});
