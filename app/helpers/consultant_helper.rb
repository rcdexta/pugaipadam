module ConsultantHelper

  def render_persona(consultant, persona_type)
    content_tag :td do
      link_to persona_url(consultant, persona_type), target: "_blank" do
        image_tag "persona/#{persona_type}.png", title: persona_type
      end
    end if consultant.persona and consultant.persona.send(persona_type).present?
  end

  def persona_url(consultant,persona_type)
    persona_link = consultant.persona.send(persona_type)
    case persona_type
      when :twitter
        persona_link = persona_link.gsub /@/,''
        "https://twitter.com/#{persona_link}"
      when :github
        "https://github.com/#{persona_link}"
      when :blog
        blog_url = persona_link.gsub /http:\/\//, ''
        "http://#{blog_url}"
      when :stackoverflow
        "http://stackoverflow.com/users/#{persona_link}"
      when :good_reads
        "http://www.goodreads.com/user/show/#{persona_link}"
    end
  end
end