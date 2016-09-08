import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('validation-wrap', 'Integration | Component | validation wrap', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{validation-wrap}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#validation-wrap}}
      template block text
    {{/validation-wrap}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
