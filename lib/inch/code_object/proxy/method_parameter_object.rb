module Inch
  module CodeObject
    module Proxy
      class MethodParameterObject
        attr_reader :name # @return [String] the name of the parameter

        # @param method [Inch::CodeObject::Proxy::MethodObject] the method the parameter belongs_to
        # @param name [String] the name of the parameter
        # @param tag [YARD::Tags::Tag] the Tag object for the parameter
        # @param in_signature [Boolean] +true+ if the method's signature contains the parameter
        def initialize(method, name, tag, in_signature)
          @method = method
          @name = name
          @tag = tag
          @in_signature = in_signature
        end

        BAD_NAME_EXCEPTIONS = %w(id)
        BAD_NAME_THRESHOLD = 3
        def bad_name?
          return false if BAD_NAME_EXCEPTIONS.include?(name)
          name.size < BAD_NAME_THRESHOLD || name =~ /[0-9]$/
        end

        # @return [Boolean] +true+ if the parameter is a block
        def block?
          name =~ /^\&/
        end

        # @return [Boolean] +true+ if an additional description given?
        def described?
          @tag && !@tag.text.empty?
        end

        # @return [Boolean] +true+ if the parameter is mentioned in the docs
        def mentioned?
          !!@tag || in_method_docstring?
        end

        # @return [Boolean] +true+ if the parameter is a splat argument
        def splat?
          name =~ /^\*/
        end

        # @return [Boolean] +true+ if the type of the parameter is defined
        def typed?
          @tag && @tag.types && !@tag.types.empty?
        end

        # @return [Boolean] +true+ if the parameter is mentioned in the docs, but not present in the method's signature
        def wrongly_mentioned?
          mentioned? && !@in_signature
        end

        private

        def in_method_docstring?
          if @method.docstring.mentions_parameter?(name)
            true
          else
            unsplatted = name.gsub(/^[\&\*]/, '')
            @method.docstring.mentions_parameter?(unsplatted)
          end
        end
      end
    end
  end
end