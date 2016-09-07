import Ember from 'ember';

export default Ember.Controller.extend({
  orderFiles: [],

  session: Ember.inject.service(),

  actions : {
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
          uploader.upload(files[0]).then(() => {
            this._reloadCampaigns();
          }, error => {
            //TODO: Handle failure
          });
        });
      }
    },

    cancelUpload() {
      this.set('orderFiles', []);
    }
  }
});
