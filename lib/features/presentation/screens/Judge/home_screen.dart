import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:judge_assist_app/features/presentation/screens/Judge/event_screen.dart';
import 'package:judge_assist_app/features/presentation/widgets/event_card.dart';
import 'package:judge_assist_app/features/presentation/providers/event_provider.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/Event.dart';
import '../../../domain/entities/Team.dart';
class JudgeEventScreen extends StatelessWidget {
  final int judgeId;
  const JudgeEventScreen({super.key, required this.judgeId});

  @override
  Widget build(BuildContext context) {
    var eventListModel = Provider.of<EventListModel>(context, listen: true);
    Future<void> refreshEvents() async {
      await eventListModel.refresh(); // Call the method to fetch events again
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: RefreshIndicator(
          onRefresh:() => refreshEvents(),
          child: FutureBuilder<List<Event>>(
            future: eventListModel.getAllEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                String errorMessage = '';
                if (snapshot.error is Exception) {
                  final error = snapshot.error as Exception;
                  if (error is DioException) {
                    if (error.response?.statusCode == 400) {
                      errorMessage = 'Wrong input';
                    } else if (error.response?.statusCode == 502) {
                      errorMessage = 'Server down';
                    } else {
                      print(error.response?.statusCode);
                      errorMessage = 'Unknown error';
                    }
                  } else {
                    // print(error.response?.statusCode);
                    errorMessage = 'Unknown error';
                  }
                } else {
                  // print(snapshot.error.response?.statusCode);
                  errorMessage = 'No Team Judged Yet in this event';
                }
                return Center(
                  child: Text(
                    'Failed To Load Data : $errorMessage',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              } else {
                final eventList = snapshot.data!;
                return ListView.builder(
                  itemCount: eventList.length,
                  itemBuilder: (context, index) {
                    final event = eventList[index];
                    return EventCard(
                      event: event,
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventScreen(
                              event: event,
                              teams: event.teams, judgeId: judgeId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}



// class JudgeEventScreen extends StatelessWidget {
//   final int judgeId;
//   const JudgeEventScreen({super.key, required this.judgeId});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Event> eventList = Provider.of<EventListModel>(context).events;
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Events',
//             style: TextStyle(color: Colors.white),
//           ),
//           centerTitle: true,
//         ),
//         body: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: Consumer<EventListModel>(
//             builder: (context, eventListModel, _) => ListView.builder(
//               itemCount: eventList.length,
//               itemBuilder: (context, index) {
//                 Event event = eventList[index];
//                 return EventCard(
//                   event: event,
//                   onTap: () async {
//                     List<Team> teamList = await Provider.of<EventListModel>(context, listen: false).getTeams(event.teams);
//                     if(context.mounted) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               EventScreen(
//                                 event: event,
//                                 teams: teamList,
//                                 judgeId:judgeId
//                               ),
//                         ),
//                       );
//                     }
//                   },
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
