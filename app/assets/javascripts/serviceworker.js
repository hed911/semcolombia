self.addEventListener('push', function(event) {
  console.log('Received a push message', event);
  var data = event.data.json();
  var title = data.title;
  var body = data.body;
  var icon = 'https://images-na.ssl-images-amazon.com/images/G/01/payments-portal/r1/issuer-images/sprite-map._CB332026835_.png';
  var tag = 'crue-valle' + Math.round(+new Date()/1000);
  var data = {
    url:data.url
  };

  event.waitUntil(
    self.registration.showNotification(title, {
      body: body,
      icon: icon,
      tag: tag,
      data: data
    })
  );
});

self.addEventListener('notificationclick', function(event) {
  let url = event.notification.data.url;
  event.notification.close();
  event.waitUntil(
      clients.matchAll({type: 'window'}).then( windowClients => {
          for (var i = 0; i < windowClients.length; i++) {
              var client = windowClients[i];
              if (client.url === url && 'focus' in client) {
                  return client.focus();
              }
          }
          if (clients.openWindow) {
              return clients.openWindow(url);
          }
      })
  );
});
