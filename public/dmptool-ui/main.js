!function(){function e(e){return e&&e.__esModule?e.default:e}var t={};var n=function(e){var n=t[e];if(null==n)throw new Error("Could not resolve bundle with id "+e);return n};(function(e){for(var n=Object.keys(e),i=0;i<n.length;i++)t[n[i]]=e[n[i]]})(JSON.parse('{"3f8kp":"main.js","pAGPy":"1-large.465e59e4.jpg","2ZIk4":"2-large.70514ac7.jpg","6viVv":"3-large.5106248c.jpg","3yYTo":"4-large.a670aff6.jpg","7CzQ8":"5-large.fdf0ed61.jpg","2hOUK":"6-large.a1fbfc50.jpg","4GhTD":"7-large.6da2166b.jpg"}'));const i=document.querySelector("#js-navtoggle"),r=document.querySelector("#js-headernav"),a=null!==r&&null!==i,d=()=>{a&&(r.hidden=!1,i.setAttribute("aria-expanded",!0))},o=()=>{a&&(r.hidden=!0,i.setAttribute("aria-expanded",!1))},s=window.getComputedStyle(document.documentElement).getPropertyValue("--breakpoints").split(","),[c,l]=s,u=e=>{e.matches?d():o()},_=()=>{const e=window.matchMedia(`(min-width: ${c})`);a&&(i.addEventListener("click",(()=>{!0===r.hidden?d():o()})),!0===r.hidden?d():o()),u(e),e.addListener(u)};var f=()=>(()=>{const e=document.querySelector("#js-user-profile"),t=document.querySelector("#js-user-profile__button"),n=document.querySelector("#js-user-profile__menu"),i=()=>{n.hidden=!0,t.setAttribute("aria-expanded",!1)},r=t=>{e.contains(t.target)||i()};e&&(t.addEventListener("click",(()=>{!0===n.hidden?(n.hidden=!1,t.setAttribute("aria-expanded",!0)):i()})),window.addEventListener("click",r),window.addEventListener("focusin",r))})();var b=()=>(()=>{const e=document.querySelector("#js-language"),t=document.querySelector("#js-language__button"),n=document.querySelector("#js-language__menu"),i=()=>{n.hidden=!0,t.setAttribute("aria-expanded",!1)},r=t=>{e.contains(t.target)||i()};document.querySelector("#js-language")&&(t.addEventListener("click",(()=>{!0===n.hidden?(n.hidden=!1,t.setAttribute("aria-expanded",!0)):i()})),window.addEventListener("click",r),window.addEventListener("focusin",r))})();var p=()=>(()=>{const e=document.querySelector("#js-admin"),t=document.querySelector("#js-admin__button"),n=document.querySelector("#js-admin__menu"),i=()=>{n.hidden=!0,t.setAttribute("aria-expanded",!1)},r=t=>{e.contains(t.target)||i()};e&&(t.addEventListener("click",(()=>{!0===n.hidden?(n.hidden=!1,t.setAttribute("aria-expanded",!0)):i()})),window.addEventListener("click",r),window.addEventListener("focusin",r))})(),S=null;var v,g=function(){return S||(S=function(){try{throw new Error}catch(t){var e=(""+t.stack).match(/(https?|file|ftp):\/\/[^)\n]+/g);if(e)return(""+e[0]).replace(/^((?:https?|file|ftp):\/\/.+)\/[^/]+$/,"$1")+"/"}return"/"}()),S},y=n;function m(e){if(""===e)return".";var t="/"===e[e.length-1]?e.slice(0,e.length-1):e,n=t.lastIndexOf("/");return-1===n?".":t.slice(0,n)}function A(e,t){if(e===t)return"";var n=e.split("/");"."===n[0]&&n.shift();var i,r,a=t.split("/");for("."===a[0]&&a.shift(),i=0;(i<a.length||i<n.length)&&null==r;i++)n[i]!==a[i]&&(r=i);var d=[];for(i=0;i<n.length-r;i++)d.push("..");return a.length>r&&d.push.apply(d,a.slice(r)),d.join("/")}(v=function(e,t){return A(m(y(e)),y(t))})._dirname=m,v._relative=A;var h=e(g()+v("3f8kp","pAGPy")),I=e(g()+v("3f8kp","2ZIk4")),L=e(g()+v("3f8kp","6viVv")),N=e(g()+v("3f8kp","3yYTo")),j=e(g()+v("3f8kp","7CzQ8")),q=e(g()+v("3f8kp","2hOUK")),w=e(g()+v("3f8kp","4GhTD"));var E=()=>(()=>{if(document.querySelector(".c-calltoaction")){const e=[h,I,L,N,j,q,w],t=Math.floor(Math.random()*e.length),n=document.querySelector(".js-heroimage"),i=`url('${e[t]}')`;n.style.setProperty("--hero-image",i)}})();var x=()=>(()=>{const e=document.querySelector("#j-blog__array");if(e){const t=e.value,n=JSON.parse(`${t.replace(/\\"/g,'"').replace(/\\'/g,"'")}`),i=e=>{document.querySelector(".c-blog__content").innerHTML=`<a href="${n[e].link}" target="_blank" class="has-new-window-popup-info">${n[e].title}</a>`},r=e=>{setTimeout((()=>{i(e),r(e>=n.length-1?0:e+1)}),8e3)};i(0),r(1)}})();const P=document.querySelector("#js-notification-info"),k=document.querySelector("#js-notification-warning"),C=document.querySelector("#js-notification-danger");var D=()=>(()=>{const e=e=>{e&&e.querySelector("#js-notification-close").addEventListener("click",(()=>{e.hidden=!0}))};e(P),e(k),e(C)})();var G=()=>(()=>{const e=document.querySelector("#js-password-field input"),t=document.querySelector("#js-password-toggle input");e&&t.addEventListener("change",(n=>{t.checked?e.setAttribute("type","text"):e.setAttribute("type","password")}))})();var M=()=>(()=>{const e=document.querySelector(".js-login__required-field"),t=document.querySelectorAll(".js-textfield"),n=document.querySelectorAll(".js-checkbox"),i=t=>{for(const n of t){const t=n.querySelector("input");t.classList.contains("require-me")&&(t.setAttribute("required",""),e.hidden=!1,n.classList.add("is-required"))}};i(t),i(n)})();const U={SIGN_IN_UP_BLANK_CHECKBOX:"Please check this box.",SIGN_IN_UP_BLANK_EMAIL:"Please enter an email address.",SIGN_IN_UP_BLANK_PASSWORD:"Please enter a password.",SIGN_IN_UP_INVALID_EMAIL:"Please enter a valid email address.",SIGN_IN_UP_INVALID_FIELD:"Please complete this %<variable_text>s field.",SIGN_IN_UP_INVALID_FORM:"Please correct the %<variable_text>s fields below:",SIGN_IN_UP_INVALID_PASSWORD:"Please enter a password of at least 8 characters.",SIGN_IN_UP_VALID_FORM:"Ready to submit:"};function O(e,t){let n="Undefined String";return e&&"undefined"!=typeof getConstant?(localizedString=getConstant(e),localizedString&&(n=localizedString)):n=U.hasOwnProperty(e)?U[e]:"Undefined String",n.includes("%<variable_text>s")&&t?n.replace("%<variable_text>s",t):n}var H=()=>(()=>{const e=document.querySelector(".js-login form"),t=document.querySelector(".js-login__invalid-notification"),n=document.querySelector('.js-login button[type="submit"]'),i=document.querySelectorAll(".js-textfield"),r=document.querySelectorAll(".js-checkbox");let a=0;if(e){const d=i=>{e.addEventListener("submit",(e=>{for(const r of i){const i=r.querySelector("input"),d=r.querySelector(".js-invalid-description"),o="error_"+Math.floor(99999*Math.random()),s=()=>{if("email"===i.getAttribute("type")&&(i.validity.typeMismatch&&(d.textContent=O("SIGN_IN_UP_INVALID_EMAIL")),i.validity.valueMissing&&(d.textContent=O("SIGN_IN_UP_BLANK_EMAIL"))),"checkbox"===i.getAttribute("type")&&i.validity.valueMissing&&(d.textContent=O("SIGN_IN_UP_BLANK_CHECKBOX")),"password"===i.getAttribute("autocomplete")&&(i.validity.tooShort&&(d.textContent=O("SIGN_IN_UP_INVALID_PASSWORD")),i.validity.valueMissing&&(d.textContent=O("SIGN_IN_UP_BLANK_PASSWORD"))),"autocomplete"===i.getAttribute("autocomplete")&&(i.parentNode.querySelector(""),i.validity.valueMissing&&(d.textContent=O("SIGN_IN_UP_BLANK_PASSWORD"))),"text"===i.getAttribute("type")&&i.validity.valueMissing){const e=r.querySelector("label").textContent.toLowerCase();d.textContent=O("SIGN_IN_UP_BLANK_FIELD",e)}},c=()=>{let e=O("FIELD");a>1&&(e=`${a} ${O("FIELDS")}`),t.textContent=O("SIGN_IN_UP_INVALID_FORM",a)};i.validity.valid||(!1===r.classList.contains("is-invalid")&&(a=++a),c(),1===a&&i.focus(),t.hidden=!1,t.classList.remove("errors-fixed"),r.classList.add("is-invalid"),i.setAttribute("aria-invalid",!0),d.hidden=!1,d.setAttribute("id",o),n.setAttribute("aria-disabled",!0),i.getAttribute("aria-describedby")?i.getAttribute("aria-describedby").includes(o)||i.setAttribute("aria-describedby",o+" "+i.getAttribute("aria-describedby")):i.setAttribute("aria-describedby",o),s(),e.preventDefault()),i.addEventListener("input",(e=>{i.validity.valid&&(!0===r.classList.contains("is-invalid")&&(a=--a),c(),0===a&&(t.classList.add("errors-fixed"),t.textContent=O("SIGN_IN_UP_VALID_FORM"),n.setAttribute("aria-disabled",!1)),r.classList.remove("is-invalid"),i.removeAttribute("aria-invalid"),d.hidden=!0,i.setAttribute("aria-describedby",i.getAttribute("aria-describedby").replace(o,"")))}))}}))};d(i),d(r),e.classList.contains("novalidate")&&e.setAttribute("novalidate","")}})();if(window.addEventListener("load",(()=>{_(),f(),b(),p(),E(),x(),D(),G(),M(),H()})),document.querySelector("#js-tests2")){document.querySelector("#js-tests2 output").innerText="Yes"}}();