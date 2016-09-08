import Ember from 'ember';

export default Ember.Controller.extend({
  orders: Ember.inject.service(),

  lastStop: Ember.computed('model.stops.length', function () {
    return this.get('model.stops.length') - 1;
  }),

  actions : {
   back() {
     this.transitionToRoute('delivery.routelists.list');
   },

   moveDown(order, disabled) {
     if (disabled) { return; }
     this.get('orders').moveDownInRouteList(order).then(() => {
       this.get('model').reload();
     });
   },

   moveUp(order, disabled) {
     if (disabled) { return; }
     this.get('orders').moveUpInRouteList(order).then(() => {
       this.get('model').reload();
     });
   }
 }
});
