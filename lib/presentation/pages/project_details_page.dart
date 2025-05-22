// filepath: /Users/Hunter/Documents/cloud/work/hillinsight/code/kiwi/lib/presentation/pages/project_details_page.dart
import 'package:flutter/material.dart';
import 'package:kiwi/core/utils/logger.dart';

class ProjectDetailsPage extends StatelessWidget {
  final String projectId;

  const ProjectDetailsPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    AppLogger.info(
      "Navigated to ProjectDetailsPage for project ID: $projectId",
    );
    return Scaffold(
      appBar: AppBar(title: Text('项目详情 - $projectId')),
      body: Center(child: Text('项目 ID: $projectId 的详细信息')),
    );
  }
}
