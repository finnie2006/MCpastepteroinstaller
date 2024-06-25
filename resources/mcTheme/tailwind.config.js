const colors = require('tailwindcss/colors');

const gray = {
    50: 'hsl(216, 33%, 97%)',
    100: 'hsl(214, 15%, 91%)',
    200: 'hsl(210, 16%, 82%)',
    300: 'hsl(211, 13%, 65%)',
    400: 'hsl(130, 19%, 53%)',
    // 500: 'hsl(211, 12%, 43%)',
    500: 'hsl(131, 23%, 45%)',
    600: 'hsl(130, 19%, 53%)',
    700: 'hsl(209, 18%, 30%)',
    800: 'hsl(209, 20%, 25%)',
    900: 'hsl(210, 24%, 16%)',
};

module.exports = {
    content: [
        './resources/scripts/**/*.{js,ts,tsx}',
    ],
    theme: {
        extend: {
            fontFamily: {
                header: ['"IBM Plex Sans"', '"Roboto"', 'system-ui', 'sans-serif'],
            },
            colors: {
                black: '#131a20',
                // "primary" and "neutral" are deprecated, prefer the use of "blue" and "gray"
                // in new code.
                theme: {
                    // accent: 'hsl(131, 23%, 28%)',
                    accent: 'hsl(131, 23%, 28%)',
					'accent-2': 'hsl(131, 19%, 19%)',
                    main: 'hsl(131, 23%, 28%)',
                    'main-2': 'hsl(131, 23%, 28%)',
                    // main: 'hsl(231, 14%, 18%)',
                    // 'main-2': 'hsl(230, 15%, 16%)',
                },
                primary: colors.blue,
                gray: gray,
                neutral: gray,
                cyan: colors.cyan,
            },
            fontSize: {
                '2xs': '0.625rem',
            },
            transitionDuration: {
                250: '250ms',
            },
            borderColor: theme => ({
                default: theme('colors.neutral.400', 'currentColor'),
            }),
        },
        backgroundImage: {
            'mc': "url('https://wallpaperaccess.com/full/37440.jpg')",
        },
    },
    plugins: [
        require('@tailwindcss/line-clamp'),
        require('@tailwindcss/forms')({
            strategy: 'class',
        }),
    ]
};