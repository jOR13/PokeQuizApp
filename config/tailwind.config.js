const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        pokemon: ['PokemonSolid', 'sans-serif'],
      },
      colors: {
        pokemonYellow: '#FFCB05',
        pokemonRed: '#EE1A1B',
        pokemonBlue: '#3B4CCA',
        pokemonBlack: '#2A2A2A',
        pokemonWhite: '#FFFFFF',
      },
      letterSpacing: {
        wider: '0.15em',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
