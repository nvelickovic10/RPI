const express = require('express')
const app = express()
const gpio = require('onoff').Gpio

const pin = new gpio(2, 'out')

app.get('/', (req, res) => { res.send('Hello World!') })
app.get('/on', (req, res) => { pin.writeSync(0); res.send('ON!') })
app.get('/off', (req, res) => { pin.writeSync(1); res.send('OFF!') })

app.listen(9000, () => console.log('Example app listening on port 9000!'))
