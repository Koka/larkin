import Ember from 'ember';

export default Ember.Component.extend({
  tagName: '',
  confirming: false,

  actions : {
    ask() {
      this.set('confirming', true);
    },

    confirm() {
      this.set('confirming', false);
      if (this.get('onConfirm')) {
        this.get('onConfirm')();
      }
    },

    cancel() {
      this.set('confirming', false);
      if (this.get('onCancel')) {
        this.get('onCancel')();
      }
    }
  }
});
