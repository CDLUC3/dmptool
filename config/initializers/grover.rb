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
    executable_path: "/usr/bin/chromium",

    launch_args: ['--font-render-hinting=medium', '--no-sandbox', '--disable-setuid-sandbox'],
    wait_until: 'networkidle0',
    full_page: true,
    devtools: true
  }
end