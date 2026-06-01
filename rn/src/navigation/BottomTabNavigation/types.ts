export type TabParamList = {
  MyFlowerpot: undefined;
  MyDiary: undefined;
  Community: undefined;
  Letters: undefined;
  Setting: undefined;
};

export type TabScreen = { name: keyof TabParamList; component: React.ComponentType; label: string };
