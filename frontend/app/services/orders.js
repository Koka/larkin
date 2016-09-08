import Ember from 'ember';

export default Ember.Service.extend({
  session: Ember.inject.service(),
  moment: Ember.inject.service(),

  scheduleOrder(date, truck, shift, order) {
    return new Ember.RSVP.Promise((resolve, reject) => {
      this.get('session').authorize('authorizer:custom', (header, value) => {
        Ember.$.ajax(`/orders/${order.get('id')}/schedule`, {
          method: 'PUT',
          data : {
            date: this.get('moment').moment(date).format('YYYY-MM-DD'),
            truck: truck.get('id'),
            shift
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
        }).then(part => resolve(part), e => reject(e));
      });
    });
  },

  moveUpInRouteList(order) {
    //TODO: implement me
    console.log("UP " + order);
    return Ember.RSVP.Promise.resolve();
  },

  moveDownInRouteList(order) {
    //TODO: implement me
    console.log("DOWN " + order);
    return Ember.RSVP.Promise.resolve();
  }
});
