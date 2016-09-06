import Ember from 'ember';

export default Ember.Component.extend({
  tagName : '',
  moment: Ember.inject.service(),

  shiftAvailable: Ember.computed('shift', 'truck.availableShifts', function () {
    return this.get('truck.availableShifts') ? this.get('truck.availableShifts').contains(this.get('shift')) : false;
  }),

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
    return Ember.A(this.get('scheduledOrders')).filterBy('type', 'Delivery').reduce((acc, it) => acc + parseFloat(it.get('volume')), 0);
  }),

  sumReturnedVolume:  Ember.computed('scheduledOrders.@each.volume', function () {
    if (!this.get('scheduledOrders')) {
      return 0;
    }
    return Ember.A(this.get('scheduledOrders')).filterBy('type', 'Return').reduce((acc, it) => acc + parseFloat(it.get('volume')), 0);
  }),

  actions : {
    add() {
      let remainingVolume = this.get('truck.maxVolume') - this.get('sumVolume');
      let remainingReturnVolume = this.get('truck.maxVolume') - this.get('sumReturnedVolume');
      this.get('onAdd')(this.get('date'), this.get('truck'), this.get('shift'), remainingVolume, remainingReturnVolume);
    },

    remove(order) {
      this.get('onRemove')(this.get('date'), this.get('truck'), this.get('shift'), order);
    }
  }
});
