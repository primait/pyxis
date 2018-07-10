const helpers       = require('./helpers.js')
const template      = require('./index.html')
const pyxisStyle    = require('./scss/app.scss')
const primaStyle    = require('./scss/prima.scss')
const introImg      = require('./assets/intro.jpg')
const Elm           = require('./App.elm')
const route         = window.location.pathname
const isIE          = helpers.detectIE() <= 11
const isEdge        = helpers.detectIE() >= 12

const random        = Math.floor(Math.random() * 10)
console.log("Seed", random)
if(random % 2 == 0) {
  document.body.className += ' radioBorder'
}

isIE ? document.body.className += ' is-IE' : null
isEdge ? document.body.className += ' is-Edge' : null;

(!!('ontouchstart' in window) || !!('msmaxtouchpoints' in window.navigator)) ? document.body.className += ' isTouchDevice' : null;

const app = Elm.App.embed(document.getElementById('app'), {
  route: route
})

app.ports.inspectHtml.subscribe(selector => {
  const htmlSource = [].slice.call(document.querySelectorAll(selector)).map(item => helpers.beautifyHtml(item.innerHTML))
  app.ports.htmlSnippet.send(htmlSource.join(''))
})

app.ports.copyToClipboard.subscribe(selector => {
  const colorHex = window.getComputedStyle(document.querySelector(selector), null).getPropertyValue('background-color')
  const hexBits = colorHex.split(',').map((item) => parseInt(item.trim().replace('rgb(','').replace(')','')) )
  const r = hexBits[0]
  const g = hexBits[1]
  const b = hexBits[2]
  helpers.copyToClipboard(helpers.rgbToHex(r, g, b))
  app.ports.copied.send(true)
})

document.addEventListener('click', event => {
  if(event.target.className) {
    const isInput = ~event.target.className.indexOf('a-form__field__')
    const isLabel = ~event.target.className.indexOf('a-form__field__label')
    (isInput && !isLabel) ? null : app.ports.clickedOutside.send(true)
  }
  else {
    app.ports.clickedOutside.send(true)
  }
}, false)
