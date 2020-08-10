require('./scss/app.scss')

import defaultTranslations from "./i18n/en.yaml"; // embedded in the bundle
import "./i18n/it.yaml"; // just a reference so that webpack can imports the file in the build

import YAML from "yaml";
import { flatten } from "./utils"
import { Elm } from './elm/Pyxis.elm'

function buildI18nDict(text) {
  try {
    const parsedObject = YAML.parse(text)
    return flatten(parsedObject);
  } catch (err) {
    console.error(err);
    return {} // TODO: improve error handling
  }
}

async function fetchLocale(locale) {
  try {
    const response = await fetch(`./i18n/${locale}.yaml`);
    if (!response.ok) {
      throw new Error(response.statusText);
    }
    return await response.text();
  } catch (err) {
    console.error(`Can't load translations of '${locale}' locale. Falling back to locale 'en'`);
    return defaultTranslations;
  }
}

async function initI18n() {
  let lang = 'en';
  const langMatch = location.href.match(/lang=(\w+)/);

  if (!langMatch) {
    return buildI18nDict(defaultTranslations);
  } else {
    lang = langMatch[1];
  }

  const loadedLocale = await fetchLocale(lang);

  return buildI18nDict(loadedLocale);
}


initI18n().then(translations => {
  Elm.Pyxis.init({
    node: document.getElementById('app'),
    flags: {
      currentPath: window.location.pathname,
      translations: Object.entries(translations)
    }
  })
});
