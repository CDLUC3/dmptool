# The following actions were run manually on the server:
#
# Install Chromium to `/apps/dmp/install/dmptool/.cache/puppeteer/chrome/linux-126.0.6478.61/chrome-linux64/chrome`
#   >  sudo su - dmp
#   > cd ~/apps/dmptool/shared
#   > npm install puppeteer (maybe?)
#   > npx puppeteer browsers install chrome
#   > export CHROMIUM_PATH=/apps/dmp/install/dmptool/.cache/puppeteer/chrome/linux-126.0.6478.61/chrome-linux64/chrome
#   > export GROVER_NO_SANDBOX=true



Grover.configure do |config|
  config.options = {
    format: 'letter',
    # margin: {
    #   top: '25px',
    #   right: '25px',
    #   bottom: '25px',
    #   left: '25px'
    # },
    # prefer_css_page_size: true,
    # emulate_media: 'screen',
    # bypass_csp: true,
    # media_features: [{ name: 'prefers-color-scheme', value: 'dark' }],
    # timezone: 'Australia/Sydney',
    vision_deficiency: 'deuteranopia',
    # extra_http_headers: { 'Accept-Language': 'en-US' },
    # geolocation: { latitude: 59.95, longitude: 30.31667 },
    # focus: '#some-element',
    # hover: '#another-element',
    # cache: true,
    timeout: 0, # Timeout in ms. A value of `0` means 'no timeout'
    request_timeout: 10000, # Timeout when fetching the content (overloads the `timeout` option)
    convert_timeout: 10000, # Timeout when converting the content (overloads the `timeout` option, only applies to PDF conversion)

    headless: true,
    executable_path: Rails.root.join('.cache', 'puppeteer', 'chrome', 'linux-126.0.6478.61', 'chrome-linux64', 'chrome'),

    launch_args: ['--font-render-hinting=medium', '--no-sandbox', '--disable-setuid-sandbox'],
    wait_until: 'networkidle0',
    full_page: true,
    devtools: true
  }
end