import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  session: Ember.inject.service(),

  name: DS.attr(),
  maxWeight: DS.attr("number"),
  maxVolume: DS.attr("number"),

  driver: DS.belongsTo('user'),

  isShiftAvailable(date, shift) {
    const promise = new Ember.RSVP.Promise((resolve, reject) => {
      this.get('session').authorize('authorizer:custom', (header, value) => {
        Ember.$.ajax(`/trucks/${this.get('id')}/shift_available/${shift}/${date.format('YYYY-MM-DD')}`, {
          headers : {
            [header] : value
          }
        }).then(arr => resolve(arr), e => reject(e));
      });
    });
    return DS.PromiseObject.create({
      promise
    });
  }
});
