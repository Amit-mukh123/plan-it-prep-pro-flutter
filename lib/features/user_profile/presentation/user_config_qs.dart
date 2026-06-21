import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:ileum/features/user_profile/data/user_provider.dart';
import 'package:ileum/core/theme/app_theme.dart';
import 'package:ileum/features/user_profile/data/user_summary_state_provider.dart';

class QuestionnaireScreen extends ConsumerStatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  ConsumerState<QuestionnaireScreen> createState() =>
      _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends ConsumerState<QuestionnaireScreen> {
  int _currentIndex = 0;
  final Map<String, dynamic> _answers = {};
  final TextEditingController _otherAllergyController = TextEditingController();
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  String? _selectedCountryCode;
  bool _isLocationLoading = false;
  List<csc.Country> _countries = [];
  List<csc.State> _states = [];
  List<csc.City> _cities = [];

  final List<Map<String, dynamic>> _questions = [
    {
      "id": "allergies",
      "question": "Do you have any food allergies?",
      "type": "mcq_multi_csv_with_other",
      "options": [
        {"text": "None", "icon": Icons.check_circle_outline_rounded},
        {"text": "Dairy", "icon": Icons.water_drop_outlined},
        {"text": "Nuts", "icon": Icons.bakery_dining_outlined},
        {"text": "Gluten", "icon": Icons.grass_outlined},
        {"text": "Others", "icon": Icons.add_circle_outline_rounded},
      ],
    },
    {
      "id": "food_pref",
      "question": "What are your food preferences?",
      "type": "mcq_single",
      "options": [
        {"text": "Spicy", "icon": Icons.whatshot_rounded},
        {"text": "Low-carb", "icon": Icons.trending_down_rounded},
        {"text": "High-protein", "icon": Icons.fitness_center_rounded},
        {"text": "Balanced", "icon": Icons.scale_rounded},
      ],
    },
    {
      "id": "location",
      "question": "Which country, state, and city are you in?",
      "type": "location_picker",
      "options": [],
    },
    {
      "id": "meals_per_day",
      "question": "How many meals do you prefer per day?",
      "type": "mcq_single",
      "options": [
        {"text": "3 meals", "icon": Icons.filter_3_rounded},
        {"text": "4 meals", "icon": Icons.filter_4_rounded},
        {"text": "5+ meals", "icon": Icons.add_circle_outline_rounded},
        {"text": "Flexible", "icon": Icons.all_inclusive_rounded},
      ],
    },
    {
      "id": "prep_style",
      "question": "What is your meal preparation style?",
      "type": "mcq_multi_csv",
      "options": [
        {"text": "Batch cooking", "icon": Icons.layers_rounded},
        {"text": "Fresh daily", "icon": Icons.restaurant_rounded},
      ],
    },
    {
      "id": "appliances",
      "question": "Which kitchen appliances do you have?",
      "type": "mcq_multi_csv",
      "options": [
        {"text": "Stove & Oven", "icon": Icons.countertops_rounded},
        {"text": "Microwave", "icon": Icons.microwave_rounded},
        {"text": "Air Fryer", "icon": Icons.air_rounded},
        {"text": "Blender", "icon": Icons.blender_rounded},
      ],
    },
    {
      "id": "cooking_time",
      "question": "Preferred cooking time?",
      "type": "mcq_multi_csv",
      "options": [
        {"text": "Morning", "icon": Icons.light_mode_rounded},
        {"text": "Evening", "icon": Icons.wb_twilight_rounded},
        {"text": "Night", "icon": Icons.dark_mode_rounded},
      ],
    },
    {
      "id": "reminders",
      "question": "How would you like reminders?",
      "type": "mcq_single",
      "options": [
        {"text": "Daily", "icon": Icons.notifications_active_rounded},
        {"text": "Weekly", "icon": Icons.calendar_view_week_rounded},
        {"text": "No reminders", "icon": Icons.notifications_off_rounded},
      ],
    },
    {
      "id": "target_calorie",
      "question": "What is your target daily calorie intake?",
      "type": "mcq_single",
      "options": [
        {
          "text": "1200 kcal (Weight Loss)",
          "icon": Icons.local_fire_department_outlined,
        },
        {
          "text": "1500 kcal (Light Active)",
          "icon": Icons.directions_walk_rounded,
        },
        {"text": "1800 kcal (Moderate)", "icon": Icons.directions_run_rounded},
        {"text": "2200 kcal (Active)", "icon": Icons.fitness_center_rounded},
        {"text": "2500+ kcal (High)", "icon": Icons.sports_gymnastics_rounded},
      ],
    },
    {
      "id": "cooking_day",
      "question": "Which day do you prefer to cook?",
      "type": "mcq_multi",
      "options": [
        {"text": "Monday", "value": 1, "icon": Icons.calendar_today_rounded},
        {"text": "Tuesday", "value": 2, "icon": Icons.calendar_today_rounded},
        {"text": "Wednesday", "value": 3, "icon": Icons.calendar_today_rounded},
        {"text": "Thursday", "value": 4, "icon": Icons.calendar_today_rounded},
        {"text": "Friday", "value": 5, "icon": Icons.calendar_today_rounded},
        {"text": "Saturday", "value": 6, "icon": Icons.calendar_today_rounded},
        {"text": "Sunday", "value": 7, "icon": Icons.calendar_today_rounded},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, dynamic> args = Get.arguments ?? {};
      final bool isEdited = args['isEdited'] ?? false;

      if (isEdited) {
        final summary = ref.read(userSummaryProvider);
        final existingAnswers =
            summary['data']?['config']?['answers'] as Map<String, dynamic>?;

        if (existingAnswers != null) {
          setState(() {
            _answers.addAll(existingAnswers);
            _selectedCountry = _cleanString(existingAnswers['country']);
            _selectedState = _cleanString(existingAnswers['state']);
            _selectedCity = _cleanString(existingAnswers['city']);

            // Check if allergies contain something not in the standard list to fill "Others"
            String allergyStr = _answers['allergies'] ?? "";
            List<String> items = allergyStr.split(', ');
            List<String> standardOptions = ["None", "Dairy", "Nuts", "Gluten"];

            List<String> others = items
                .where((i) => !standardOptions.contains(i))
                .toList();
            if (others.isNotEmpty) {
              _otherAllergyController.text = others.join(', ');
              // Keep only standard options in the list; replace custom values
              // with the "Others" placeholder so _saveUserDetails adds them once.
              items = items.where((i) => standardOptions.contains(i)).toList();
              items.add('Others');
              _answers['allergies'] = items.join(', ');
            }
          });
        }
      }

      _loadLocationData();
    });
  }

  @override
  void dispose() {
    _otherAllergyController.dispose();
    super.dispose();
  }

  Future<void> _loadLocationData() async {
    if (_isLocationLoading) {
      return;
    }

    setState(() {
      _isLocationLoading = true;
    });

    final countries = await csc.getAllCountries();
    countries.sort((left, right) => left.name.compareTo(right.name));

    if (!mounted) {
      return;
    }

    setState(() {
      _countries = countries;
      _isLocationLoading = false;
    });

    await _syncLocationLists();
  }

  Future<void> _syncLocationLists() async {
    final country = _findCountryByName(_selectedCountry);
    if (country == null) {
      return;
    }

    _selectedCountryCode = country.isoCode;

    final states = await csc.getStatesOfCountry(country.isoCode);
    states.sort((left, right) => left.name.compareTo(right.name));

    if (!mounted) {
      return;
    }

    final selectedState = _findStateByName(states, _selectedState);
    final nextStateCode = selectedState?.isoCode;

    List<csc.City> cities = [];
    if (nextStateCode != null) {
      cities = await csc.getStateCities(country.isoCode, nextStateCode);
      cities.sort((left, right) => left.name.compareTo(right.name));
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _states = states;
      _cities = cities;
    });
  }

  csc.Country? _findCountryByName(String? name) {
    if (name == null) {
      return null;
    }

    for (final country in _countries) {
      if (country.name.toLowerCase() == name.toLowerCase()) {
        return country;
      }
    }
    return null;
  }

  csc.State? _findStateByName(List<csc.State> states, String? name) {
    if (name == null) {
      return null;
    }

    for (final state in states) {
      if (state.name.toLowerCase() == name.toLowerCase()) {
        return state;
      }
    }
    return null;
  }

  String? _cleanString(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }

  void _handleLocationChange({String? country, String? state, String? city}) {
    setState(() {
      if (country != null) {
        _selectedCountry = country.trim().isEmpty ? null : country.trim();
        _answers['country'] = _selectedCountry ?? '';
        _selectedState = null;
        _selectedCity = null;
        _selectedCountryCode = _findCountryByName(_selectedCountry)?.isoCode;
        _states = [];
        _cities = [];
        _answers.remove('state');
        _answers.remove('city');
      }

      if (state != null) {
        _selectedState = state.trim().isEmpty ? null : state.trim();
        if (_selectedState == null) {
          _answers.remove('state');
        } else {
          _answers['state'] = _selectedState;
        }
        _selectedCity = null;
        _cities = [];
        _answers.remove('city');
      }

      if (city != null) {
        _selectedCity = city.trim().isEmpty ? null : city.trim();
        if (_selectedCity == null) {
          _answers.remove('city');
        } else {
          _answers['city'] = _selectedCity;
        }
      }
    });

    if (country != null) {
      unawaited(_syncLocationLists());
      return;
    }

    if (state != null && _selectedCountryCode != null) {
      final selectedState = _findStateByName(_states, _selectedState);
      if (selectedState != null) {
        unawaited(_loadCitiesForState(selectedState.isoCode));
      }
    }
  }

  Future<void> _loadCitiesForState(String stateCode) async {
    if (_selectedCountryCode == null) {
      return;
    }

    final cities = await csc.getStateCities(_selectedCountryCode!, stateCode);
    cities.sort((left, right) => left.name.compareTo(right.name));

    if (!mounted) {
      return;
    }

    setState(() {
      _cities = cities;
    });
  }

  bool _canProceed(Map<String, dynamic> question) {
    if (question['type'] == 'location_picker') {
      return (_selectedCountry ?? '').isNotEmpty &&
          (_selectedState ?? '').isNotEmpty &&
          (_selectedCity ?? '').isNotEmpty;
    }

    final dynamic selectedValue = _answers[question['id']];
    if (selectedValue is String) {
      return selectedValue.isNotEmpty;
    }
    if (selectedValue is List) {
      return selectedValue.isNotEmpty;
    }
    return selectedValue != null;
  }

  void _handleSelection(String questionId, String type, dynamic option) {
    setState(() {
      if (type == "mcq_single") {
        _answers[questionId] = option['text'];
      } else if (type == "mcq_multi_csv" ||
          type == "mcq_multi_csv_with_other") {
        String currentStr = _answers[questionId] ?? "";
        List<String> items = currentStr.isEmpty ? [] : currentStr.split(', ');
        String val = option['text'];

        if (val == "None" && type == "mcq_multi_csv_with_other") {
          items = ["None"];
          _otherAllergyController.clear();
        } else {
          if (items.contains("None")) items.remove("None");
          if (items.contains(val)) {
            items.remove(val);
            if (val == "Others") _otherAllergyController.clear();
          } else {
            items.add(val);
          }
        }
        _answers[questionId] = items.join(', ');
      } else if (type == "mcq_multi") {
        List<int> currentSelection = List<int>.from(_answers[questionId] ?? []);
        int val = option['value'];
        if (currentSelection.contains(val)) {
          currentSelection.remove(val);
        } else {
          currentSelection.add(val);
        }
        currentSelection.sort();
        _answers[questionId] = currentSelection;
      }
    });
  }

  Future<void> _saveUserDetails() async {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String userGoal = args['goal'] ?? "Maintain Weight";

    String allergyStr = _answers['allergies'] ?? "";
    if (allergyStr.contains("Others") &&
        _otherAllergyController.text.isNotEmpty) {
      List<String> items = allergyStr.split(', ');
      items.remove("Others");
      items.add(_otherAllergyController.text);
      _answers['allergies'] = items.join(', ');
    }

    final String prepVal = _answers['prep_style'] ?? "";
    if (!prepVal.contains("Batch cooking")) {
      _answers['cooking_day'] = [];
    }

    final finalJson = {
      "data": {
        "answers": {..._answers, "health_goal": userGoal},
      },
    };

    debugPrint("finalJson======$finalJson");
    final bool isSuccess = await ref
        .read(userControllerProvider.notifier)
        .storeUserConfigDetails(finalJson);

    if (isSuccess) {
      Get.offAllNamed('/main-shell', arguments: {'shouldRefreshMeals': true});
    } else {
      Get.snackbar(
        "Error",
        "Failed to save details.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _nextQuestion() {
    String currentId = _questions[_currentIndex]['id'];

    if (currentId == 'target_calorie') {
      String prepVal = _answers['prep_style'] ?? "";
      if (!prepVal.contains("Batch cooking")) {
        _saveUserDetails();
        return;
      }
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _saveUserDetails();
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      String currentId = _questions[_currentIndex]['id'];

      if (currentId == 'cooking_day') {
        String prepVal = _answers['prep_style'] ?? "";
        if (!prepVal.contains("Batch cooking")) {
          setState(() => _currentIndex--);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;
    final selectedValue = _answers[currentQuestion['id']];
    final canProceed = _canProceed(currentQuestion);
    final isLoading = ref.watch(userControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: AppColors.outline,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Step ${_currentIndex + 1} of ${_questions.length}',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SingleChildScrollView(
                  key: ValueKey<int>(_currentIndex),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        currentQuestion['question'],
                        style: GoogleFonts.dmSans(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (currentQuestion['type'] == 'location_picker')
                        Column(
                          children: [
                            _LocationDropdown(
                              label: 'Country',
                              value: _selectedCountry,
                              items: _countries.map((country) => country.name).toList(),
                              enabled: !_isLocationLoading && _countries.isNotEmpty,
                              hint: _isLocationLoading ? 'Loading countries...' : 'Select country',
                              onChanged: (value) => _handleLocationChange(country: value),
                            ),
                            const SizedBox(height: 12),
                            _LocationDropdown(
                              label: 'State',
                              value: _selectedState,
                              items: _states.map((state) => state.name).toList(),
                              enabled: _selectedCountry != null && _states.isNotEmpty,
                              hint: _selectedCountry == null
                                  ? 'Select a country first'
                                  : 'Select state',
                              onChanged: (value) => _handleLocationChange(state: value),
                            ),
                            const SizedBox(height: 12),
                            _LocationDropdown(
                              label: 'City',
                              value: _selectedCity,
                              items: _cities.map((city) => city.name).toList(),
                              enabled: _selectedState != null && _cities.isNotEmpty,
                              hint: _selectedState == null
                                  ? 'Select a state first'
                                  : 'Select city',
                              onChanged: (value) => _handleLocationChange(city: value),
                            ),
                          ],
                        )
                      else
                        ...List.generate(currentQuestion['options'].length, (
                          index,
                        ) {
                          final option = currentQuestion['options'][index];
                          bool isSelected = false;

                          if (currentQuestion['type'] == "mcq_single") {
                            isSelected = selectedValue == option['text'];
                          } else if (currentQuestion['type'].toString().contains(
                            "mcq_multi_csv",
                          )) {
                            isSelected =
                                (selectedValue as String?)
                                    ?.split(', ')
                                    .contains(option['text']) ??
                                false;
                          } else if (currentQuestion['type'] == "mcq_multi") {
                            isSelected =
                                (selectedValue as List?)?.contains(
                                  option['value'],
                                ) ??
                                false;
                          }

                          return Column(
                            children: [
                              _OptionCard(
                                text: option['text'],
                                icon: option['icon'],
                                isSelected: isSelected,
                                onTap: isLoading
                                    ? () {}
                                    : () => _handleSelection(
                                        currentQuestion['id'],
                                        currentQuestion['type'],
                                        option,
                                      ),
                              ),
                              if (option['text'] == "Others" && isSelected)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: TextField(
                                    controller: _otherAllergyController,
                                    decoration: InputDecoration(
                                      hintText: "Enter allergy name",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
            _BottomNav(
              isLoading: isLoading,
              onBack: (_currentIndex == 0 || isLoading)
                  ? null
                  : _previousQuestion,
              onNext: (isLoading || !canProceed) ? null : _nextQuestion,
              isLast:
                  _currentIndex == _questions.length - 1 ||
                  (_questions[_currentIndex]['id'] == 'target_calorie' &&
                      !(_answers['prep_style'] ?? "").contains(
                        "Batch cooking",
                      )),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final bool enabled;
  final String hint;
  final ValueChanged<String?> onChanged;

  const _LocationDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.enabled,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineStrong),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value != null && items.contains(value) ? value : null,
          hint: Text(hint),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryContainer : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.outlineStrong,
              width: isSelected ? 2 : 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColors.primaryDark
                    : AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primaryDark
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final bool isLast;
  final bool isLoading;

  const _BottomNav({
    this.onBack,
    this.onNext,
    required this.isLast,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.outline, width: 1)),
      ),
      child: Row(
        children: [
          if (onBack != null)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: AppColors.outlineStrong),
                ),
                child: Text(
                  'Back',
                  style: GoogleFonts.dmSans(color: AppColors.textPrimary),
                ),
              ),
            ),
          if (onBack != null) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      isLast ? 'Generate Plan' : 'Next',
                      style: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
