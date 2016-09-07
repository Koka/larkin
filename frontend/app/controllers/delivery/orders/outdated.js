import Ember from 'ember';

export default Ember.Controller.extend({
  actions : {

    editOrder(order) {
      this.transitionToRoute('delivery.orders.edit', order.get('id'), 'outdated');
    },

    cancelOrder(order) {
      //TODO: implement me
      console.log("Order cancelled " + order);
    }
  }
});
