import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/company.dart';
import '../models/master/application.dart';
import '../models/master/pole.dart';
import '../models/master/voltage.dart';
import '../models/master/frequency.dart';
import 'api_service.dart';

class MasterService {
  final Dio _dio = ApiService().dio;

  Future<List<Company>> getCompanies() async {
    try {
      final response = await _dio.get('/master/companies');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => Company.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching companies: $e');
      throw Exception('Failed to load companies');
    }
  }

  Future<List<MasterApplication>> getApplications() async {
    try {
      final response = await _dio.get('/master/applications');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => MasterApplication.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching applications: $e');
      throw Exception('Failed to load applications');
    }
  }

  Future<List<MasterPole>> getPoles() async {
    try {
      final response = await _dio.get('/master/poles');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => MasterPole.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching poles: $e');
      throw Exception('Failed to load poles');
    }
  }

  Future<List<MasterVoltage>> getVoltages() async {
    try {
      final response = await _dio.get('/master/voltages');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => MasterVoltage.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching voltages: $e');
      throw Exception('Failed to load voltages');
    }
  }

  Future<List<MasterFrequency>> getFrequencies() async {
    try {
      final response = await _dio.get('/master/frequencies');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => MasterFrequency.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching frequencies: $e');
      throw Exception('Failed to load frequencies');
    }
  }
}
