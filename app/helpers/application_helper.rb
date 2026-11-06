module ApplicationHelper
  # Builds a Mapbox Static Images API URL (docs.mapbox.com/api/maps/#static-images).
  # The API returns a PNG, so the URL can go straight into an <img> tag.
  # NOTE: Mapbox wants LONGITUDE first, then latitude.
  def mapbox_map_url(areas, width: 800, height: 400)
    # The token comes from an environment variable, so it never goes on GitHub
    token = ENV["MAPBOX_TOKEN"]

    # Only areas that have coordinates can be drawn
    areas = Array(areas).select { |a| a.latitude && a.longitude }
    return nil if token.blank? || areas.empty?

    # One red pin per area. Marker format: pin-{size}+{colour}({lon},{lat})
    pins = areas.map { |a| "pin-s+d9534f(#{a.longitude},#{a.latitude})" }.join(",")

    # One area: centre on it at zoom 3. Several areas: "auto" fits every pin.
    view = areas.size == 1 ? "#{areas.first.longitude},#{areas.first.latitude},3" : "auto"

    "https://api.mapbox.com/styles/v1/mapbox/streets-v12/static/#{pins}/#{view}/#{width}x#{height}@2x?access_token=#{token}"
  end
end
