module AddPositionExtention
  def << *args
    arg = args.first
    if arg.respond_to? :position
      arg.position = proxy_association.target.last.position + 1 unless proxy_association.target.empty?
    end
    super
  end

  def build(attributes = {}, &block)
    if proxy_association.reflection.klass.column_names.include? "position"
      attributes.merge!(:position => proxy_association.target.last.position + 1) unless proxy_association.target.empty?
    end
    super
  end

end
