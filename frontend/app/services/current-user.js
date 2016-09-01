import Ember from 'ember';

export default Ember.Service.extend({
  store: Ember.inject.service(),

  load() {
    return this.get('store').find('user', 'me').then((user) => {
      this.set('user', user);
    });
  }
});
