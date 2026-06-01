import React, { PropsWithChildren } from 'react';

interface VisibilityControllerProps {
  isVisible: boolean;
}

const VisibilityController = ({ isVisible, children }: PropsWithChildren<VisibilityControllerProps>) => {
  if (!isVisible) return null;

  return <>{children}</>;
};

export default VisibilityController;
