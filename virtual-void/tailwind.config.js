module.exports = {
    purge: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
    darkMode: false, // or 'media' or 'class'
    theme: {
        extend: {},
        fontFamily: {
            'serif': ['IBM Plex Serif'],
            'sans': ['IBM Plex Sans'],
            'mono': ['IBM Plex Mono']
        }
    },
    variants: {
        extend: {},
    },
    plugins: [],
}
