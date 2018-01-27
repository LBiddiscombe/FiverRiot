/*global RiotControl */
import { FiverStore } from '/js/modules/FiverStore.js'

Raven.config(
  'https://31cfcb0d43a5430bad1d892efc85b80d@sentry.io/278692'
).install()

Raven.context(function() {
  var fiverStore = new FiverStore()
  RiotControl.addStore(fiverStore)
})
