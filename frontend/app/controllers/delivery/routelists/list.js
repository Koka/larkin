import Ember from 'ember';

export default Ember.Controller.extend({
    session: Ember.inject.service(),

    actions : {
      downloadPDF(routelist) {
        this.get('session').authorize('authorizer:custom', (header, value) => {
          const filename = `${encodeURIComponent(routelist.get("id"))}.pdf`;
          Ember.$.ajax(`/routelists/${filename}`, {
            headers : {
              [header] : value
            },
            xhrFields : {
              responseType: 'blob'
            }
          }).then( pdf => {
            const url = window.URL.createObjectURL(pdf);
            try {
              const a = document.createElement('a');
              a.href = url;
              a.download = filename;
              a.click();
            } finally {
              window.URL.revokeObjectURL(url);
            }
          });
        });
      },

      editRoutelist(routelist) {
        this.transitionToRoute('delivery.routelists.edit', routelist.get('id'));
      }
    }
});
