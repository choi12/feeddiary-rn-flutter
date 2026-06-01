export const SIZE_PRESET = {
  small: {
    container: {
      flexDirection: 'row',
      gap: 10,
    },
    text: {
      marginVertical: 10,
      numberOfLines: 1,
    },
    image: {
      width: 45,
      height: 45,
      borderRadius: 5,
      marginTop: 0,
    },
  },
  large: {
    container: {
      flexDirection: 'column',
      gap: 0,
    },
    text: {
      marginVertical: 5,
      numberOfLines: 2,
    },
    image: {
      width: '100%',
      height: 150,
      borderRadius: 7,
      marginTop: 5,
    },
  },
} as const;
