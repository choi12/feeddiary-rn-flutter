import { Dayjs } from 'dayjs';

export type Day = Dayjs;
export type CalendarDay = Day | null;
export type CalendarDays = CalendarDay[][];
