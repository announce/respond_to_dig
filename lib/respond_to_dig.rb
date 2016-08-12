# Extracts the nested value specified by the sequence of index by calling dig at each step,
# returning nil if any intermediate step is nil.
# @example
#   h = RespondToDig.invoke({ foo: {bar: {baz: 1 }}})
#   h.dig(:foo, :bar, :baz)           #=> 1
#   h.dig(:foo, :zot, :xyz)           #=> nil
#   h.dig(:foo, :bar, :baz, :xyz)     #=> TypeError
#
#   g = RespondToDig.invoke({ foo: [10, 11, 12] })
#   g.dig(:foo, 1)                    #=> 11
module RespondToDig

  class << self
    # Invokes `RespondToDig` module if the `receiver` object is digabble
    # @see RespondToDig#digabble
    # @param receiver [Object]
    # @return [Object, RespondToDig]
    def respond_to_dig(receiver)
      receiver.tap do |r|
        r.singleton_class.send(:include, RespondToDig) if RespondToDig.diggable? r
      end
    end

    # Returns whether the `target` object is able to be invoked by `RespondToDig`
    # @note The reason why not purely duck typed by `[]` method is to avoid unexpected behavior,
    #   for example we won't get `'o'` by `'foo'.dig(1)` by String#[].
    # @param target [Object]
    # @return [Bool]
    def diggable?(target)
      target.is_a? Enumerable and
          target.respond_to? :[] and
          not target.respond_to? :dig
    end

    # @deprecated Please use {#invoke} instead
    alias_method :invoke_dig, :respond_to_dig
    alias_method :invoke, :respond_to_dig
  end

  # Retrieves the value object corresponding to the each `key` objects recursively with nil-safe
  # @param key [Object, ...]
  # @raise [TypeError] Throws if trying to access the value which doesn't respond to `#dig` such as `String` object
  # @return [Object, RespondToDig, NilClass]
  def dig(key, *rest)
    value = RespondToDig.invoke(self[key])
    if value.nil? || rest.empty?
      value
    elsif value.respond_to?(:dig)
      value.dig(*rest)
    else
      fail TypeError, "#{value.class} does not have #dig method"
    end
  end

end
