import Ember from 'ember';

export default Ember.Component.extend({
  tagName: '',
  actions : {
    editOrder(order) {
      this.get('onEdit')(order);
    },

    cancelOrder(order) {
      this.get('onCancel')(order);
    }
  }
});
