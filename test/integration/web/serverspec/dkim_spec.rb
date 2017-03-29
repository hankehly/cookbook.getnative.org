require 'spec_helper'

describe 'get-native.com-cookbook::web' do
    describe package('opendkim') do
        it { should be_installed }
    end

    describe package('opendkim-tools') do
        it { should be_installed }
    end

    describe service('opendkim') do
        it { should be_enabled }
        it { should be_running.under('systemd') }
    end

    describe file('/etc/dkimkeys/local.get-native.com') do
        it { should be_directory }
    end

    describe file('/etc/dkimkeys/local.get-native.com/mail.private') do
        it { should be_file }
        it { should exist }
        it { should be_mode 0600 }
        it { should be_owned_by 'opendkim' }
        it { should be_grouped_into 'opendkim' }
    end

    describe file('/etc/dkimkeys/dkim.key') do
        it { should be_file }
        it { should exist }
        it { should be_mode 0600 }
        it { should be_owned_by 'opendkim' }
        it { should be_grouped_into 'opendkim' }
        its(:content) { should match /^\*@local\.get-native.com:local\.get-native.com:\/etc\/dkimkeys\/local\.get-native.com\/mail.private$/ }
    end

    describe file('/etc/opendkim.conf') do
        it { should be_file }
        it { should exist }
        it { should be_mode 0644 }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        its(:content) { should match /Domain\s+local\.get-native.com/ }
    end

    describe file('/etc/default/opendkim') do
        it { should be_file }
        it { should exist }
        its(:content) { should match /SOCKET="inet:8891@localhost"/ }
    end
end
