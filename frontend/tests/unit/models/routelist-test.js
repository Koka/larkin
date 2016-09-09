import { moduleForModel, test } from 'ember-qunit';

moduleForModel('routelist', 'Unit | Model | routelist', {
  // Specify the other units that are required for this test.
  needs: ['model:truck', 'model:order']
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});
