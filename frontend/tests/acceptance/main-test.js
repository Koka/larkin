import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';

moduleForAcceptance('Acceptance | navigation flow');

test('navigation flow test', function(assert) {
  visit('/');

  andThen(function() {
    assert.equal(currentURL(), '/login');
    fillIn("input[name=login]", "dispatcher");
    fillIn("input[name=password]", "dispatcher");
    click("button[type=submit]");
  });

  andThen(function() {
    assert.equal(currentURL(), '/delivery/orders/list');
    click("a.button-orders-upload");
  });

  andThen(function() {
    assert.equal(currentURL(), '/delivery/orders/list');
    assert.equal(find('div.modal.upload > div.header').text().trim(), 'Upload new orders');
    click("div.ui.deny.button");
  });

  andThen(function() {
    assert.equal(currentURL(), '/delivery/orders/list');
    click("a.nav-orders-outdated");
  });

  andThen(function() {
    assert.equal(currentURL(), '/delivery/orders/outdated');
    click("a.nav-orders-actual");
  });

  andThen(function() {
    assert.equal(currentURL(), '/delivery/orders/list');
    click("a.nav-orders-scheduled");
  });

  andThen(function() {
    assert.equal(currentURL(), '/delivery/orders/completed');
    click("a.nav-orders-cancelled");
  });

  andThen(function() {
    assert.equal(currentURL(), '/delivery/orders/cancelled');
    click("a.nav-loads");
  });

  andThen(function() {
    assert.equal(currentURL(), '/delivery/loads/list');
    click("i[title='Next day']");
  });

  andThen(function() {
    assert.equal(currentURL(), '/delivery/loads/list');
    click("i[title='Next day']");
  });

  andThen(function() {
    assert.equal(currentURL(), '/delivery/loads/list');
    click("i[title='Previous day']");
  });

  andThen(function() {
    assert.equal(currentURL(), '/delivery/loads/list');
    click("i[title='Go to today']");
  });

  andThen(function() {
    assert.equal(currentURL(), '/delivery/loads/list');
    click("a.nav-routelists");
  });

  andThen(function() {
    assert.equal(currentURL(), '/delivery/routelists/list');
    click("a.nav-logout");
  });

});
