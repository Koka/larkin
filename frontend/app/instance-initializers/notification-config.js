export function initialize(appInstance) {
  const svc = appInstance.lookup('service:notification-messages');
  svc.setDefaultAutoClear(true);
  svc.setDefaultClearNotification(1200);
}

export default {
  name: 'notification-config',
  initialize
};
