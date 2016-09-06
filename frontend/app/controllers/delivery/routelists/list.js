import Ember from 'ember';

export default Ember.Controller.extend({
    actions : {
      downloadPDF(routelist) {
          //TODO: implement me
          console.log("Download pdf for routelist " + routelist.get("id"))
      },

      editRoutelist(routelist) {
        this.transitionToRoute('delivery.routelists.edit', routelist.get('id'));
      }
    }
});
