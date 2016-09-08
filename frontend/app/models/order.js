import Ember from 'ember';
import DS from 'ember-data';
import Validator from 'ember-model-validator/mixins/model-validator';

export default DS.Model.extend(Validator, {
  deliveryDate: DS.attr(),
  parsedDeliveryDate: DS.attr('date'),
  deliveryShift: DS.attr(),
  originName: DS.attr(),
  originAddress: DS.attr(),
  originCity: DS.attr(),
  originState: DS.attr(),
  originZip: DS.attr(),
  originCountry: DS.attr(),
  clientName: DS.attr(),
  destinationAddress: DS.attr(),
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
  loadOrdinal: DS.attr('number'),

  cancelled: DS.attr('boolean'),

  type: Ember.computed('clientName', 'originName', function () {
    if (this.get('originName') === 'Larkin LLC' && this.get('clientName') !== 'Larkin LLC') {
      return 'Delivery';
    } else if (this.get('originName') !== 'Larkin LLC' && this.get('clientName') === 'Larkin LLC') {
      return 'Return';
    } else {
      return 'Unknown!';
    }
  }),

  isValid: Ember.computed('deliveryDate', 'deliveryShift', 'phoneNumber', 'purchaseOrderNumber', 'volume', 'handlingUnitQuantity', 'handlingUnitType', function () {
    return this.validate();
  }),

  validations: {
    deliveryDate: {
      format: { with: /^(0?[1-9]|1[0-2])\/(0?[1-9]|1[0-9]|2[0-9]|3[01])\/(19|20)[0-9]{2}$/}
    },
    deliveryShift: {
      format: { with: /^[MNE]$/, allowBlank: true}
    },
    phoneNumber: {
      presence: true
    },
    purchaseOrderNumber: {
      presence: true
    },
    handlingUnitQuantity: {
      numericality: {
        greaterThan: 0
      }
    },
    handlingUnitType: {
      presence: true
    },
    volume: {
      numericality: {
        greaterThanOrEqualTo: 0
      }
    }
  }
});
