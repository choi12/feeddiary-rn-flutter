export type Profile = {
  image: string;
  background?: string;
  character?: string;
};

export interface NicknameBoxProfile extends Profile {
  nickname: string;
}

export type NicknameValidationStatus = 'success' | 'duplicate' | 'regex' | undefined;

export type SelectedImage = {
  uri: string;
  name: string;
  type: string;
};
