import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  tripsPerDay: DS.attr("number"),
  maxWeight: DS.attr("number"),
  maxVolume: DS.attr("number"),

  driver: DS.belongsTo('user')
});
