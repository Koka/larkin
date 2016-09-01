import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service(),

  actions: {
    login() {
      const credentials = this.getProperties('login', 'password');
      const authenticator = 'authenticator:jwt';
      this.get('session').authenticate(authenticator, credentials)
        .then(() => {
          this.transitionToRoute("index");
        })
        .catch(() => {
          this.set('errorMessage', "Invalid credentials");
        });
    }
  }
});
