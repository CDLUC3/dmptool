import {useState, useEffect} from 'react';


export function isEmpty(obj) {
  for (const prop in obj) {
    if (Object.hasOwn(obj, prop)) {
      return false;
    }
  }
  return true;
}


export function getValue(obj, path, defaultNone) {
  if (!obj) return defaultNone;
  if (typeof defaultNone === 'undefined') defaultNone = "";
  if (typeof path === 'string') path = path.split(".");

  if (path.length === 0) throw "Path Length is Zero";
  if (path.length === 1) return obj[path[0]];

  if (!obj[path[0]]) return defaultNone;
  return getValue(obj[path[0]], path.slice(1));
};


export function useDebounce(val, delay) {
  const [debouncedValue, setDebouncedValue] = useState(val);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(val);
    }, delay);

    return () => {
      clearTimeout(handler);
    }
  }, [val]);

  return debouncedValue;
}
