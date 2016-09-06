import Ember from 'ember';

export default Ember.Controller.extend({
  _goBack() {
    this.transitionToRoute('delivery.routelists.list');
  },

  actions : {
   save(rec) {
     //TODO: reorder stops
     this._goBack();
   },

   cancel() {
     this._goBack();
   }
 }
});
