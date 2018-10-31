require 'spec_helper'

describe 'iFrames test' do
  it 'passes for existing external iframes' do
    external_iframe_filepath = "#{FIXTURES_DIR}/iframes/existing_iframe_external.html"
    proofer = run_proofer(external_iframe_filepath, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for missing external iframe' do
    external_iframe_filepath = "#{FIXTURES_DIR}/iframes/missing_iframe_external.html"
    proofer = run_proofer(external_iframe_filepath, :file)
    expect(proofer.failed_tests.first).to match(/failed: response code 0/)
  end

  it 'fails for missing internal iframe' do
    internal_iframe_filepath = "#{FIXTURES_DIR}/iframes/missing_iframe_internal.html"
    proofer = run_proofer(internal_iframe_filepath, :file)
    expect(proofer.failed_tests.first).to match(/doesnotexist.html does not exist/)
  end

  it 'fails for iframe with no src' do
    iframe_src_filepath = "#{FIXTURES_DIR}/iframes/missing_iframe_src.html"
    proofer = run_proofer(iframe_src_filepath, :file)
    expect(proofer.failed_tests.first).to match(/iframe has no src attribute/)
  end

  it 'ignores iframes marked as ignore data-proofer-ignore' do
    ignorable_iframes = "#{FIXTURES_DIR}/iframes/ignorable_iframes.html"
    proofer = run_proofer(ignorable_iframes, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'ignores iframes via url_ignore' do
    ignorable_iframe = "#{FIXTURES_DIR}/iframes/ignorable_iframe_via_options.html"
    proofer = run_proofer(ignorable_iframe, :file, url_ignore: [%r{./foobar.+}])
    expect(proofer.failed_tests).to eq []
  end

  it 'works for valid iframes missing the protocol' do
    missing_protocol_link = "#{FIXTURES_DIR}/iframes/iframe_missing_protocol_valid.html"
    proofer = run_proofer(missing_protocol_link, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for invalid iframes missing the protocol' do
    missing_protocol_link = "#{FIXTURES_DIR}/iframes/iframe_missing_protocol_invalid.html"
    proofer = run_proofer(missing_protocol_link, :file)
    expect(proofer.failed_tests.first).to match(/failed: 404/)
  end

  it 'passes for HTTP iframes when not asked' do
    http    = "#{FIXTURES_DIR}/iframes/src_http.html"
    proofer = run_proofer(http, :file)
    expect(proofer.failed_tests).to eq []
  end

  it 'fails for HTTP iframes when asked' do
    http    = "#{FIXTURES_DIR}/iframes/src_http.html"
    proofer = run_proofer(http, :file, check_iframe_http: true)
    expect(proofer.failed_tests.first).to match(/uses the http scheme/)
  end
end