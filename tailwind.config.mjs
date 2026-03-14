/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      colors: {
        brand: {
          dark: '#003B1C',    /* Primary Dark Green */
          lime: '#8EC641',    /* Accent Light Green */
          pink: '#E63380',    /* CTA Pink */
          cream: '#FEFDF9',  /* Background Cream */
        }
      },
      fontFamily: {
        heading: ['Tenor Sans', 'serif'],
        sans: ['Montserrat', 'Inter', 'sans-serif'],
      },
      keyframes: {
        float: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-10px)' },
        }
      },
      animation: {
        float: 'float 6s ease-in-out infinite',
      }
    },
  },
  plugins: [],
};
