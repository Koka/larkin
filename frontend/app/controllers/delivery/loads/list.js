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
    this.get('availableOrders').clear();
  },

  scheduleOrders: Ember.computed('availableOrders.@each.selected', function () {
    return this.get('availableOrders') ? this.get('availableOrders').filterBy('selected', true).map(wrapper => wrapper.get('order')) :  Ember.A([]);
  }),

  scheduleSumVolume: Ember.computed('scheduleOrders.@each.volume', 'scheduleOrders.@each.type', function () {
    return this.get('scheduleOrders') ? Ember.A(this.get('scheduleOrders')).filterBy('type', 'Delivery').reduce((acc, i) => acc + parseFloat(i.get('volume')), 0) : 0;
  }),

  scheduleSumReturnVolume: Ember.computed('scheduleOrders.@each.volume', 'scheduleOrders.@each.type', function () {
    return this.get('scheduleOrders') ? Ember.A(this.get('scheduleOrders')).filterBy('type', 'Return').reduce((acc, i) => acc + parseFloat(i.get('volume')), 0) : 0;
  }),

  scheduleRemainingVolume: Ember.computed('scheduleSumVolume', 'scheduleTruckRemainingVolume', function() {
    var remaining = this.get("scheduleTruckRemainingVolume") - this.get("scheduleSumVolume");
    return remaining >= 0 ? remaining : 0;
  }),

  scheduleRemainingReturnVolume: Ember.computed('scheduleSumReturnVolume', 'scheduleTruckRemainingVolume', function() {
    var remaining = this.get("scheduleTruckRemainingReturnVolume") - this.get("scheduleSumReturnVolume");
    return remaining >= 0 ? remaining : 0;
  }),

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

    doSchedule() {
      let pending = this.get('pendingOrders');
      let available = this.get('availableOrders');
      let promises = this.get('scheduleOrders').map(order => {
        let promise = this.get('orders').scheduleOrder(this.get('scheduleDate').toDate(), this.get('scheduleTruck'), this.get('scheduleShift'), order);
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
