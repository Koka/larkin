import Ember from 'ember';

export default Ember.Controller.extend({
  actions : {
   save(rec) {
     if (rec.validate()) {
       rec.save().then(() => this.transitionToRoute(this.get('backRoute')));
     }
   },

   cancel(rec) {
     rec.rollbackAttributes();
     this.transitionToRoute(this.get('backRoute'));
   }
 }
});
