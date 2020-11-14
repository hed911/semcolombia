// V1
if ('serviceWorker' in navigator) {
  console.log('Service Worker is supported');
  navigator.serviceWorker.register('/serviceworker.js')
    .then(function(registration) {
      console.log('Successfully registered!', ':^)', registration);
      registration.pushManager.subscribe({ userVisibleOnly: true })
        .then(function(subscription) {
          $.post("/subscribe", { subscription: subscription.toJSON() });
        });
  }).catch(function(error) {
    console.log('Registration failed', ':^(', error);
  });
}

// V2
if ('serviceWorker' in navigator) {
  console.log('Service Worker is supported');
  navigator.serviceWorker.register('/serviceworker.js')
    .then(function(registration_) {

      navigator.serviceWorker.ready.then(function(registration) {

        console.log('Successfully registered!', ':^)', registration);
        registration.pushManager.subscribe({ userVisibleOnly: true })
          .then(function(subscription) {
            $.post("/subscribe", { subscription: subscription.toJSON() });
          });

      });


  }).catch(function(error) {
    console.log('Registration failed', ':^(', error);
  });
}

s = Subscripcion.last
Webpush.payload_send(
  message: "AIOWA",
  endpoint: s.endpoint,
  auth: s.auth,
  p256dh: s.p256dh,
  ttl: 24 * 60 * 60,
  vapid: {
    subject: 'mailto:cruevalledupar@gmail.com',
    public_key: 'BGu2CS13ame7HbmwWnwc7mf5ZW-ZtB5DG9JWDbLxUhhtfUATQ0LVbm6sm1x0ZyMDv7F4LkTzh8mrjf5gqBet-JQ=',
    private_key: 'he1eBBF7kKysmBIWALX4CSFXrI1w14OfuvMTbZpkccU='
  }
)

public_key "BGu2CS13ame7HbmwWnwc7mf5ZW-ZtB5DG9JWDbLxUhhtfUATQ0LVbm6sm1x0ZyMDv7F4LkTzh8mrjf5gqBet-JQ=""
private_key "he1eBBF7kKysmBIWALX4CSFXrI1w14OfuvMTbZpkccU=""
