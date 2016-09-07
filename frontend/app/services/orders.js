import Ember from 'ember';

export default Ember.Service.extend({
  cancelOrder(order) {
    order.set('cancelled', true);
    return order.save();
  }
});
