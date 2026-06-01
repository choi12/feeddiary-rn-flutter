import React, { Component, ErrorInfo, PropsWithChildren, ReactNode } from 'react';

import ErrorView from '@/components/common/stateView/ErrorView';
import { reportError } from '@/utils/error/reportError';

interface ErrorBoundaryProps extends PropsWithChildren {
  fallback?: (reset: () => void) => ReactNode;
}

interface ErrorBoundaryState {
  hasError: boolean;
}

class ErrorBoundary extends Component<ErrorBoundaryProps, ErrorBoundaryState> {
  state: ErrorBoundaryState = { hasError: false };

  static getDerivedStateFromError(): ErrorBoundaryState {
    return { hasError: true };
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    reportError(error);
    if (__DEV__) console.error('[ErrorBoundary]', info.componentStack);
  }

  reset = () => this.setState({ hasError: false });

  render() {
    if (!this.state.hasError) return this.props.children;
    if (this.props.fallback) return this.props.fallback(this.reset);
    return <ErrorView reload={this.reset} />;
  }
}

export default ErrorBoundary;
