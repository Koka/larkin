import Ember from 'ember';
import EmberUploader from 'ember-uploader';

export default Ember.Controller.extend({
  orderFiles: [],

  session: Ember.inject.service(),

  notifications: Ember.inject.service('notification-messages'),

  actions : {
    openUploadDialog() {
      Ember.$('.ui.upload.modal').modal('show');
    },

    doUpload() {
      const files = this.get('orderFiles');
      if (!Ember.isEmpty(files)) {
        this.get('session').authorize('authorizer:custom', (header, value) => {
          const uploader = EmberUploader.Uploader.create({
            url: '/orders/upload',
            ajaxSettings: {
              headers: {
                [header]: value
              }
            }
          });
          uploader.upload(files[0]).then(() => {
            this.get('notifications').success('Orders uploaded!');
          }, () => {
            this.get('notifications').error('Failed to upload orders.');
          });
        });
      }
    },

    cancelUpload() {
      this.set('orderFiles', []);
    }
  }
});
