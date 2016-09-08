import Ember from 'ember';
import pagedArray from 'ember-cli-pagination/computed/paged-array';

export default Ember.Component.extend({
  tagName : '',

  page: 1,
  perPage: 10,
  pagedOrders: pagedArray('orders'),

  scheduleOrders: Ember.computed('orders.@each.selected', function () {
    return this.get('orders') ? this.get('orders').filterBy('selected', true).map(wrapper => wrapper.get('order')) :  Ember.A([]);
  }),

  scheduleSumVolume: Ember.computed('scheduleOrders.@each.volume', 'scheduleOrders.@each.type', function () {
    return this.get('scheduleOrders') ? Ember.A(this.get('scheduleOrders')).filterBy('type', 'Delivery').reduce((acc, i) => acc + parseFloat(i.get('volume')), 0) : 0;
  }),

  scheduleSumReturnVolume: Ember.computed('scheduleOrders.@each.volume', 'scheduleOrders.@each.type', function () {
    return this.get('scheduleOrders') ? Ember.A(this.get('scheduleOrders')).filterBy('type', 'Return').reduce((acc, i) => acc + parseFloat(i.get('volume')), 0) : 0;
  }),

  scheduleRemainingVolume: Ember.computed('scheduleSumVolume', 'truckRemainingVolume', function() {
    var remaining = this.get("truckRemainingVolume") - this.get("scheduleSumVolume");
    return remaining >= 0 ? remaining : 0;
  }),

  scheduleRemainingReturnVolume: Ember.computed('scheduleSumReturnVolume', 'truckRemainingVolume', function() {
    var remaining = this.get("truckRemainingReturnVolume") - this.get("scheduleSumReturnVolume");
    return remaining >= 0 ? remaining : 0;
  }),

  actions : {
    doSchedule() {
      this.get('onSchedule')(this.get('scheduleOrders'));
    },

    cancelSchedule() {
      this.get('onCancel')();
    }
  }
});
