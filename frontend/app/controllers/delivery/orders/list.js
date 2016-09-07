import Ember from 'ember';
import EmberUploader from 'ember-uploader';

export default Ember.Controller.extend({
  actions : {

    editOrder(order) {
      this.transitionToRoute('delivery.orders.edit', order.get('id'), 'list');
    },

    cancelOrder(order) {
      //TODO: implement me
      console.log("Order cancelled " + order);
    }
  }
});
