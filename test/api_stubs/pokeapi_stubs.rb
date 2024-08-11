# frozen_string_literal: true

module PokeapiStubs
  def stub_pokeapi_request(_pokemon_id, _pokemon_name)
    stub_request(:get, %r{https://pokeapi.co/api/v2/pokemon/\d+})
      .to_return(status: 200, body: { name: 'nidorino' }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  def stub_pokeapi_type_request
    stub_request(:get, 'https://pokeapi.co/api/v2/type/13/')
      .to_return(status: 200, body: {
        names: [
          { language: { name: 'en' }, name: 'Electric' }
        ]
      }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  def stub_pokeapi_color_request
    stub_request(:get, 'https://pokeapi.co/api/v2/pokemon-color/10/')
      .to_return(status: 200, body: {
        names: [
          { language: { name: 'en' }, name: 'Yellow' }
        ]
      }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  def stub_pokeapi_species_request
    stub_request(:get, 'https://pokeapi.co/api/v2/pokemon-species/25/')
      .to_return(status: 200, body: {
        names: [
          { language: { name: 'en' }, name: 'Pikachu' }
        ],
        color: { url: 'https://pokeapi.co/api/v2/pokemon-color/10/' }
      }.to_json, headers: { 'Content-Type' => 'application/json' })
  end
end
