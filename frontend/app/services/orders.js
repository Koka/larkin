import Ember from 'ember';

export default Ember.Service.extend({
  session: Ember.inject.service(),
  moment: Ember.inject.service(),

  scheduleOrders(date, truck, shift, orders) {
    return new Ember.RSVP.Promise((resolve, reject) => {
      this.get('session').authorize('authorizer:custom', (header, value) => {
        Ember.$.ajax(`/orders/schedule`, {
          method: 'POST',
          data : {
            date: this.get('moment').moment(date).format('YYYY-MM-DD'),
            truck: truck.get('id'),
            shift,
            orders: orders.mapBy("id")
          },
          headers : {
            [header] : value
          }
        }).then(() => resolve(), e => reject(e));
      });
    });
  },

  unscheduleOrder(order) {
    order.set('loadTruck', null);
    order.set('loadDate', null);
    order.set('loadShift', null);
    order.set('loadOrdinal', null);
    return order.save();
  },

  cancelOrder(order) {
    order.set('cancelled', true);
    order.set('loadTruck', null);
    order.set('loadDate', null);
    order.set('loadShift', null);
    order.set('loadOrdinal', null);
    return order.save();
  },

  splitOrder(order) {
    return new Ember.RSVP.Promise((resolve, reject) => {
      this.get('session').authorize('authorizer:custom', (header, value) => {
        Ember.$.ajax(`/orders/${order.get('id')}/split`, {
          method: 'POST',
          headers : {
            [header] : value
          }
        }).then(() => resolve(), e => reject(e));
      });
    });
  },

  moveUpInRouteList(order) {
    return new Ember.RSVP.Promise((resolve, reject) => {
      this.get('session').authorize('authorizer:custom', (header, value) => {
        Ember.$.ajax(`/orders/${order.get('id')}/move_up`, {
          method: 'POST',
          headers : {
            [header] : value
          }
        }).then(() => resolve(), e => reject(e));
      });
    });
  },

  moveDownInRouteList(order) {
    return new Ember.RSVP.Promise((resolve, reject) => {
      this.get('session').authorize('authorizer:custom', (header, value) => {
        Ember.$.ajax(`/orders/${order.get('id')}/move_down`, {
          method: 'POST',
          headers : {
            [header] : value
          }
        }).then(() => resolve(), e => reject(e));
      });
    });
  }
});
