# frozen_string_literal: true

# Adds +styled_check_box+ and +styled_check_box_tag+ to Rails form helpers.
module ActionView
  module Helpers
    class FormBuilder
      def styled_check_box(method, text = method.to_s.humanize, checkbox_options = {})
        @template.content_tag(:div, class: 'checkbox') do
          checkbox_options[:class] = 'checkbox__default-input ' + checkbox_options[:class].to_s
          check_box(method, checkbox_options) +
            label(method, class: 'checkbox__label') do
              @template.content_tag(:span, class: 'checkbox__text') { text }
            end
        end
      end
    end

    module FormTagHelper
      def styled_check_box_tag(name, text = name.to_s.humanize, value = '1', checked = false, checkbox_options = {})
        content_tag(:div, class: 'checkbox') do
          checkbox_options[:class] = 'checkbox__default-input ' + checkbox_options[:class].to_s
          check_box_tag(name, value, checked, checkbox_options) +
            label_tag(name, class: 'checkbox__label') do
              content_tag(:span, class: 'checkbox__text') { text }
            end
        end
      end
    end
  end
end
