/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import 'core-js/stable';
import 'regenerator-runtime/runtime';

// Pull in Bootstrap JS functionality
import 'bootstrap';
import 'bootstrap-3-typeahead';
import 'bootstrap-select';

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// Utilities
import '../src/utils/accordion';
import '../src/utils/externalLink';
import '../src/utils/modalSearch';
import '../src/utils/outOfFocus';
import '../src/utils/paginable';
import '../src/utils/panelHeading';
import '../src/utils/popoverHelper';
import '../src/utils/tabHelper';
import '../src/utils/tooltipHelper';

// Specific functions from the Utilities files that will be made available to
// the js.erb templates in the `window.x` statements below
import getConstant from '../src/utils/constants';
import { renderAlert, renderNotice, hideNotifications } from '../src/utils/notificationHelper';
import toggleSpinner from '../src/utils/spinner';
import { Tinymce } from '../src/utils/tinymce.js.erb';
import { initAutoComplete } from '../src/utils/autoComplete';
import { addAsterisks } from '../src/utils/requiredField';
import { togglisePasswords } from '../src/utils/passwordHelper';

// View specific JS
import '../src/answers/conditions';
import '../src/answers/edit';
import '../src/answers/rdaMetadata';
import '../src/guidances/newEdit';
import '../src/notes/index';
import '../src/orgs/adminEdit';
// ----------------------------------------
// START DMPTool customization
// ----------------------------------------
// import '../src/orgs/shibbolethDs';
// ----------------------------------------
// END DMPTool customization
// ----------------------------------------
import '../src/plans/download';
import '../src/plans/editDetails';
import '../src/plans/index.js.erb';
import '../src/plans/new';
import '../src/plans/publish';
import '../src/plans/share';
import '../src/publicTemplates/show';
import '../src/relatedIdentifiers/edit';
import '../src/researchOutputs/form';
import '../src/roles/edit';

import '../src/usage/index';
import '../src/users/adminGrantPermissions';
import '../src/users/notificationPreferences';
import '../src/users/profile';

// OrgAdmin view specific JS
import '../src/orgAdmin/conditions/updateConditions';
import '../src/orgAdmin/phases/newEdit';
import '../src/orgAdmin/phases/preview';
import '../src/orgAdmin/phases/show';
import '../src/orgAdmin/questionOptions/index';
import '../src/orgAdmin/questions/sharedEventHandlers';
import '../src/orgAdmin/sections/index';
import '../src/orgAdmin/templates/edit';
import '../src/orgAdmin/templates/index';
import '../src/orgAdmin/templates/new';

// SuperAdmin view specific JS
import '../src/superAdmin/apiClients/form';
import '../src/superAdmin/notifications/edit';
import '../src/superAdmin/themes/newEdit';
import '../src/superAdmin/users/edit';

// ==========================
// = DMPTool customizations =
// ==========================
import '../src/dmptool/recaptcha_aria';
import '../src/dmptool/public_pages/plans_index';
import '../src/dmptool/orgAdmin/plans/index';
import '../src/dmptool/users/passwords/edit';

// Since we're using Webpacker to manage JS we need to startup Rails' Unobtrusive JS
// and Turbo. ActiveStorage and ActionCable would also need to be in here
// if we decide to implement either before Rails 6
require('@rails/ujs').start();

// TODO: Disabled turbo for the time being because our custom JS is not
//       properly setup to work with it. We should review the docs:
//       https://github.com/hotwired/turbo-rails
// import "@hotwired/turbo-rails".
// require("@rails/activestorage").start()
// require("@rails/actioncable").start()

// Setup JS functions/libraries so that they're available within the js.erb templates
window.$ = jQuery;
window.jQuery = jQuery;

// Allow js.erb files to access the notificationHelper functions
window.addAsterisks = addAsterisks;
window.getConstant = getConstant;
window.renderAlert = renderAlert;
window.renderNotice = renderNotice;
window.hideNotifications = hideNotifications;
window.toggleSpinner = toggleSpinner;
window.Tinymce = Tinymce;
window.initAutoComplete = initAutoComplete;
window.togglisePasswords = togglisePasswords;

window.addEventListener('load', () => {
  // Initialize any org autocompletes
  $('body').find('.auto-complete').each((_idx, el) => {
    initAutoComplete(`#${$(el).attr('id')}`);
  });

  // Add red asterisk to any input/select fields that have `aria-required="true"`
  addAsterisks('body');
});
