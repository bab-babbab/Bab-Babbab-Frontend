import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bab_babbab_front/service/meal_service.dart';
import 'package:provider/provider.dart';
import 'package:bab_babbab_front/models/user_model.dart';

class FoodBoardPage extends StatefulWidget {
  const FoodBoardPage({super.key});

  @override
  State<FoodBoardPage> createState() => _FoodBoardPageState();
}

class _FoodBoardPageState extends State<FoodBoardPage> {
  late Future<Map<String, dynamic>> _mealFuture;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _mealFuture = loadMeal();
  }

  void _goToPreviousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 1));
      _mealFuture = loadMeal();
    });
  }

  void _goToNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 1));
      _mealFuture = loadMeal();
    });
  }

  Future<Map<String, dynamic>> loadMeal() async {
    final school = await MealService.getSchoolInfo('미림마이스터고등학교');

    if (school == null ||
        school['eduOfficeCode'] == null ||
        school['schoolCode'] == null) {
      return {'isEmpty': true, 'meals': []};
    }

    final dateString = DateFormat('yyyyMMdd').format(_selectedDate);

    final meals = await MealService.getMealInfo(
      eduOfficeCode: school['eduOfficeCode']!,
      schoolCode: school['schoolCode']!,
      date: dateString,
    );

    return {'isEmpty': meals.isEmpty, 'meals': meals};
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth - 50;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 0,
        backgroundColor: Color(0xffFFAD0A),
        shape: CircleBorder(),
      ),
      backgroundColor: const Color(0xffF7F8F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xffF7F8F9),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _mealFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            final data = snapshot.data!;
            final meals = data['meals'] as List<Map<String, String>>;
            final isEmpty = data['isEmpty'] as bool;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name}님의\n${user.school} 급식🔥',
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: containerWidth,
                    height: 74,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Center(
                      child: Text(
                        '${user.message}',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          color: Color(0xff898A8D),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _goToPreviousDay,
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Text(
                        DateFormat('MM월 dd일').format(_selectedDate),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      IconButton(
                        onPressed: _goToNextDay,
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          '오늘은 주말 또는 공휴일로 \n 급식이 제공되지 않습니다.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff898A8D),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                    )
                  else
                    ...meals.map(
                      (meal) => Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 24,
                            right: 24,
                            top: 17,
                            bottom: 17,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    meal['mealType'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Pretendard',
                                    ),
                                  ),
                                  SizedBox(width: containerWidth - 150),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      meal['calories'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xffFFAD0A),
                                        fontFamily: 'Pretendard',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                meal['meal'] ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Pretendard',
                                  color: Color(0xff898A8D),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
