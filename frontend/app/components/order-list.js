import Ember from 'ember';
import pagedArray from 'ember-cli-pagination/computed/paged-array';

export default Ember.Component.extend({
  tagName: '',

  page: 1,
  perPage: 10,
  pagedOrders: pagedArray('orders'),

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
