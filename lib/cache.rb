module Cache
  class Wrapper
    def get(_key)
      raise NotImplementedError, 'wrapper needs `get` method'
    end

    def set(_key, _value, _time)
      raise NotImplementedError, 'wrapper needs `set` method'
    end

    def extend(_key, _time)
      raise NotImplementedError, 'wrapper needs `extend` method'
    end
  end

  class None < Wrapper
    def get(_); end
    def set(_, _, _); end
    def extend(_); end
  end
end
