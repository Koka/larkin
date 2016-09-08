import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return Ember.RSVP.hash({
      record: this.store.findRecord('order', params.id).then(rec => {
        rec.validate();
        return rec;
      }),
      back: params.back || 'list'
    });
  },

  setupController(controller, model) {
    this._super.apply(this, arguments);
    controller.set('model', model.record);
    controller.set('backRoute', `delivery.orders.${model.back}`);
  }
});
