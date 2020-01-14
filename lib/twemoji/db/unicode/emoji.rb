# frozen_string_literal: true

class Emoji
  attr_reader :codepoints, :status, :unicode, :description

  def initialize(data)
    @codepoints = data[:codepoints].strip
    @status = data[:status].strip
    @unicode = data[:unicode]
    @description = data[:description]
  end

  def to_h(group:, subgroup:, keywords:)
    {
      unicode: unicode,
      codepoints: codepoints,
      description: description,
      keywords: keywords,
      group: group,
      subgroup: subgroup,
      status: status,
    }
  end

  def inspect
    "#<Emoji #{@unicode}>"
  end
end
