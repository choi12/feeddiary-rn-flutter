declare global {
  module '*.png' {
    const content: number;
    export default content;
  }

  module '*.jpg' {
    const content: number;
    export default content;
  }
}

export {};
