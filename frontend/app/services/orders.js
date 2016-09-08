import Ember from 'ember';

export default Ember.Service.extend({
  session: Ember.inject.service(),

  cancelOrder(order) {
    order.set('cancelled', true);
    return order.save();
  },

  splitOrder(order) {
    return new Ember.RSVP.Promise((resolve, reject) => {
      this.get('session').authorize('authorizer:custom', (header, value) => {
        Ember.$.ajax(`/orders/${order.get('id')}/split`, {
          method: 'POST',
          headers : {
            [header] : value
          }
        }).then(part => resolve(part), e => reject(e));
      });
    });
  }
});
