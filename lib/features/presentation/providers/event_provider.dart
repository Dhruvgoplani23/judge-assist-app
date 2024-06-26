import 'package:flutter/material.dart';
import 'package:judge_assist_app/features/data/datasource/api_service.dart';
import 'package:judge_assist_app/features/data/models/TeamDetails.dart';
import 'package:judge_assist_app/features/data/models/TeamModel.dart';
import 'package:judge_assist_app/features/data/models/TeamScore.dart';
import 'package:judge_assist_app/features/domain/entities/Event.dart';
import 'package:judge_assist_app/features/domain/entities/Team.dart';

import '../../data/models/EventModel.dart';
import '../../data/models/Judge.dart';

class EventListModel extends ChangeNotifier{

  final ApiService apiService;

  List<Event> _events = [];

  EventListModel({required this.apiService}){
    print("EventListModel");
  }


  // EventListModel(this.apiService){
  //   // List<Event> eventList = [];
  //
  //   // Event e1 = Event(1, "Credenz", ["Presentation", "Code", "Team Performance", "Functionality"], []);
  //   // Event e2 = Event(2, "Pradnya", ["Code Quality", "Efficiency", "Team Performance", "Correctness"], []);
  //   // Event e3 = Event(3, "Xenia", ["Presentation", "Code", "Team Performance"], []);
  //   // Event e4 = Event(4, "INC", ["Presentation", "Innovation", "Team Performance", "Impact"], []);
  //   // eventList.add(e1);
  //   // eventList.add(e2);
  //   // eventList.add(e3);
  //   // eventList.add(e4);
  //   // _events = eventList;
  // }


  List<Event> get events => _events;

  void refreshList(){
    notifyListeners();
  }

  Future<List<Event>> getEvents() async{
    final eventModels = await apiService.getEvents();
    _events = eventModels.map((model)=>model.toEntity()).toList();
    refreshList();
    return _events;
  }

  void addEvent(Event event) async{
    EventModel eventModel = EventModel.fromEntity(event);
    await apiService.addEvent(eventModel);
    refreshList();
  }

  Future<List<Team>> getTeams(List<int> teamIds) async{
    List<Team> teamList = [];
    for(int i = 0; i < teamIds.length; i++){
      int id = teamIds[i];
      TeamModel teamModel = await apiService.getTeam(id);
      Team team = teamModel.toEntity();
      teamList.add(team);
    }
    return teamList;
  }

  Future<Team> addTeam1(Team team) async {
    TeamModel teamModel = TeamModel.fromEntity(team);
    int id = await apiService.addTeam1(teamModel);
    team.id = id;
    refreshList();
    return team;

  }

  Future<Team> addTeam(Team team, TeamScore teamScore) async {
    TeamModel teamModel = TeamModel.fromEntity(team);
    int id = await apiService.addTeam(teamModel, teamScore);
    team.id = id;
    refreshList();
    return team;

  }

  Future<Judge> addJudge(Judge judge) async{
    Judge addedJudge = await apiService.addJudge(judge);
    return addedJudge;
  }

  void clearEvents(){
    _events.clear();
    refreshList();
  }
  Future<bool> loginJudge(String email, String password) async{
    Judge judge = Judge.login(email, password);
    bool check = await apiService.loginJudge(judge);
    return check;
  }

  Future<TeamDetails> getTeamScore(int teamId) async{
    TeamDetails teamDetails = await apiService.getTeamScores(teamId);
    return teamDetails;
  }

  // void getJudgeEvents(int judgeId) async {
  //   EventModel eventModel = await apiService.getJudgeEvents(judgeId);
  //   _events.add(eventModel.toEntity());
  //   refreshList();
  // }

  void updateTeam(Event event, Team team){

  }

  void createEvent(Event event){

  }

  void addScore(TeamScore teamScore){
    apiService.addTeamScore(teamScore);
    refreshList();
  }


}


