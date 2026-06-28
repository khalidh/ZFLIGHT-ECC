const test = require('node:test');
const assert = require('node:assert/strict');
const { calculatePrice, nextBusinessID } = require('../srv/handlers/flight-handlers');

test('calculatePrice applies seat multiplier, fuel surcharge and tax', () => {
  assert.deepEqual(calculatePrice(100, 'EUR', 'BUS'), {
    baseAmount: 180,
    taxAmount: 37.8,
    totalAmount: 226.8,
    currencyCode: 'EUR'
  });
});

test('nextBusinessID keeps a 10 character business identifier', () => {
  assert.equal(nextBusinessID('B', 0), 'B000000001');
  assert.equal(nextBusinessID('I', 41), 'I000000042');
});
