/* eslint-env browser */ // This allows us to reference 'window' below

import getConstant from '../../utils/constants';

$(() => {
  // Rotate through the news items every 8 seconds
  const articles = $('#j-blog__content').val();
  if (articles) {
    const news = JSON.parse(`${articles.replace(/\\"/g, '"').replace(/\\'/g, '\'')}`);
    const updateNews = (item) => {
      const text = $('.c-blog__content');
      const span = `<span class="new-window-popup-info">${getConstant('OPENS_IN_A_NEW_WINDOW_TEXT')}</span>`;
      text.hide();
      text.html(`<a href="${news[item].link}" target="_blank" class="has-new-window-popup-info">${news[item].title} ${span}</a>`);
      text.fadeIn(100);
    };
    const startNewsTimer = (item) => {
      setTimeout(() => {
        updateNews(item);
        startNewsTimer((item >= news.length - 1) ? 0 : item + 1);
      }, 8000);
    };
    updateNews(0);
    startNewsTimer(1);
  }
});
