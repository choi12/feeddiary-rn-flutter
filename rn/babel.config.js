module.exports = {
  presets: ['babel-preset-expo'],
  plugins: [
    ['babel-plugin-react-compiler', { target: '19' }],
    [
      'module-resolver',
      {
        root: ['./src'],
        extensions: ['.js', '.ts', '.tsx', '.json'],
        alias: {
          '@': './src',
        },
      },
    ],
    ['react-native-worklets/plugin'],
  ],
  env: {
    production: {
      plugins: [['transform-remove-console', { exclude: ['error', 'warn'] }]],
    },
  },
};
