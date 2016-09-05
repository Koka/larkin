import Ember from 'ember';

export default Ember.Controller.extend({
  currentDate : null,

  actions : {
    showNormalOrders() {
      this.transitionToRoute('delivery.orders.list');
    },

    rescheduleOrder(order) {
      order.set('deliveryDate', this.get('currentDate').format('MM/DD/YYYY'));
      order.save().then(() => {
        this.get('model').removeObject(order);
      });
    },

    editOrder(order) {
      this.transitionToRoute('delivery.orders.edit', order.get('id'), 'outdated');
    }
  }
});
