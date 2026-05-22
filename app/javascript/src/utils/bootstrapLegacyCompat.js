import { Collapse, Dropdown, Modal, Tab, Tooltip, Popover } from 'bootstrap';


$(() => {
  // Bridge Bootstrap 3 collapse data attributes to Bootstrap 5 equivalents.
  $('[data-toggle="collapse"]').each((_i, trigger) => {
    const triggerEl = $(trigger);
    const targetSelector = triggerEl.attr('data-target') || triggerEl.attr('href');
    const parentSelector = triggerEl.attr('data-parent');

    if (!triggerEl.attr('data-bs-toggle')) {
      triggerEl.attr('data-bs-toggle', 'collapse');
    }

    if (targetSelector && !triggerEl.attr('data-bs-target')) {
      triggerEl.attr('data-bs-target', targetSelector);
    }

    if (targetSelector && parentSelector) {
      const normalizedParent =
        parentSelector.startsWith('#') || parentSelector.startsWith('.')
          ? parentSelector
          : `#${parentSelector}`;
      const targetEl = $(targetSelector);
      if (targetEl.length > 0 && !targetEl.attr('data-bs-parent')) {
        targetEl.attr('data-bs-parent', normalizedParent);
      }
    }
  });

  // Bridge Bootstrap 3 dropdown data attributes to Bootstrap 5 equivalents.
  $('[data-toggle="dropdown"]').each((_i, trigger) => {
    const triggerEl = $(trigger);
    if (!triggerEl.attr('data-bs-toggle')) {
      triggerEl.attr('data-bs-toggle', 'dropdown');
    }
  });


  // Keep legacy jQuery API calls working (e.g. panelCollapse.collapse('hide')).
  if ($.fn && !$.fn.collapse) {
    $.fn.collapse = function collapse(action = 'toggle') {
      return this.each((_i, el) => {
        const instance = Collapse.getOrCreateInstance(el, { toggle: false });
        if (action === 'show') {
          instance.show();
        } else if (action === 'hide') {
          instance.hide();
        } else {
          instance.toggle();
        }
      });
    };
  }

  // Keep legacy jQuery tab API calls working (e.g. $(...).tab('show')).
  if ($.fn && !$.fn.tab) {
    $.fn.tab = function tab(action = 'show') {
      return this.each((_i, el) => {
        const instance = Tab.getOrCreateInstance(el);
        if (action === 'show') {
          instance.show();
        }
      });
    };
  }

  if ($.fn && !$.fn.modal) {
    $.fn.modal = function modal(action = 'show', ...args) {
      return this.each((_i, el) => {
        const options = typeof action === 'object' ? action : {};
        const instance = Modal.getOrCreateInstance(el, options);

        if (typeof action === 'string') {
          if (action === 'show') {
            instance.show();
          } else if (action === 'hide') {
            instance.hide();
          } else if (action === 'toggle') {
            instance.toggle();
          } else if (action === 'dispose') {
            instance.dispose();
          } else if (action === 'handleUpdate') {
            instance.handleUpdate();
          }
        }
      });
    };
  }

  if ($.fn && !$.fn.dropdown) {
    $.fn.dropdown = function dropdown(action = 'toggle') {
      return this.each((_i, el) => {
        const instance = Dropdown.getOrCreateInstance(el);
        if (action === 'toggle') instance.toggle();
        else if (action === 'show') instance.show();
        else if (action === 'hide') instance.hide();
        else if (action === 'dispose') instance.dispose();
      });
    };
  }


  // Initialize all tooltips (BS5 requires explicit init, BS3 did it automatically)
  $('[data-toggle="tooltip"], [data-bs-toggle="tooltip"]').each((_i, el) => {
    const triggerEl = $(el);
    if (!triggerEl.attr('data-bs-toggle')) {
      triggerEl.attr('data-bs-toggle', 'tooltip');
    }
    new Tooltip(el);
  });

  // Initialize all popovers
  $('[data-toggle="popover"], [data-bs-toggle="popover"]').each((_i, el) => {
    const triggerEl = $(el);
    if (!triggerEl.attr('data-bs-toggle')) {
      triggerEl.attr('data-bs-toggle', 'popover');
    }
    new Popover(el);
  });

  // Bridge Bootstrap 3 tab/pill attributes to Bootstrap 5 equivalents.
  $('[data-toggle="tab"], [data-toggle="pill"]').each((_i, trigger) => {
    const triggerEl = $(trigger);
    const mode = triggerEl.attr('data-toggle');
    const targetSelector = triggerEl.attr('data-target') || triggerEl.attr('href');

    if (mode && !triggerEl.attr('data-bs-toggle')) {
      triggerEl.attr('data-bs-toggle', mode);
    }

    if (targetSelector && !triggerEl.attr('data-bs-target')) {
      triggerEl.attr('data-bs-target', targetSelector);
    }
  });

  $('[data-toggle="modal"]').each((_i, trigger) => {
    const triggerEl = $(trigger);
    const targetSelector = triggerEl.attr('data-target') || triggerEl.attr('href');

    if (!triggerEl.attr('data-bs-toggle')) {
      triggerEl.attr('data-bs-toggle', 'modal');
    }

    if (targetSelector && !triggerEl.attr('data-bs-target')) {
      triggerEl.attr('data-bs-target', targetSelector);
    }
  });

  $('body').on('click', '[data-toggle="modal"]', (e) => {
    const triggerEl = $(e.currentTarget);

    // Bootstrap 5 already handles this natively via data-bs-toggle — skip to avoid double-firing
    if (triggerEl.attr('data-bs-toggle') === 'modal') return;

    const targetSelector =
      triggerEl.attr('data-target') ||
      triggerEl.attr('href');

    if (!targetSelector) return;
    const target = document.querySelector(targetSelector);
    if (!target) return;

    e.preventDefault();
    Modal.getOrCreateInstance(target).show();
  });


  $('body').on('click', '[data-toggle="collapse"]', (e) => {
    const triggerEl = $(e.currentTarget);
    const targetSelector = triggerEl.attr('data-bs-target')
      || triggerEl.attr('data-target')
      || triggerEl.attr('href');

    if (!targetSelector || !targetSelector.startsWith('#')) {
      return;
    }

    const target = document.querySelector(targetSelector);
    if (!target) {
      return;
    }

    e.preventDefault();
    const parentSelector = triggerEl.attr('data-parent');
    const options = { toggle: false };
    if (parentSelector) {
      options.parent =
        parentSelector.startsWith('#') || parentSelector.startsWith('.')
          ? parentSelector
          : `#${parentSelector}`;
    }

    Collapse.getOrCreateInstance(target, options).toggle();
  });

  $('body').on('click', '[data-toggle="tab"], [data-toggle="pill"]', (e) => {
    const trigger = e.currentTarget;
    e.preventDefault();
    Tab.getOrCreateInstance(trigger).show();
  });

  // Keep legacy BS3 li.active selectors in sync with BS5 nav-link activation.
  $('body').on('shown.bs.tab', '[data-toggle="tab"], [data-toggle="pill"], [data-bs-toggle="tab"], [data-bs-toggle="pill"]', (e) => {
    const currentLink = $(e.target);
    const navList = currentLink.closest('ul.nav, ul.nav-tabs, ul.nav-pills');
    if (navList.length === 0) {
      return;
    }

    navList.find('li').removeClass('active');
    currentLink.closest('li').addClass('active');
  });
});
