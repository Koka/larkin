/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'frontend',
    environment: environment,
    baseURL: '/app',
    locationType: 'auto',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      },
      EXTEND_PROTOTYPES: {
        Date: false,
        Function: true
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    },

    'ember-cli-notifications': {
      includeFontAwesome: true
    }
  };

  ENV['ember-simple-auth'] = {
      authorizer: 'authorizer:custom',
      routeAfterAuthentication: '/'
  };

  ENV['ember-cli-mirage'] = {
      enabled: false
  }

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';

    ENV['ember-cli-mirage'].enabled = true;
  }

  if (environment === 'production') {

  }

  return ENV;
};
