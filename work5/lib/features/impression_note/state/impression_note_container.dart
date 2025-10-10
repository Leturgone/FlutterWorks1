import 'package:flutter/material.dart';
import 'package:work5/features/comic_series/models/comic_series.dart';
import 'package:work5/features/comic_series/screens/comic_series_list_screen.dart';
import 'package:work5/features/impression_note/models/impression_note.dart';
import 'package:work5/features/impression_note/screens/impression_note_form_screen.dart';
import 'package:work5/features/shared_data.dart';

import '../screens/impression_note_about_screen.dart';
import '../screens/impression_note_list_screen.dart';


enum Screen { list, about, form, edit, chooseList, afterChoose, sortedOldToNew, sortedNewToOld}

class ImpressionNoteContainer extends StatefulWidget {
  const ImpressionNoteContainer({super.key});

  @override
  State<ImpressionNoteContainer> createState() => _ImpressionNoteContainerState();
}

class _ImpressionNoteContainerState extends State<ImpressionNoteContainer> {
  List<ImpressionNote> impressionNoteList =[
    ImpressionNote(id: 1,
        seriesImage: "https://i.annihil.us/u/prod/marvel/i/mg/1/d0/519bad24bebcd.jpg",
        description: "Запись")
  ];

  ImpressionNote? _selectedImpressionNote;
  String? _selectedSeries;
  Screen _currentScreen = Screen.list;


  void _showListScreen() {
    setState(() {
      _currentScreen = Screen.list;
    });
  }

  void _showEditScreen(ImpressionNote impressionNote){
    setState(() {
      _selectedImpressionNote = impressionNote;
      _currentScreen = Screen.edit;
    });
  }

  void _showFormScreen() {
    setState(() {
      _currentScreen = Screen.form;
    });
  }
  void _sortByTimeOldToNew(){
    setState(() {
      impressionNoteList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      _currentScreen = Screen.sortedOldToNew;
    });
  }

  void _sortByTimeNewToOld(){
    setState(() {
      impressionNoteList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _currentScreen = Screen.sortedNewToOld;
    });
}

  void _showAboutScreen(ImpressionNote impressionNote) {
    setState(() {
      _selectedImpressionNote = impressionNote;
      _currentScreen = Screen.about;
    });
  }

  void _deleteImpressionNote(int id){
    setState(() {
      impressionNoteList.removeWhere((n) => n.id == id);
    });
  }

  void _addImpressionNote(String description, String image) {
    setState(() {
      final id = impressionNoteList.lastOrNull != null ? impressionNoteList.lastOrNull!.id+1 : 1;
      final newImpressionNote = ImpressionNote(
          id: id,
          seriesImage: image,
          description: description,
          createdAt: DateTime.now()
      );
      impressionNoteList.add(newImpressionNote);
      _currentScreen = Screen.list;
    });
  }

  void _editImpressionNote(String newDescription, String newImage) {
    setState(() {
      if(_selectedImpressionNote != null){
        final oldImpressionNote = _selectedImpressionNote!;
        final index = impressionNoteList.indexWhere((n) => n.id == oldImpressionNote.id);
        if (index != -1) {
          impressionNoteList[index] = ImpressionNote(
              id: oldImpressionNote.id,
              description: newDescription,
              seriesImage: newImage,
              createdAt: DateTime.now()
          );
          _currentScreen = Screen.list;
        }
      }
    });
  }

  void _chooseSeriesForNote(ComicSeries series){
    setState(() {
      _selectedSeries = series.image;
      _currentScreen = Screen.afterChoose;
    });
  }

  void _showSeriesListForChoose(){
    setState(() {
      _currentScreen = Screen.chooseList;
    });
  }


  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case Screen.list:
        return ImpressionNoteListScreen(
          impressionNotes: impressionNoteList,
          onAdd: _showFormScreen,
          onDelete: _deleteImpressionNote,
          onNoteTap:  _showAboutScreen,
          onEdit: _showEditScreen,
          onSort: _sortByTimeNewToOld
        );
      case Screen.about:
        if (_selectedImpressionNote == null){
          return Container();
        }else{
          return ImpressionNoteAboutScreen(
            impressionNote: _selectedImpressionNote!,
            onBack: _showListScreen,
          );
        }
      case Screen.form:
        return ImpressionNoteFormScreen(
            onSave:  _addImpressionNote,
            onCancel: _showListScreen,
            onSelect: _showSeriesListForChoose);
      case Screen.edit:
        return ImpressionNoteFormScreen(
            impressionNote: _selectedImpressionNote,
            onSave: _editImpressionNote,
            onCancel: _showListScreen,
            onSelect: _showSeriesListForChoose);

      case Screen.chooseList:
        return ComicSeriesListScreen(
            seriesList: SharedData.seriesList,
            onSeriesTap: _chooseSeriesForNote);
      case Screen.afterChoose:
        return ImpressionNoteFormScreen(
            selectedCover: _selectedSeries,
            onSave: _addImpressionNote,
            onCancel: _showListScreen,
            onSelect: _showSeriesListForChoose);
      case Screen.sortedOldToNew:
        return ImpressionNoteListScreen(
          impressionNotes: impressionNoteList,
          onAdd: _showFormScreen,
          onDelete: _deleteImpressionNote,
          onNoteTap:  _showAboutScreen,
          onEdit: _showEditScreen,
          onSort: _sortByTimeNewToOld,
        );
      case Screen.sortedNewToOld:
        return ImpressionNoteListScreen(
          impressionNotes: impressionNoteList,
          onAdd: _showFormScreen,
          onDelete: _deleteImpressionNote,
          onNoteTap:  _showAboutScreen,
          onEdit: _showEditScreen,
          onSort: _sortByTimeOldToNew,
        );
    }
  }
}
