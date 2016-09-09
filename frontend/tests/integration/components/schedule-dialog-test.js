import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('schedule-dialog', 'Integration | Component | schedule dialog', {
  integration: true
});

test('it renders', function(assert) {
  this.set('orders', []);

  this.render(hbs`{{schedule-dialog orders=orders}}`);

  assert.ok(this.$().text().indexOf('No orders available for loading!') > 0);

});
