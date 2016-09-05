import Ember from 'ember';

export default Ember.Controller.extend({
  currentDate : null,
  scheduleOrders : [],
  availableOrders : [],

  _clearScheduleDialog() {
    this.set('scheduleDate', null);
    this.set('scheduleTruck', null);
    this.set('scheduleShift', null);
    this.set('scheduleOrders', []);
    this.set('availableOrders', []);
  },

  actions : {
    openScheduleDialog(date, truck, shift) {
      this._clearScheduleDialog();

      this.set('scheduleDate', date);
      this.set('scheduleTruck', truck);
      this.set('scheduleShift', shift);
      this.set('availableOrders', Ember.A([]));

      this.store.query('Order', { outdated: false }).then(orders => {
        this.get('availableOrders').clear();
        this.get('availableOrders').addObjects(orders);
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
      //TODO: implement me
    },

    cancelSchedule() {
      //DO NOTHING
    }
  }
});
