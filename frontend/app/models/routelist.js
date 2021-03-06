import DS from 'ember-data';

export default DS.Model.extend({
  deliveryDate: DS.attr(),
  deliveryShift: DS.attr(),
  stopCount: DS.attr("number"),

  loadTruck: DS.belongsTo('truck'),

  stops: DS.hasMany('order')
});
