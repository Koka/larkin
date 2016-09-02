import Ember from 'ember';
import EmberUploader from 'ember-uploader';

export default Ember.Controller.extend({
  currentDate : null,
  session: Ember.inject.service(),

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
      const files = this.get('orderFiles');
      if (!Ember.isEmpty(files)) {
        this.get('session').authorize('authorizer:custom', (header, value) => {
          const uploader = EmberUploader.Uploader.create({
            url: '/orders',
            ajaxSettings: {
              headers: {
                [header]: value
              }
            }
          });
          uploader.upload(files[0]).then(data => {
            //TODO: Handle success
          }, error => {
            //TODO: Handle failure
          });
        });
      }
    },

    cancelUpload() {
      this.set('orderFiles', null);
    }
  }
});
