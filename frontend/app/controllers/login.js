import Ember from 'ember';

export default Ember.Controller.extend({
  session: Ember.inject.service(),

  actions: {
    presetCredentials(login, password) {
      this.set('login', login);
      this.set('password', password);
    },

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
