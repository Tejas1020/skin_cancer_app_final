// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class AuthWidget extends ConsumerWidget {
//   final WidgetBuilder nonSignedInBuilder;
//   final WidgetBuilder signedInBuilder;
//   const AuthWidget({
//     Key? key,
//     required this.nonSignedInBuilder,
//     required this.signedInBuilder,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authStatechanges = ref.watch(authStateChangesProvider);
//     return authStatechanges.when(
//       data: (user) {
//         print("Hallo Page changed");
//         return user != null
//             ? signedInBuilder(context)
//             : nonSignedInBuilder(context);
//       },
//       loading: () => Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       ),
//       error: (_, __) => const Scaffold(
//         body: Center(
//           child: Text("Something Went Wrong!"),
//         ),
//       ),
//     );
//   }
// }
