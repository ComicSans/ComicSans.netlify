module Jekyll

  class CorePatch < Jekyll::Generator

    def generate(site)
    end

  end

end

class Hash

  def transform_keys
    return enum_for(:transform_keys) { size } unless block_given?
    result = {}
    each_key do |key|
      result[yield(key)] = self[key]
    end
    result
  end

end
