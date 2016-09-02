import Ember from 'ember';
import EmberUploader from 'ember-uploader';

export default Ember.Controller.extend({
  currentDate : null,
  session: Ember.inject.service(),

  _reloadCampaigns() {
      this.store.query('Order', { oudated: false }).then(list => { this.set("model", list); });
  },

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
      this.set('orderFiles', null);
    },

    showOutdatedOrders() {
      this.transitionToRoute('delivery.orders.outdated')
    }
  }
});
