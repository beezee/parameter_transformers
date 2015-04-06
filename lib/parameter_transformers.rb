require "parameter_transformers/version"

module ParameterTransformers

  class Proxy

    instance_methods.each do |m|
      undef_method(m) unless m =~ /(^__|^nil\?$|^send$|^object_id$)/
    end

    def initialize(target, transformers={})
      @target, @transformers = target, transformers
    end

    def respond_to?(symbol, include_priv=false)
      @target.respond_to?(symbol, include_priv)
    end

    def method_missing(m, *args, &block)
      params = @target.method(m).parameters.map(&:last)
      t_args = args.dup
      params.each_with_index do |param, ix|
        if @transformers[[m, param]] &&
          @transformers[[m, param]].kind_of?(Proc)
            t_args[ix] =
              @transformers[[m, param]].call(t_args[ix])
        end
      end
      @target.send(m, *t_args, &block)
    end
  end
end
