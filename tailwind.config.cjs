/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./index.html', './src/**/*.{ts,tsx}'],
  theme: {
    fontFamily: {
      sans: ['IBM Plex Sans JP', 'sans-serif'],
    },
    extend: {},
  },
  plugins: [require('daisyui'), require('@tailwindcss/typography')],
};
