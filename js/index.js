/*global Raven riot RiotControl */
import { FiverStore } from '/js/modules/FiverStore.js'
import { authMixin } from '/js/modules/authMixin.js'

Raven.config(
  'https://31cfcb0d43a5430bad1d892efc85b80d@sentry.io/278692'
).install()

Raven.context(function() {
  riot.mixin(authMixin)
  var fiverStore = new FiverStore(authMixin)
  RiotControl.addStore(fiverStore)
})
