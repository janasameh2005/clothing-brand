import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..fetchProfile(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5EFD2),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.brown));
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            } else if (state is ProfileSuccess) {
              final user = state.profileData.userInfo;
              final sections = state.profileData.menuSections;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    _buildHeader(state.profileData.headerBar.title),
                    const SizedBox(height: 20),
                    _buildUserInfoCard(user),
                    const SizedBox(height: 25),
                    // عرض الأقسام بشكل ديناميكي
                    ...sections.map((section) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: _buildListContainer(
                        context,
                        section.items.map((item) => _buildOption(item.label)).toList(),
                      ),
                    )),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  // --- Widgets مساعدة عشان الكود يكون نضيف ---

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500, fontFamily: 'Serif'),
    );
  }

  Widget _buildUserInfoCard(var user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(user.profilePicture),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(user.email, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(user.updatePhotoText, style: const TextStyle(color: Colors.black, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListContainer(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildOption(String title) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.keyboard_arrow_down),
      onTap: () {},
    );
  }
}