import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../services/master_service.dart';
import '../../models/master/application.dart';
import '../../models/master/pole.dart';
import '../../models/master/voltage.dart';
import '../../models/master/frequency.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';

class DriveSelectionScreen extends StatefulWidget {
  const DriveSelectionScreen({super.key});

  @override
  State<DriveSelectionScreen> createState() => _DriveSelectionScreenState();
}

class _DriveSelectionScreenState extends State<DriveSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        drawer: const AppDrawer(),
        appBar: const CustomAppBar(
          title: 'Drive Selection Tools',
          bottom: TabBar(
            labelColor: AppTheme.primaryBlue,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primaryBlue,
            tabs: [
              Tab(text: 'AC Drive'),
              Tab(text: 'DC Drive'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ACDriveForm(),
            _DCDriveForm(),
          ],
        ),
      ),
    );
  }
}

class _ACDriveForm extends StatefulWidget {
  const _ACDriveForm();

  @override
  State<_ACDriveForm> createState() => _ACDriveFormState();
}

class _ACDriveFormState extends State<_ACDriveForm> {
  final _kwController = TextEditingController();
  final _noOfMotorsController = TextEditingController();

  final MasterService _masterService = MasterService();

  List<MasterApplication> _applications = [];
  List<MasterFrequency> _frequencies = [];
  List<MasterVoltage> _voltages = [];
  List<MasterPole> _poles = [];

  String? _selectedApplicationId;
  String? _selectedFrequencyId;
  String? _selectedVoltageId;
  String? _selectedPoleId;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMasterData();
  }

  Future<void> _loadMasterData() async {
    try {
      final futures = await Future.wait([
        _masterService.getApplications(),
        _masterService.getFrequencies(),
        _masterService.getVoltages(),
        _masterService.getPoles(),
      ]);

      setState(() {
        _applications = futures[0] as List<MasterApplication>;
        _frequencies = futures[1] as List<MasterFrequency>;
        _voltages = futures[2] as List<MasterVoltage>;
        _poles = futures[3] as List<MasterPole>;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading AC Master Data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _kwController,
            decoration: const InputDecoration(labelText: 'KW', hintText: 'Enter KW'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          DropdownMenu<String>(
            expandedInsets: EdgeInsets.zero,
            label: const Text('No. Pole'),
            initialSelection: _selectedPoleId,
            dropdownMenuEntries: _poles.map((e) => DropdownMenuEntry(value: e.id, label: e.poleNumber)).toList(),
            onSelected: (val) => setState(() => _selectedPoleId = val),
          ),
          const SizedBox(height: 16),
          DropdownMenu<String>(
            expandedInsets: EdgeInsets.zero,
            label: const Text('Voltage'),
            initialSelection: _selectedVoltageId,
            dropdownMenuEntries: _voltages.map((e) => DropdownMenuEntry(value: e.id, label: '${e.voltageValue} ${e.unit}')).toList(),
            onSelected: (val) => setState(() => _selectedVoltageId = val),
          ),
          const SizedBox(height: 16),
          DropdownMenu<String>(
            expandedInsets: EdgeInsets.zero,
            label: const Text('Frequency'),
            initialSelection: _selectedFrequencyId,
            dropdownMenuEntries: _frequencies.map((e) => DropdownMenuEntry(value: e.id, label: '${e.frequencyValue} ${e.unit}')).toList(),
            onSelected: (val) => setState(() => _selectedFrequencyId = val),
          ),
          const SizedBox(height: 16),
          DropdownMenu<String>(
            expandedInsets: EdgeInsets.zero,
            label: const Text('Application'),
            initialSelection: _selectedApplicationId,
            dropdownMenuEntries: _applications.map((e) => DropdownMenuEntry(value: e.id, label: e.name)).toList(),
            onSelected: (val) => setState(() => _selectedApplicationId = val),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noOfMotorsController,
            decoration: const InputDecoration(labelText: 'No of Motors', hintText: 'Enter Number of Motors'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Submit action for AC Drive Selection
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class _DCDriveForm extends StatefulWidget {
  const _DCDriveForm();

  @override
  State<_DCDriveForm> createState() => _DCDriveFormState();
}

class _DCDriveFormState extends State<_DCDriveForm> {
  final _kwController = TextEditingController();
  final _fieldCurrentController = TextEditingController();
  final _fieldVoltageController = TextEditingController();
  final _armVoltageController = TextEditingController();

  final MasterService _masterService = MasterService();
  List<MasterApplication> _applications = [];
  String? _selectedApplicationId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    try {
      final apps = await _masterService.getApplications();
      setState(() {
        _applications = apps;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading DC Master Data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _armVoltageController,
            decoration: const InputDecoration(labelText: 'Arm voltage (V)', hintText: 'Enter Arm Voltage'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _kwController,
            decoration: const InputDecoration(labelText: 'KW', hintText: 'Enter KW'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _fieldVoltageController,
            decoration: const InputDecoration(labelText: 'Field voltage (V)', hintText: 'Enter Field Voltage'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _fieldCurrentController,
            decoration: const InputDecoration(labelText: 'Field Current (A)', hintText: 'Enter Field Current'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          DropdownMenu<String>(
            expandedInsets: EdgeInsets.zero,
            label: const Text('Application'),
            initialSelection: _selectedApplicationId,
            dropdownMenuEntries: _applications.map((e) => DropdownMenuEntry(value: e.id, label: e.name)).toList(),
            onSelected: (val) => setState(() => _selectedApplicationId = val),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Submit action for DC Drive Selection
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}


