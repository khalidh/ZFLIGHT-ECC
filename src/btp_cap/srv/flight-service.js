const cds = require('@sap/cds');
const { createFlightHandlers } = require('./handlers/flight-handlers');

module.exports = cds.service.impl(function () {
  createFlightHandlers(this, cds);
});
