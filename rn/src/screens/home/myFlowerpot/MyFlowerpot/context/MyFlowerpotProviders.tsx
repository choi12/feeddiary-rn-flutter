import React, { PropsWithChildren } from 'react';

import FlowerpotProvider from './flowerpot/FlowerpotProvider';
import SidePannelProvider from './sidePannel/SidePannelProvider';

function MyFlowerpotProviders({ children }: PropsWithChildren) {
  return (
    <FlowerpotProvider>
      <SidePannelProvider>{children}</SidePannelProvider>
    </FlowerpotProvider>
  );
}

export default MyFlowerpotProviders;
