import Ember from 'ember';

export default Ember.Component.extend({
  tagName: '',
  actions : {
    splitOrder(order) {
      this.get('onSplit')(order);
    },

    editOrder(order) {
      this.get('onEdit')(order);
    },

    cancelOrder(order) {
      this.get('onCancel')(order);
    }
  }
});
