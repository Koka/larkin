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
    },

    openUploadDialog() {
      Ember.$('.ui.upload.modal').modal('show');
    },

    doUpload() {
      //TODO: implement it
      console.log("File upload started");
    }
  }
});
