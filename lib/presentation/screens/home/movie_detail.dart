import 'package:flutter/material.dart';
import 'package:netflix_clone/core/constants/app_constant.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/movie_model.dart';

class MovieDetailScreen extends StatelessWidget {
final MovieModel movie;

const MovieDetailScreen({
super.key,
required this.movie,
});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: AppColors.background,
body: CustomScrollView(
slivers: [
SliverAppBar(
expandedHeight: 420,
pinned: true,
backgroundColor: AppColors.background,
leading: IconButton(
icon: const Icon(Icons.arrow_back),
onPressed: () => Navigator.of(context).pop(),
),
flexibleSpace: FlexibleSpaceBar(
background: Stack(
fit: StackFit.expand,
children: [
Image.network(
movie.posterUrl,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) {
return Container(
color: AppColors.surface,
child: const Icon(
Icons.movie_outlined,
size: 100,
color: Colors.white54,
),
);
},
),
const DecoratedBox(
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topCenter,
end: Alignment.bottomCenter,
colors: [
Colors.transparent,
AppColors.background,
],
stops: [0.45, 1.0],
),
),
),
],
),
),
),
SliverToBoxAdapter(
child: Padding(
padding: const EdgeInsets.all(AppConstants.defaultPadding),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
movie.title,
style: const TextStyle(
color: Colors.white,
fontSize: 28,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 12),
Row(
children: [
const Icon(
Icons.star,
color: Colors.amber,
size: 20,
),
const SizedBox(width: 5),
Text(
'${movie.rating} / 10',
style: const TextStyle(
color: Colors.white,
fontSize: 15,
),
),
const SizedBox(width: 12),
Container(
padding: const EdgeInsets.symmetric(
horizontal: 8,
vertical: 4,
),
decoration: BoxDecoration(
border: Border.all(color: Colors.white54),
borderRadius: BorderRadius.circular(4),
),
child: const Text(
'HD',
style: TextStyle(
color: Colors.white,
fontSize: 12,
),
),
),
],
),
const SizedBox(height: 24),
SizedBox(
width: double.infinity,
child: ElevatedButton.icon(
onPressed: () {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'Video playback will be added later.',
),
),
);
},
icon: const Icon(Icons.play_arrow),
label: const Text('Play'),
style: ElevatedButton.styleFrom(
backgroundColor: Colors.white,
foregroundColor: Colors.black,
padding: const EdgeInsets.symmetric(vertical: 14),
textStyle: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
),
),
const SizedBox(height: 12),
SizedBox(
width: double.infinity,
child: OutlinedButton.icon(
onPressed: () {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text(
'My List functionality will be added later.',
),
),
);
},
icon: const Icon(Icons.add),
label: const Text('My List'),
style: OutlinedButton.styleFrom(
foregroundColor: Colors.white,
padding: const EdgeInsets.symmetric(vertical: 14),
side: const BorderSide(color: Colors.white54),
),
),
),
const SizedBox(height: 24),
const Text(
'Overview',
style: TextStyle(
color: Colors.white,
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 10),
Text(
movie.description,
style: const TextStyle(
color: AppColors.textSecondary,
fontSize: 15,
height: 1.6,
),
),
const SizedBox(height: 24),
_buildInfoRow('Category', movie.category),
const SizedBox(height: 12),
_buildInfoRow('Rating', '${movie.rating} / 10'),
const SizedBox(height: 32),
],
),
),
),
],
),
);
}

Widget _buildInfoRow(String label, String value) {
return Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
SizedBox(
width: 90,
child: Text(
label,
style: const TextStyle(
color: AppColors.textSecondary,
fontSize: 14,
),
),
),
Expanded(
child: Text(
value,
style: const TextStyle(
color: Colors.white,
fontSize: 14,
),
),
),
],
);
}
}
