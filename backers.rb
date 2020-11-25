#!/usr/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'erb'

rows = CSV.read(File.expand_path('~/Downloads/Download.csv'), encoding: 'bom|utf-8', headers: true)
donations = rows.map { _1.to_h.transform_keys(&:to_sym) }
                .select { _1[:Net].to_f.positive? }
                .reject { _1[:Name].empty? }
                .reject { _1[:Type].match?(/refund|reversal|redemption/i) }
backers = donations.map { _1[:Name] }.uniq

puts ERB.new(DATA.read, trim_mode: '<>').result(binding)

__END__
Backers :heart:
===============

*Updated: <%= Date.today %>*

Thanks for supporting my work. Please let me know if your name is missing, or
if you don't want to be listed.

---

<% backers.sort_by(&:downcase).each do |name| %>
- <%= name %>
<% end %>
