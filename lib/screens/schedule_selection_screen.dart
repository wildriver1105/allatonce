import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../constants/colors.dart';

class ScheduleSelectionScreen extends StatefulWidget {
  const ScheduleSelectionScreen({super.key});

  @override
  State<ScheduleSelectionScreen> createState() => _ScheduleSelectionScreenState();
}

class _ScheduleSelectionScreenState extends State<ScheduleSelectionScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  bool _oneDayOnly = false;
  
  TimeOfDay _startTime = const TimeOfDay(hour: 1, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 1, minute: 0);
  
  bool _showTimePicker = true;
  bool _isSelectingStartTime = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '일정 선택',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 월 네비게이션
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            setState(() {
                              _currentMonth = DateTime(
                                _currentMonth.year,
                                _currentMonth.month - 1,
                              );
                            });
                          },
                        ),
                        Text(
                          '${_currentMonth.month}월',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            setState(() {
                              _currentMonth = DateTime(
                                _currentMonth.year,
                                _currentMonth.month + 1,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 요일 헤더
                    _buildWeekdayHeader(),
                    const SizedBox(height: 8),
                    // 캘린더
                    _buildCalendar(),
                    const SizedBox(height: 24),
                    // 하루만 예약 체크박스
                    Row(
                      children: [
                        Checkbox(
                          value: _oneDayOnly,
                          onChanged: (value) {
                            setState(() {
                              _oneDayOnly = value ?? false;
                              if (_oneDayOnly) {
                                _endTime = _startTime;
                              }
                            });
                          },
                        ),
                        const Text(
                          '하루만 예약',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // 시작일 선택
                    _buildDateTimeSelector(
                      label: '시작일 선택',
                      time: _startTime,
                      onTap: () {
                        setState(() {
                          _isSelectingStartTime = true;
                          _showTimePicker = true;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // 끝나는 날 선택
                    _buildDateTimeSelector(
                      label: '끝나는 날 선택',
                      time: _endTime,
                      onTap: () {
                        setState(() {
                          _isSelectingStartTime = false;
                          _showTimePicker = true;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // 시간 선택 휠 (조건부 표시)
            if (_showTimePicker) _buildTimePicker(),
            // 입력 완료 버튼
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  final displayText = _oneDayOnly
                      ? '${_selectedDate.month}/${_selectedDate.day} ${_formatTime(_startTime)}'
                      : '${_selectedDate.month}/${_selectedDate.day} ${_formatTime(_startTime)} - ${_formatTime(_endTime)}';
                  
                  Navigator.pop(context, {
                    'display': displayText,
                    'startDate': _selectedDate,
                    'startTime': _startTime,
                    'endTime': _endTime,
                    'oneDayOnly': _oneDayOnly,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '입력 완료',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: day == '일' ? Colors.red : Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = 일요일
    
    final daysInMonth = lastDayOfMonth.day;
    final previousMonthDays = firstWeekday;
    
    final List<Widget> dayWidgets = [];
    
    // 이전 달의 마지막 날들
    final previousMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 0);
    for (int i = previousMonthDays - 1; i >= 0; i--) {
      final day = previousMonth.day - i;
      dayWidgets.add(_buildDayCell(day, isCurrentMonth: false));
    }
    
    // 현재 달의 날들
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isSelected = date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;
      dayWidgets.add(_buildDayCell(day, isCurrentMonth: true, isSelected: isSelected));
    }
    
    // 다음 달의 첫 날들
    final remainingDays = 42 - dayWidgets.length; // 6주 * 7일
    for (int day = 1; day <= remainingDays; day++) {
      dayWidgets.add(_buildDayCell(day, isCurrentMonth: false));
    }
    
    return Column(
      children: [
        for (int week = 0; week < 6; week++)
          Row(
            children: dayWidgets
                .skip(week * 7)
                .take(7)
                .map((widget) => Expanded(child: widget))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildDayCell(int day, {required bool isCurrentMonth, bool isSelected = false}) {
    final isToday = isCurrentMonth &&
        day == DateTime.now().day &&
        _currentMonth.month == DateTime.now().month &&
        _currentMonth.year == DateTime.now().year;
    
    return GestureDetector(
      onTap: isCurrentMonth
          ? () {
              setState(() {
                _selectedDate = DateTime(_currentMonth.year, _currentMonth.month, day);
              });
            }
          : null,
      child: Container(
        height: 40,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? AppColors.primary
              : isToday
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
          border: isToday && !isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              fontSize: 14,
              color: isSelected
                  ? Colors.white
                  : isCurrentMonth
                      ? Colors.black87
                      : Colors.grey[300],
              fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeSelector({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _formatTime(time),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    final currentTime = _isSelectingStartTime ? _startTime : _endTime;
    final isPM = currentTime.hour >= 12;
    final displayHour = currentTime.hour == 0 ? 12 : (currentTime.hour > 12 ? currentTime.hour - 12 : currentTime.hour);
    
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: isPM ? 1 : 0,
              ),
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                setState(() {
                  final newIsPM = index == 1;
                  final currentDisplayHour = _isSelectingStartTime
                      ? (_startTime.hour == 0 ? 12 : (_startTime.hour > 12 ? _startTime.hour - 12 : _startTime.hour))
                      : (_endTime.hour == 0 ? 12 : (_endTime.hour > 12 ? _endTime.hour - 12 : _endTime.hour));
                  final newHour = newIsPM 
                      ? (currentDisplayHour == 12 ? 12 : currentDisplayHour + 12)
                      : (currentDisplayHour == 12 ? 0 : currentDisplayHour);
                  
                  if (_isSelectingStartTime) {
                    _startTime = TimeOfDay(hour: newHour, minute: _startTime.minute);
                    if (_oneDayOnly) {
                      _endTime = _startTime;
                    }
                  } else {
                    _endTime = TimeOfDay(hour: newHour, minute: _endTime.minute);
                  }
                });
              },
              children: const [
                Center(child: Text('오전')),
                Center(child: Text('오후')),
              ],
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: displayHour - 1,
              ),
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                setState(() {
                  final hour = index + 1;
                  final currentIsPM = _isSelectingStartTime
                      ? _startTime.hour >= 12
                      : _endTime.hour >= 12;
                  final newHour = currentIsPM 
                      ? (hour == 12 ? 12 : hour + 12)
                      : (hour == 12 ? 0 : hour);
                  
                  if (_isSelectingStartTime) {
                    _startTime = TimeOfDay(hour: newHour, minute: _startTime.minute);
                    if (_oneDayOnly) {
                      _endTime = _startTime;
                    }
                  } else {
                    _endTime = TimeOfDay(hour: newHour, minute: _endTime.minute);
                  }
                });
              },
              children: List.generate(12, (index) {
                return Center(child: Text('${index + 1}'));
              }),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                ': 00',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour;
    final period = hour >= 12 ? '오후' : '오전';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final minute = time.minute.toString().padLeft(2, '0');
    return '$period ${displayHour}시 $minute분';
  }
}

