import React from 'react';
import { StyleSheet, View } from 'react-native';

import { COLORS } from '@/constants';

import { SETTING_MENU_ITEMS } from '../../data';

import MenuButton from './components/MenuButton';
import SignOutButton from './components/SignOutButton';

function MenuButtonBox() {
  return (
    <View style={styles.bottomBox}>
      {SETTING_MENU_ITEMS.map((menuItem) => (
        <MenuButton key={menuItem.title} menuItem={menuItem} />
      ))}
      <SignOutButton />
    </View>
  );
}

const styles = StyleSheet.create({
  bottomBox: {
    flex: 1,
    backgroundColor: COLORS.CORE.BACKGROUND,
  },
});

export default MenuButtonBox;
