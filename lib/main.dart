import 'package:chessarena/constants/colors.dart';
import 'package:chessarena/constants/routes.dart';
import 'package:chessarena/views/chess_board/board_view.dart';
import 'package:chessarena/views/login_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chess Arena',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: appBarColor,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 22,
          ),
        ),
      ),
      home: const LoginView(),
      routes: {
        loginRoute: (context) => const LoginView(),
        boardRoute: (context) => const BoardView(),
      },
    ),
  );
}
