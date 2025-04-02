export const config = {
  htmlTexts: true,
  embedded: false,
  cookieExpiresAfterDays: 30,
  default: false,
  mustConsent: false,
  acceptAll: true,
  hideLearnMore: true,
  translations: {
    en: {
      privacyPolicyUrl: 'https://cdlib.org/about/policies-and-guidelines/privacy-statement/',
      consentNotice: {
        description:
          '<h1>Cookie Settings</h1><p>The California Digital Library uses cookies to ensure you have the best experience on our website. ' +
          'You can manage which cookies you want us to use.</p><p>Our <a href=https://cdlib.org/about/policies-and-guidelines/privacy-statement/ target=_blank>Privacy Statement</a> includes ' +
          'more details on the <a href="https://cdlib.org/about/policies-and-guidelines/privacy-policy/#cookie-notice" target="_blank">cookies we use</a> and how we protect your privacy.<p>'
      },
      consentModal: {
        // Klaro's consent modal is not used at CDL.
      },
      decline: 'Allow only necessary cookies',
      ok: 'Allow all cookies',
      purposes: {
        analytics: {
          title: 'Analytics'
        },
        security: {
          title: 'Security'
        },
        livechat: {
          title: 'Livechat'
        },
        advertising: {
          title: 'Advertising'
        },
        styling: {
          title: 'Styling'
        }
      }
    }
  },

  /*
  Here you specify the third-party services that Klaro will manage for you.
  */
  services: [
    {
      /*
      Each service must have a unique name. Klaro will look for HTML elements with a
      matching 'data-name' attribute to identify elements that belong to this service.
      */
      name: 'matomo-tracking',

      /*
      If 'default' is set to 'true', the service will be enabled by default. This
      overrides the global 'default' setting.
      */
      default: true,

      /*
      Translations belonging to this service go here. The key `zz` contains default
      translations that will be used as a fallback if there are no translations
      defined for a given language.
      */
      translations: {
        zz: {
          title: 'Matomo/Piwik'
        },
        en: {
          description: 'Matomo is a simple, self-hosted analytics service.'
        }
      },

      /*
      The purpose(s) of this service that will be listed on the consent notice. Do not
      forget to add translations for all purposes you list here.
      */
      purposes: ['analytics'],

      cookies: [

        /*
        This rule will match cookies that contain the string '_pk_' and that are set on
        the path '/' and the domain 'klaro.kiprotect.com'
        */
        [/^_pk_.*$/, '/', 'klaro.kiprotect.com'],

        /*
        Same as above, only for the 'localhost' domain
        */
        [/^_pk_.*$/, '/', 'localhost'],

        /*
        This rule will match all cookies named 'piwik_ignore' that are set on the path
        '/' on the current domain
        */
        'piwik_ignore'
      ],

      /*
      If 'required' is set to 'true', Klaro will not allow this service to be disabled
      by the user. Use this for services that are always required for your website to
      function (e.g. shopping cart cookies).
      */
      required: false,

      /*
      If 'optOut' is set to 'true', Klaro will load this service even before the user
      has given explicit consent. We strongly advise against this.
      */
      optOut: false,

      /*
      If 'onlyOnce' is set to 'true', the service will only be executed once
      regardless how often the user toggles it on and off. This is relevant e.g. for
      tracking scripts that would generate new page view events every time Klaro
      disables and re-enables them due to a consent change by the user.
      */
      onlyOnce: true
    }
  ],

  /*
  You can define an optional callback function that will be called each time the
  consent state for any given service changes. The consent value will be passed as
  the first parameter to the function (true=consented). The `service` config will
  be passed as the second parameter.
  */
  callback: function (consent, service) {
    console.log(
      'User consent for service ' + service.name + ': ' + consent
    )
  }
}


