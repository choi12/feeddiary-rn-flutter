export interface SignInRequest {
  user_id: string;
  fcm_token: string;
}

export interface AutoSignInRequest {
  access_token: string;
}
