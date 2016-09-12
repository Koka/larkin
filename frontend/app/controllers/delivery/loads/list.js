import Ember from 'ember';

export default Ember.Controller.extend({
  orders: Ember.inject.service(),
  moment: Ember.inject.service(),
  currentDate : null,
  availableOrders : Ember.A([]),
  pendingOrders : Ember.A([]),

  _clearScheduleDialog() {
    this.set('scheduleDate', null);
    this.set('scheduleTruck', null);
    this.set('scheduleShift', null);
    this.set('scheduleTruckRemainingVolume', 0);
    this.set('scheduleTruckRemainingReturnVolume', 0);
    this.set('scheduleLoading', false);
    this.get('availableOrders').clear();
  },

  calendarCanGoBack: Ember.computed('currentDate', function () {
    return this.get('currentDate').isSameOrAfter(this.get('moment').moment());
  }),

  actions : {

    calendarToday() {
      if (this.get('moment').moment(this.get('currentDate')).startOf('day').isAfter(this.get('moment').moment().startOf('day'))) {
        this.set('currentDate', this.get('moment').moment());
      }
    },

    calendarBack() {
      if (this.get('currentDate').isAfter(this.get('moment').moment())) {
        this.set('currentDate', this.get('moment').moment(this.get('currentDate').subtract(1, 'days')));
      }
    },

    calendarForward() {
      this.set('currentDate', this.get('moment').moment(this.get('currentDate').add(1, 'days')));
    },

    openScheduleDialog(date, truck, shift, remainingVolume, remainingReturnVolume) {
      this._clearScheduleDialog();

      this.set('scheduleDate', date);
      this.set('scheduleTruck', truck);
      this.set('scheduleShift', shift);
      this.set('scheduleTruckRemainingVolume', remainingVolume);
      this.set('scheduleTruckRemainingReturnVolume', remainingReturnVolume);
      this.set('scheduleLoading', true);
      this.get('availableOrders').clear();

      this.store.query('Order', { completed: false, cancelled: false }).then(orders => {
        this.get('availableOrders').clear();
        this.get('availableOrders').addObjects(
          orders
            .filter( order => (order.get('deliveryShift') == null || order.get('deliveryShift') === shift))
            .map(order => Ember.Object.create({
              selected : false,
              order: order
            }))
        );
        this.set('scheduleLoading', false);
      });

      Ember.$('.ui.schedule.modal').modal('show');
    },

    unscheduleOrder(date, truck, shift, order) {
      this.get('orders').unscheduleOrder(order).then(() => {
        let pending = this.get('pendingOrders');
        let available = this.get('availableOrders');
        pending.removeObject(order);
        available.addObject(order);
      });
    },

    doSchedule(scheduleOrders) {
      let pending = this.get('pendingOrders');
      let available = this.get('availableOrders');

      let promise = this.get('orders').scheduleOrders(this.get('scheduleDate').toDate(), this.get('scheduleTruck'), this.get('scheduleShift'), scheduleOrders);

      let promises = scheduleOrders.map(order => {
        return promise.then(() => {
          order.reload();
          pending.addObject(order);
          available.removeObject(order);
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
