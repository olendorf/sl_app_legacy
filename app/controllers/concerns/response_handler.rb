# frozen_string_literal: true


# Handles api json responses.
module ResponseHandler
  def flash_response(message, level = :alert)
    flash[level] = message
    redirect_back(fallback_location: root_path)
  end
end

