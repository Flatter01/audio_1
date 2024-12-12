// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;

// void main() {
//   runApp(MaterialApp(home: DocumentEditorPage()));
// }

// class DocumentEditorPage extends StatefulWidget {
//   @override
//   _DocumentEditorPageState createState() => _DocumentEditorPageState();
// }

// class _DocumentEditorPageState extends State<DocumentEditorPage> {
//   late quill.QuillController _mainController;
//   late quill.QuillController _readOnlyController;

//   @override
//   void initState() {
//     super.initState();
//     // Создаем общий документ
//     final document = quill.Document()..insert(0, 'Hello, this is a Quill Editor example.');
//     _mainController = quill.QuillController(
//       document: document,
//       selection: const TextSelection.collapsed(offset: 0),
//     );
//     _readOnlyController = quill.QuillController(
//       document: document,
//       selection: const TextSelection.collapsed(offset: 0),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Quill Editor Example')),
//       body: Column(
//         children: [
//           // Основной редактор (редактируемый)
//           Expanded(
//             flex: 3,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
//                 child: quill.QuillEditor.basic(
//                   controller: _mainController,
//                   readOnly: false, // Режим редактирования
//                 ),
//               ),
//             ),
//           ),
//           // Простой просмотр (только для чтения)
//           Expanded(
//             flex: 1,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
//                 child: quill.QuillEditor.basic(
//                   controller: _readOnlyController,
//                   readOnly: true, // Режим только для чтения
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _mainController.dispose();
//     _readOnlyController.dispose();
//     super.dispose();
//   }
// }
