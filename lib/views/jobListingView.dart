import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_service_app/dataClasses/jobData.dart';
import 'package:home_service_app/views/jobDetailsView.dart';
import 'package:home_service_app/views/widgets/footer_Widget.dart';
import 'package:home_service_app/views/widgets/navBar.dart';
import 'package:home_service_app/views/widgets/pageTitle_Widget.dart';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:google_maps/google_maps.dart' as gm;

import '../dataClasses/User.dart';

class jobListingView extends StatefulWidget {
  final User user;
  const jobListingView({Key? key, required this.user}) : super(key: key);

  @override
  State<jobListingView> createState() => _jobListingViewState();
}

class _jobListingViewState extends State<jobListingView> {
  List<JobData> allJobs = [];
  List<String> job_Types = [
    'All Jobs',
    'Yark Work',
    'Cleaning',
    'Landscaping',
    'Painting',
    'Maintainace',
    'Plumbing',
    'Misc'
  ];
  List<String> job_Distance = ['Closest', 'Farthest'];
  List<String> job_Prices = ['Low - High', 'High - Low'];
  String? selected_Type = 'All Jobs';
  String? selected_Distance = 'Closest';
  String? selected_Price = 'Low - High';
  int total_jobs = 0;
  bool loaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(229, 229, 229, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopBar(user: widget.user),
            PageTitle('Job Listings'),
            searchBar(),
            Row(
              children: [jobListingMapView(), jobList()],
            ),
            Footer(),
          ],
        ),
      ),
    );
  }

  searchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 250, right: 250),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search Job...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            ),
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: DropdownButtonHideUnderline(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30)),
                    child: DropdownButton<String>(
                        focusColor: Colors.transparent,
                        value: selected_Type,
                        items: job_Types
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(item),
                                )))
                            .toList(),
                        onChanged: (item) => setState(() {
                              selected_Type = item;
                            })),
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: DropdownButtonHideUnderline(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30)),
                    child: DropdownButton<String>(
                        focusColor: Colors.transparent,
                        value: selected_Distance,
                        items: job_Distance
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(item),
                                )))
                            .toList(),
                        onChanged: (item) => setState(() {
                              selected_Distance = item;
                            })),
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: DropdownButtonHideUnderline(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30)),
                    child: DropdownButton<String>(
                        focusColor: Colors.transparent,
                        value: selected_Price,
                        items: job_Prices
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(item),
                                )))
                            .toList(),
                        onChanged: (item) => setState(() {
                              selected_Price = item;
                            })),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  jobListingMapView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(250, 10, 50, 10),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 3),
            borderRadius: BorderRadius.circular(15)),
        height: 600,
        width: 600,
        child: Row(
          children: [
            Expanded(
              child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(7.0, 8.0))
                  ]),
                  child: loaded == true
                      ? googleMaps()
                      : Center(
                          child: CircularProgressIndicator(),
                        )),
            )
          ],
        ),
      ),
    );
  }

  jobList() {
    return Container(
        height: 600,
        width: 600,
        child: total_jobs >= 1
            ? ListView.builder(
              
                shrinkWrap: true,
                itemCount: total_jobs,
                itemBuilder: (context, index) {
                  if (allJobs[index] == null) {
                    
                    index++;
                  }
                  return jobTile(allJobs[index],index);
                })
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  googleMaps() {
    String htmlId = widget.user.user_ID + allJobs.length.toString();

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      //final myLatlng = gm.LatLng(10.640821, -61.398547);

      final mapOptions = gm.MapOptions()
        ..zoom = 9
        ..zoomControl = false
        ..disableDoubleClickZoom = true
        ..scrollwheel = false
        ..center = gm.LatLng(10.640821, -61.398547);

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none'
        ..style.borderRadius = '13px';

      final map = gm.GMap(elem, mapOptions);
      // gm.Marker(gm.MarkerOptions()
      //   ..position = myLatlng
      //   ..map = map
      //   ..title = 'Active Job Location');
      for (int i = 0; i < allJobs.length; i++) {
        gm.Marker(gm.MarkerOptions()
          ..position = gm.LatLng(allJobs[i].Latitude, allJobs[i].Longitude)
          ..map = map
          ..icon =
              'https://firebasestorage.googleapis.com/v0/b/homeserviceapp-a9232.appspot.com/o/map-icon.png?alt=media&token=86092967-270e-487d-8e37-eea7a5741f49'
          ..title = allJobs[i].jobName);
      }
      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }

  Widget jobTile(JobData job, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        key: Key("jobListing"+index.toString()),
        borderRadius: BorderRadius.all(Radius.circular(30)),
        hoverColor: Color.fromRGBO(195, 166, 96, 0.25),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => jobDetailsView(
                        user: widget.user,
                        job: job,
                      )));
        },
        child: Container(
          height: 150,
          width: 350,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(7.0, 8.0))
              ]),
          child: Row(
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    job.ActiveJobImages[0],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.jobName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        job.jobDescription,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16, overflow: TextOverflow.ellipsis),
                      ),
                      Row(
                        children: [
                          Text(
                            job.jobLocation,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.pin_drop,
                            color: Colors.red,
                          )
                        ],
                      ),
                      Text(
                        '\$ ' + job.jobPrice,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getJobs() async {
    List<String> ids = widget.user.activeJobs;
    var docJob;
    var snapshot;
    JobData job;
    List<JobData> jobs = [];
    final value = await FirebaseFirestore.instance
        .collection("jobs")
        .where('isCompleted', isEqualTo: false)
        .get();
    for (var doc in value.docs) {
      //print(doc.data());
      job = JobData.fromJson(doc.data());
      if (!job.isAccepted || !job.isCompleted) {
        jobs.add(job);
      }
    }
    setState(() {
      allJobs.clear();
      allJobs.addAll(jobs);
      total_jobs = allJobs.length;
      print(total_jobs);
      loaded = true;
    });
  }

  Future<void> LoadData() async {
    await getJobs();
  }
}
