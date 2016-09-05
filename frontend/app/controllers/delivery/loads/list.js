import Ember from 'ember';

export default Ember.Controller.extend({
  currentDate : null,

  actions : {
    scheduleOrder(date, truck, shift) {
      //TODO: implement me
      console.log(`shcdule order ${date} ${truck} ${shift}`);
    },

    unscheduleOrder(date, truck, shift, order) {
      order.set('loadTruck', null);
      order.set('loadDate', null);
      order.set('loadShift', null);
      order.save().then(() => {
        let pending = this.get('pendingOrders');
        pending.removeObject(order);
      });
    }
  }
});
