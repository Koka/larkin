import Ember from 'ember';
import EmberUploader from 'ember-uploader';

export default Ember.Controller.extend({
  currentDate : null,

  actions : {
    showNormalOrders() {
      this.transitionToRoute('delivery.orders.list')
    },

    rescheduleOrder(order) {
      order.set('deliveryDate', this.get('currentDate').format('MM/DD/YYYY'));
      order.save().then(() => {
        this.get('model').removeObject(order);
      });
    }
  }
});
