import dayjs from 'dayjs';

type DateFormat = 'diary' | 'default';

const DATE_CONSTANTS = {
  AM: '오전',
  PM: '오후',
  TODAY: '오늘',
} as const;

/**
 * @example
 * // 올해
 * formatDate('2024-03-04 09:30:00') // "3월 4일, 오전 9:30"
 * formatDate('2024-03-04', 'diary') // "3월 4일"
 *
 * // 오늘
 * formatDate('2024-03-04') // "오늘, 오전 9:30"
 * formatDate('2024-03-04', 'diary') // "오늘"
 *
 * // 다른 연도
 * formatDate('2023-03-04') // "2023년 3월 4일"
 */
export const formatDate = (date: string, format: DateFormat = 'default') => {
  const inputDate = dayjs(date);
  if (!inputDate.isValid()) return date;

  const today = dayjs();
  const isThisYear = inputDate.year() === today.year();
  const isToday = inputDate.isSame(today, 'day');
  const isMorning = inputDate.format('A') === DATE_CONSTANTS.AM;

  const FORMAT_DATE_ACTIONS = {
    diary: () =>
      isThisYear ? (isToday ? DATE_CONSTANTS.TODAY : inputDate.format('M월 D일')) : inputDate.format('YYYY년 M월 D일'),
    default: () =>
      isThisYear
        ? `${isToday ? DATE_CONSTANTS.TODAY + ',' : inputDate.format('M월 D일,')} ${
            isMorning ? DATE_CONSTANTS.AM : DATE_CONSTANTS.PM
          } ${inputDate.format('h:mm')}`
        : `${inputDate.format('YYYY년 M월 D일')}`,
  };

  return FORMAT_DATE_ACTIONS[format]();
};
