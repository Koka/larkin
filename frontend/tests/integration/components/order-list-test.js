import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('order-list', 'Integration | Component | order list', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.set('orders', []);

  this.render(hbs`{{order-list orders=orders}}`);

  assert.ok(this.$().text().trim().indexOf('No orders found!') > 0);

});
