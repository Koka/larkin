import Ember from 'ember';

export default Ember.Controller.extend({
  currentDate : null,
  availableOrders : Ember.A([]),
  pendingOrders : Ember.A([]),

  _clearScheduleDialog() {
    this.set('scheduleDate', null);
    this.set('scheduleTruck', null);
    this.set('scheduleShift', null);
    this.get('availableOrders').clear();
  },

  scheduleOrders: Ember.computed('availableOrders.@each.selected', function () {
    return this.get('availableOrders') ? this.get('availableOrders').filterBy('selected', true).map(wrapper => wrapper.get('order')) :  Ember.A([]);
  }),

  scheduleSumVolume: Ember.computed('scheduleOrders.@each.volume', 'scheduleOrders.@each.type', function () {
    return this.get('scheduleOrders') ? Ember.A(this.get('scheduleOrders')).filterBy('type', 'Delivery').reduce((acc, i) => acc + i.get('volume'), 0) : 0;
  }),

  scheduleSumReturnVolume: Ember.computed('scheduleOrders.@each.volume', 'scheduleOrders.@each.type', function () {
    return this.get('scheduleOrders') ? Ember.A(this.get('scheduleOrders')).filterBy('type', 'Return').reduce((acc, i) => acc + i.get('volume'), 0) : 0;
  }),

  actions : {
    openScheduleDialog(date, truck, shift) {
      this._clearScheduleDialog();

      this.set('scheduleDate', date);
      this.set('scheduleTruck', truck);
      this.set('scheduleShift', shift);
      this.get('availableOrders').clear();

      this.store.query('Order', { outdated: false }).then(orders => {
        this.get('availableOrders').clear();
        this.get('availableOrders').addObjects(
          orders
            .filter( order => (order.get('deliveryShift') == null || order.get('deliveryShift') === shift))
            .map(order => Ember.Object.create({
              selected : false,
              order: order
            }))
        );
      });

      Ember.$('.ui.schedule.modal').modal('show');
    },

    unscheduleOrder(date, truck, shift, order) {
      order.set('loadTruck', null);
      order.set('loadDate', null);
      order.set('loadShift', null);
      order.save().then(() => {
        let pending = this.get('pendingOrders');
        pending.removeObject(order);
      });
    },

    doSchedule() {
      let pending = this.get('pendingOrders');
      let promises = this.get('scheduleOrders').map(order => {
        order.set('loadTruck', this.get('scheduleTruck'));
        order.set('loadDate', this.get('scheduleDate').toDate());
        order.set('loadShift', this.get('scheduleShift'));
        return order.save().then(() => {
          pending.addObject(order);
        });
      });
      Ember.RSVP.all(promises).then(() => {
        this._clearScheduleDialog();
      });
    },

    cancelSchedule() {
      this._clearScheduleDialog();
    }
  }
});
