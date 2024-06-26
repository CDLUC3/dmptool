# The following actions were run manually on the server:
#
# In order for Grover to work properly you must install Chromium on the server!
# This is managed via our Capistrano deploy.
#
# If you need to install Chromium outside the Capistrano build you should do the following:
#   - From the project root run: `npx puppeteer browsers install chrome`
#     This will install Chrome into a `.cache/puppeteer/chrome/` directory in the project root.
#
# Install the fonts:
#   - From the project root run:
#     - `cp app/assets/fonts/Roboto-*.ttf /dmp/.local/share/fonts/`
#     - `cp app/assets/fonts/Tinos-*.ttf /dmp/.local/share/fonts/`
#     - Then rebuild the font index/cache `fc-cache -f -v`
#     - Verify that both the Roboto and Tinos fonts are installed: `fc-list`
#

dflt_executable_path = Rails.root.join('.cache', 'puppeteer', 'chrome', 'linux-126.0.6478.61',
                                       'chrome-linux64', 'chrome')

Grover.configure do |config|
  config.options = {
    format: 'letter',
    # Tells Puppeteer to prefer the `@page` CSS directive for margins
    prefer_css_page_size: true,
    vision_deficiency: 'deuteranopia',
    cache: true,
    # Default for all timeouts in ms. A value of `0` means 'no timeout'
    timeout: 0,
    # Timeout when fetching the content (overrides the `timeout` option for this scenario)
    request_timeout: 10000,
    # Timeout when converting the content (overrides the `timeout` option for this scenario)
    convert_timeout: 10000,

    # Tell Puppeteer to use headless Chrome
    headless: true,
    # Tells Puppeteer where the Chromium executable lives. Update this when Chrome is updated!
    executable_path: ENV.fetch('CHROMIUM_PATH', dflt_executable_path),

    launch_args: ['--font-render-hinting=medium', '--no-sandbox', '--disable-setuid-sandbox'],
    wait_until: 'networkidle0',
    full_page: true,
    # devtools: true
  }
end