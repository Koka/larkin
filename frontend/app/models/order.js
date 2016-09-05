import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  deliveryDate: DS.attr(),
  deliveryShift: DS.attr(),
  originName: DS.attr(),
  originRawLine1: DS.attr(),
  originCity: DS.attr(),
  originState: DS.attr(),
  originZip: DS.attr(),
  originCountry: DS.attr(),
  clientName: DS.attr(),
  destinationRawLine1: DS.attr(),
  destinationCity: DS.attr(),
  destinationState: DS.attr(),
  destinationZip: DS.attr(),
  destinationCountry: DS.attr(),
  phoneNumber: DS.attr(),
  mode: DS.attr(),
  purchaseOrderNumber: DS.attr(),
  volume: DS.attr(),
  handlingUnitQuantity: DS.attr(),
  handlingUnitType: DS.attr(),

  loadDate: DS.attr(),
  loadShift: DS.attr(),
  loadTruck: DS.belongsTo('truck'),

  type: Ember.computed('clientName', 'originName', function () {
    if (this.get('originName') === 'Larkin LLC' && this.get('clientName') !== 'Larkin LLC') {
      return 'Delivery';
    } else if (this.get('originName') !== 'Larkin LLC' && this.get('clientName') === 'Larkin LLC') {
      return 'Return';
    } else {
      return 'Unknown!';
    }
  })
});
