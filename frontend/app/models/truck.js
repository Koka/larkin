import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  maxWeight: DS.attr("number"),
  maxVolume: DS.attr("number"),

  driver: DS.belongsTo('user'),

  availableShifts: Ember.computed('tripsPerDay', function () {
    const allShifts = ['M', 'N', 'E'];
/*
    const availableShifts = [];
    let tripsLeft = this.get('tripsPerDay');
    let needRest = false;
    let startShift = (allShifts.length - 1) - tripsLeft;
    for (let i = startShift; i < allShifts.length; i++) {
      if (needRest) {
        needRest = false;
        continue;
      }
      if (tripsLeft-- > 0) {
        availableShifts.push(allShifts[i]);
        needRest = true;
      }
    }

    return Ember.A(availableShifts);
*/
    //TODO: calculate available shifts
    return Ember.A(allShifts);
  })
});
