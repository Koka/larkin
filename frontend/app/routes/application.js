import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin, {
  session: Ember.inject.service(),
  currentUser: Ember.inject.service(),

  beforeModel() {
    return this._loadCurrentUser();
  },

  sessionAuthenticated() {
    this._super(...arguments);
    this._loadCurrentUser();
  },

  _loadCurrentUser() {
    let session = this.get('session');
    if (session.get('isAuthenticated')) {
      return this.get('currentUser').load().catch(() => { session.invalidate(); });
    } else {
      return Ember.RSVP.Promise.resolve();
    }
  },

  actions: {
    logout: function() {
      let session = this.get('session');
      if (session.get('isAuthenticated')) {
        session.invalidate();
      }
    }
  }
});
