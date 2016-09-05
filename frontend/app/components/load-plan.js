import Ember from 'ember';

export default Ember.Component.extend({
  tagName : '',
  moment: Ember.inject.service(),

  scheduledOrders: Ember.computed('orders.@each.loadTruck', 'orders.@each.loadShift', 'orders.@each.loadDate', function () {
    if (!this.get('orders')) {
      return [];
    }
    return this.get('orders').filter(ord => ord.get('loadTruck.id') === this.get('truck.id') &&
     ord.get('loadShift') === this.get('shift') &&
     this.get('moment').moment(this.get('date')).startOf('day').isSame(this.get('moment').moment(ord.get('loadDate')).startOf('day'))
    );
  }),

  sumVolume:  Ember.computed('scheduledOrders.@each.volume', function () {
    if (!this.get('scheduledOrders')) {
      return 0;
    }
    return this.get('scheduledOrders').reduce((acc, it) => acc + parseFloat(it.get('volume')), 0);
  })
});
