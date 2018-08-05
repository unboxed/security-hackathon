# frozen_string_literal: true
# By default this will return true, and thus all of the Capybara specs will
# fail until a developer using the site for training has patched up all of
# the vulnerabilities.

$displayed_spec_notice = false

def verifying_fixed?
  if !$displayed_spec_notice
    puts <<-NOTICE

    ******************************************************************************
    You are running the Security Hackathon Capybara Specs. These specs are supposed 
    to fail, indicating vulnerabilities exist. They contain spoilers, so do not 
    read the code in spec/vulnerabilities if your goal is to learn more about 
    patching the vulnerabilities. You should fix the vulnerabilities in the 
    application in order to get these specs to pass**. You can use them to measure 
    your progress.
    ******************************************************************************

    NOTICE
    $displayed_spec_notice = true
  end
  true
end

def login(user)
  visit "/"
  within(".signup") do
    fill_in "email", with: user.email
    fill_in "password", with: user.clear_password
  end
  within(".actions") do
    click_on "Login"
  end
end

##Hack to fix PhantomJS errors on Mavericks - https://gist.github.com/ericboehs/7125105
module Capybara::Poltergeist
  class Client
    private
    def redirect_stdout
      prev = STDOUT.dup
      prev.autoclose = false
      $stdout = @write_io
      STDOUT.reopen(@write_io)

      prev = STDERR.dup
      prev.autoclose = false
      $stderr = @write_io
      STDERR.reopen(@write_io)
      yield
    ensure
      STDOUT.reopen(prev)
      $stdout = STDOUT
      STDERR.reopen(prev)
      $stderr = STDERR
    end
  end
end

class WarningSuppressor
  IGNORE_PATTERNS = [
    /QFont::setPixelSize: Pixel size <= 0/,
    /CoreText performance note:/,
    /WARNING: Method userSpaceScaleFactor/
  ]

  def write(message)
    if ignore?(message)
      0
    else
      puts(message)
      1
    end
  end

  private

  def ignore?(message)
    IGNORE_PATTERNS.any? { |regexp| message =~ regexp }
  end
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs_logger: WarningSuppressor.new, timeout: 60)
end

Capybara.javascript_driver = :poltergeist
