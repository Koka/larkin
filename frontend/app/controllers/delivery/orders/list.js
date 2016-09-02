import Ember from 'ember';

export default Ember.Controller.extend({
  currentDate : null,

  actions : {
    calendarBack() {
      this.get('currentDate').subtract(1, 'days');
      this.notifyPropertyChange('currentDate');
    },

    calendarForward() {
      this.get('currentDate').add(1, 'days');
      this.notifyPropertyChange('currentDate');
    }
  }
});
