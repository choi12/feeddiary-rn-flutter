export type FormDataLike = {
  _parts?: [string, unknown][];
  entries?: () => IterableIterator<[string, unknown]>;
};

export const getFormField = (data: unknown, key: string): unknown => {
  const fd = data as FormDataLike | undefined;
  if (fd && typeof fd.entries === 'function') {
    for (const [k, v] of fd.entries()) {
      if (k === key) return v;
    }
    return undefined;
  }
  const parts = fd?._parts ?? [];
  return parts.find(([k]) => k === key)?.[1];
};

export const getString = (v: unknown, fallback = ''): string => (typeof v === 'string' ? v : fallback);

export const getNumber = (v: unknown, fallback = 0): number => {
  const n = Number(v);
  return Number.isFinite(n) ? n : fallback;
};

export const getImageUri = (v: unknown): string | undefined => {
  if (v && typeof v === 'object' && 'uri' in v) return String((v as { uri: string }).uri);
  return undefined;
};
