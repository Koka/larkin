import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import Ember from 'ember';

const ordersServiceStub = Ember.Service.extend({
  isShiftAvailable() {
    return true;
  }
});

moduleForComponent('load-plan', 'Integration | Component | load plan', {
  integration: true,

  beforeEach() {
    this.register('service:orders', ordersServiceStub);
    this.inject.service('orders', { as: 'ordersServiceStub'});
  }
});

test('it renders', function(assert) {
  const store = this.container.lookup('service:store');
  Ember.run(() => {
    this.set('truck', store.createRecord('truck'));
  });

  this.render(hbs`{{load-plan truck=truck}}`);

  Ember.run(() => {
    this.get('truck').destroy();
  });

  assert.equal(this.$().text().trim(), 'Shift is not available');
});
