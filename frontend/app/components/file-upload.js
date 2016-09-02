import EmberUploader from 'ember-uploader';

export default EmberUploader.FileField.extend({
  files : null,

  filesDidChange(files) {
    this.set('files', files);
  }
});
