# The following actions were run manually on the server:
#
# Install Chromium to `/apps/dmp/install/dmptool/.cache/puppeteer/chrome/linux-126.0.6478.61/chrome-linux64/chrome`
#   >  sudo su - dmp
#   > cd ~/apps/dmptool/shared
#   > npm install puppeteer (maybe?)
#   > npx puppeteer browsers install chrome
#   > export CHROMIUM_PATH=/apps/dmp/install/dmptool/.cache/puppeteer/chrome/linux-126.0.6478.61/chrome-linux64/chrome
#   > export GROVER_NO_SANDBOX=true

# Install fonts manually to /user/share/fonts
# To view fonts > fc-list
# Copy fonts to the dmp user's `~/.local/share/fonts` directory
# Rebuild the font cache > fc-cache -f -v

Grover.configure do |config|
  config.options = {
    format: 'letter',
    prefer_css_page_size: true, # Tells Puppeteer to prefer the `@page` CSS directive for margins
    vision_deficiency: 'deuteranopia',
    cache: true,
    timeout: 0, # Timeout in ms. A value of `0` means 'no timeout'
    request_timeout: 10000, # Timeout when fetching the content (overloads the `timeout` option)
    convert_timeout: 10000, # Timeout when converting the content (overloads the `timeout` option, only applies to PDF conversion)

    headless: true, # Tell Puppeteer to use headless Chrome
    executable_path: Rails.root.join('.cache', 'puppeteer', 'chrome', 'linux-126.0.6478.61', 'chrome-linux64', 'chrome'),

    launch_args: ['--font-render-hinting=medium', '--no-sandbox', '--disable-setuid-sandbox'],
    wait_until: 'networkidle0',
    full_page: true,
    # devtools: true
  }
end