import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    return this.store.query('Order', { outdated: false, completed: false, cancelled: false });
  },

  actions : {
    refreshMe() {
      this.refresh();
    }
  }
});
