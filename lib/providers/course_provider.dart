import 'package:flutter/foundation.dart';
import '../models/course_model.dart';

/// In-memory course data (no API). Can be moved to local JSON or assets later.
class CourseProvider extends ChangeNotifier {
  static final CourseProvider _instance = CourseProvider._();
  factory CourseProvider() => _instance;

  CourseProvider._();

  List<CourseModel> _courses = [];
  List<CourseModel> get courses => List.unmodifiable(_courses);

  void loadCourses() {
    if (_courses.isNotEmpty) return;
    _courses = _defaultCourses;
    notifyListeners();
  }

  CourseModel? getCourseById(String id) {
    try {
      return _courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<CourseModel> get _defaultCourses => [
        // 1. Flutter
        CourseModel(
          id: 'flutter',
          title: 'Flutter Basics',
          description: 'Learn Flutter fundamentals and build basic mobile UIs.',
          creditCost: 60,
          lessons: [
            LessonModel(
              id: 'fl_1',
              title: 'Getting Started with Flutter',
              content: '''
Page 1 – What is Flutter?
Flutter is Google\'s UI toolkit for building natively compiled applications for mobile, web and desktop from a single codebase.
It uses the Dart language and gives you a rich set of pre‑built widgets.

Page 2 – Why Flutter?
• Single codebase for Android, iOS, web and desktop
• Hot reload for very fast UI iteration
• Uses a reactive UI model similar to React
• High‑performance rendering engine (Skia)

Page 3 – Flutter Project Structure
• lib/ – your Dart source code
• pubspec.yaml – app metadata and dependencies
• android/, ios/ – platform specific projects
• assets/ – fonts, images and other static files
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'fl_2',
              title: 'Widgets and Layout',
              content: '''
Page 1 – Everything is a Widget
In Flutter, almost everything is a widget: text, buttons, padding, rows, columns and even the entire screen.
Widgets describe what the UI should look like given the current configuration and state.

Page 2 – StatelessWidget vs StatefulWidget
• StatelessWidget – immutable, build method depends only on configuration
• StatefulWidget – has mutable State object; can call setState() to rebuild
• Use StatefulWidget when the UI needs to update over time (input, animations etc.)

Page 3 – Common Layout Widgets
• Row / Column – arrange children horizontally or vertically
• Stack – overlap children on top of each other
• ListView – scrollable list
• Container / Padding / Center – basic layout building blocks
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'fl_3',
              title: 'State Management and Navigation',
              content: '''
Page 1 – Basic State Management
• Local state with StatefulWidget and setState()
• Lifting state up to parent widgets
• Using Provider or other packages for shared app‑wide state

Page 2 – Navigation Basics
• Navigator.push / pop – imperative navigation
• Named routes – easier to manage many screens
• Packages like go_router help define declarative navigation tables

Page 3 – Best Practices
• Keep widgets small and focused
• Separate UI code from business logic
• Avoid doing heavy work in the build() method
''',
              testQuestions: [
                TestQuestionModel(
                  question: 'Which language is used to write Flutter apps?',
                  options: ['Java', 'Kotlin', 'Dart', 'Swift'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which widget should you use when the UI must change over time?',
                  options: ['StatelessWidget', 'StatefulWidget', 'Container', 'Scaffold'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'What does hot reload provide?',
                  options: [
                    'Faster APK size',
                    'Automatic performance profiling',
                    'Quick UI updates without losing state in many cases',
                    'Offline storage'
                  ],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which widget is commonly used as the basic visual layout structure for a page?',
                  options: ['Scaffold', 'Container', 'Text', 'ListView'],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'Which package is often used for simple app‑wide state management in Flutter?',
                  options: ['provider', 'http', 'path', 'camera'],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'Which navigation method replaces the current route with a new one?',
                  options: ['Navigator.pop', 'Navigator.push', 'Navigator.pushReplacement', 'Navigator.maybePop'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which widget helps you listen to changes from a Provider?',
                  options: ['Consumer', 'Column', 'Align', 'AspectRatio'],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'Which file in a Flutter project defines app dependencies?',
                  options: ['main.dart', 'pubspec.yaml', 'AndroidManifest.xml', 'Info.plist'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which widget is best for long, scrollable vertical content?',
                  options: ['Row', 'Column', 'ListView', 'Stack'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which function is called to rebuild a StatefulWidget when state changes?',
                  options: ['rebuild()', 'notify()', 'setState()', 'refresh()'],
                  correctIndex: 2,
                ),
              ],
            ),
          ],
        ),
        // 2. Excel
        CourseModel(
          id: 'excel',
          title: 'Excel Essentials',
          description: 'Master core Excel skills for data entry, formulas and analysis.',
          creditCost: 50,
          lessons: [
            LessonModel(
              id: 'ex_1',
              title: 'Excel Interface and Basics',
              content: '''
Page 1 – Workbook and Worksheets
• A workbook is an Excel file; it contains one or more worksheets (tabs)
• Each worksheet is made of rows, columns and cells (like a grid)

Page 2 – Cells, Rows and Columns
• Columns are labeled with letters (A, B, C…), rows with numbers (1, 2, 3…)
• A single cell is referenced as ColumnRow, for example A1 or C5
• Basic data types: text, numbers, dates, percentages

Page 3 – Basic Operations
• Entering and editing data in cells
• Using AutoFill to quickly copy patterns or series
• Formatting cells (font, color, borders, number formats)
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'ex_2',
              title: 'Formulas and Functions',
              content: '''
Page 1 – Formulas
• Every formula starts with = (equals sign)
• You can reference cells like =A1 + B1
• Use parentheses to control order of operations

Page 2 – Common Functions
• SUM(range) – adds all numbers in a range
• AVERAGE(range) – calculates mean value
• MIN(range), MAX(range) – smallest and largest numbers

Page 3 – Relative vs Absolute References
• Relative reference: A1 – changes when copied
• Absolute reference: \$A\$1 – fixed row and column
• Mixed reference: \$A1 or A\$1 – only one part fixed
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'ex_3',
              title: 'Data Analysis Basics',
              content: '''
Page 1 – Sorting and Filtering
• Sort data ascending or descending based on a column
• Apply filters to show only rows that meet certain criteria

Page 2 – Simple Charts
• Select your data and insert column, line or pie charts
• Use charts to visualize trends and comparisons

Page 3 – Basic Analysis Workflow
• Clean and format raw data
• Use formulas and summary functions
• Visualize key metrics using charts
''',
              testQuestions: [
                TestQuestionModel(
                  question: 'Which symbol must every Excel formula start with?',
                  options: ['+', '=', '#', '*'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which function is used to add values in a range?',
                  options: ['ADD()', 'SUM()', 'TOTAL()', 'PLUS()'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'What is \$A\$1 an example of?',
                  options: [
                    'Relative reference',
                    'Absolute reference',
                    'Mixed reference',
                    'Named range'
                  ],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which feature lets you show only rows that meet specific conditions?',
                  options: ['Sorting', 'Filtering', 'Merging cells', 'Freezing panes'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which chart type is best for showing trends over time?',
                  options: ['Pie chart', 'Line chart', 'Scatter chart', 'Donut chart'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which function returns the smallest value in a range?',
                  options: ['MIN()', 'LOW()', 'SMALL()', 'BOTTOM()'],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'What do we call a saved file in Excel that can contain many sheets?',
                  options: ['Worksheet', 'Workbook', 'Database', 'Template'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which reference type changes automatically when you copy a formula down?',
                  options: ['Absolute reference', 'Relative reference', 'Mixed reference', 'Named range'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Where do you usually see column letters and row numbers in Excel?',
                  options: ['In the formula bar', 'On the grid edges', 'Inside each cell', 'In the status bar'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which keyboard shortcut commonly saves your workbook?',
                  options: ['Ctrl + N', 'Ctrl + S', 'Ctrl + C', 'Ctrl + Z'],
                  correctIndex: 1,
                ),
              ],
            ),
          ],
        ),
        // 3. HTML
        CourseModel(
          id: 'html',
          title: 'HTML Basics',
          description: 'Understand HTML structure and core tags for building web pages.',
          creditCost: 50,
          lessons: [
            LessonModel(
              id: 'ht_1',
              title: 'HTML Structure',
              content: '''
Page 1 – What is HTML?
HTML (HyperText Markup Language) describes the structure of web pages.
Browsers read HTML and render it visually for users.

Page 2 – Basic Document Skeleton
• <!DOCTYPE html> – declares HTML5 document
• <html>, <head>, <body> – root, metadata and visible content sections

Page 3 – Elements and Attributes
• Elements are written with opening and closing tags, e.g. <p>…</p>
• Attributes provide extra information, e.g. <a href=\"https://example.com\">Link</a>
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'ht_2',
              title: 'Text and Links',
              content: '''
Page 1 – Headings and Paragraphs
• <h1> to <h6> – headings (h1 is most important)
• <p> – paragraph text
• <br> – line break (empty element)

Page 2 – Emphasis and Strong
• <strong> – important text (usually bold)
• <em> – emphasized text (usually italic)

Page 3 – Links
• <a href=\"URL\">Clickable text</a>
• href attribute defines destination
• Links can point to other pages, sections or email addresses
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'ht_3',
              title: 'Lists and Images',
              content: '''
Page 1 – Ordered and Unordered Lists
• <ul> with <li> – unordered (bulleted) list
• <ol> with <li> – ordered (numbered) list

Page 2 – Images
• <img src=\"path\" alt=\"description\" />
• src attribute points to image file
• alt text is important for accessibility and SEO

Page 3 – Putting It Together
Use headings, paragraphs, lists, links and images to build a simple, well‑structured web page.
''',
              testQuestions: [
                TestQuestionModel(
                  question: 'Which tag is used for the main heading on a page?',
                  options: ['<title>', '<h1>', '<head>', '<p>'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which attribute defines the destination of a link?',
                  options: ['src', 'href', 'alt', 'id'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which tag is used to show an image?',
                  options: ['<img>', '<picture>', '<image>', '<src>'],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'Which tag represents a paragraph of text?',
                  options: ['<h1>', '<p>', '<div>', '<span>'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which tag is used for an unordered (bulleted) list?',
                  options: ['<ol>', '<ul>', '<li>', '<list>'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Inside a list, which tag represents each item?',
                  options: ['<item>', '<li>', '<ul>', '<p>'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which section of an HTML document usually contains the page title and metadata?',
                  options: ['<body>', '<head>', '<footer>', '<section>'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which attribute provides alternative text for an image?',
                  options: ['href', 'src', 'alt', 'title'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'What does HTML stand for?',
                  options: [
                    'Hyperlinks and Text Markup Language',
                    'HyperText Markup Language',
                    'Home Tool Markup Language',
                    'HyperText Make Language'
                  ],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which tag is used to create a clickable button that can be styled?',
                  options: ['<btn>', '<button>', '<click>', '<input> only'],
                  correctIndex: 1,
                ),
              ],
            ),
          ],
        ),
        // 4. Python
        CourseModel(
          id: 'python',
          title: 'Python Fundamentals',
          description: 'Learn Python syntax, data types and control flow.',
          creditCost: 60,
          lessons: [
            LessonModel(
              id: 'py_1',
              title: 'Python Basics and Types',
              content: '''
Page 1 – What is Python?
Python is a high‑level, interpreted language known for its readability and large ecosystem.

Page 2 – Variables and Basic Types
• int, float, str, bool
• Variables are created by assignment: x = 10
• Type can be checked with type(x)

Page 3 – Input and Output
• print() to output values
• input() to read from the user (returns string)
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'py_2',
              title: 'Collections and Control Flow',
              content: '''
Page 1 – Lists and Tuples
• List: [1, 2, 3] – mutable sequence
• Tuple: (1, 2, 3) – immutable sequence
• Indexing starts at 0

Page 2 – Dictionaries
• Dictionary: {\"key\": \"value\"}
• Access with dict['key']

Page 3 – Control Flow
• if / elif / else for conditions
• for loops iterate over sequences
• while loops repeat while condition is True
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'py_3',
              title: 'Functions and Modules',
              content: '''
Page 1 – Defining Functions
• Use def: def add(a, b): return a + b
• Parameters and return values

Page 2 – Scope and Arguments
• Local vs global variables
• Positional and keyword arguments

Page 3 – Modules
• Use import to reuse code from other files or libraries
• import math, from math import sqrt
''',
              testQuestions: [
                TestQuestionModel(
                  question: 'Which keyword is used to define a function in Python?',
                  options: ['func', 'def', 'function', 'lambda'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which data structure uses key–value pairs?',
                  options: ['List', 'Tuple', 'Dictionary', 'Set'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'What is Python mainly known for?',
                  options: [
                    'Complex syntax',
                    'Low‑level memory management',
                    'Readability and large ecosystem',
                    'No standard library'
                  ],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which symbol is used to start a comment in Python?',
                  options: ['//', '#', '/*', '--'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'What will len([1, 2, 3]) return?',
                  options: ['2', '3', '4', 'Error'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which built‑in function converts a string to an integer?',
                  options: ['str()', 'int()', 'float()', 'list()'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which keyword is used to import a module?',
                  options: ['use', 'include', 'import', 'from'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which loop is best for iterating over items in a list?',
                  options: ['for', 'while', 'repeat', 'loop'],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'What is the output of 3 * \"hi\" in Python?',
                  options: ['3hi', 'hi3', 'hihihi', 'Error'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which of these is a valid list literal?',
                  options: ['{1, 2, 3}', '(1, 2, 3)', '[1, 2, 3]', '<1, 2, 3>'],
                  correctIndex: 2,
                ),
              ],
            ),
          ],
        ),
        // 5. Java
        CourseModel(
          id: 'java',
          title: 'Java Fundamentals',
          description: 'Understand core Java syntax, OOP concepts and the JVM model.',
          creditCost: 60,
          lessons: [
            LessonModel(
              id: 'ja_1',
              title: 'Java and the JVM',
              content: '''
Page 1 – What is Java?
Java is an object‑oriented, class‑based language that runs on the Java Virtual Machine (JVM).

Page 2 – Compilation Model
• Source code (.java) compiled to bytecode (.class)
• JVM executes bytecode on many platforms (\"write once, run anywhere\")

Page 3 – Basic Program Structure
• public class Main { public static void main(String[] args) { … } }
• main method is the program entry point
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'ja_2',
              title: 'Types and Control Flow',
              content: '''
Page 1 – Primitive Types
• int, long, float, double, char, boolean, byte, short

Page 2 – Reference Types
• Classes, arrays, interfaces
• Created with new keyword (e.g. new String(\"Hi\"))

Page 3 – Control Flow
• if / else, switch
• for, while, do‑while loops
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'ja_3',
              title: 'Classes and Objects',
              content: '''
Page 1 – Defining Classes
• class Person { String name; int age; }
• Objects are instances of classes

Page 2 – Constructors and Methods
• Constructors initialize fields
• Methods define behavior

Page 3 – Inheritance and Interfaces
• extends to inherit from a base class
• implements to implement an interface
''',
              testQuestions: [
                TestQuestionModel(
                  question: 'Java code is compiled into what?',
                  options: ['Machine code', 'Bytecode', 'Python code', 'Assembly only'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which method is the entry point of a Java application?',
                  options: [
                    'run()',
                    'start()',
                    'public static void main(String[] args)',
                    'init()'
                  ],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which keyword is used for inheritance in Java?',
                  options: ['implements', 'extends', 'inherits', 'super'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which keyword creates a new object instance?',
                  options: ['create', 'instanceof', 'new', 'object'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which type holds a sequence of characters in Java?',
                  options: ['int', 'String', 'char', 'boolean'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which access modifier makes a member visible only inside its own class?',
                  options: ['public', 'private', 'protected', 'static'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'What is the correct way to declare an integer variable with value 10?',
                  options: ['int x = 10;', 'integer x = 10;', 'num x = 10;', 'var x := 10;'],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'Which loop is best suited when you know the exact number of iterations?',
                  options: ['for', 'while', 'do‑while', 'switch'],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'Which statement exits a loop immediately?',
                  options: ['continue', 'stop', 'exit', 'break'],
                  correctIndex: 3,
                ),
                TestQuestionModel(
                  question: 'Which keyword prevents a variable from being reassigned after initialization?',
                  options: ['final', 'static', 'const', 'fixed'],
                  correctIndex: 0,
                ),
              ],
            ),
          ],
        ),
        // 6. JavaScript
        CourseModel(
          id: 'javascript',
          title: 'JavaScript Basics',
          description: 'Learn JavaScript syntax, DOM interaction and core concepts.',
          creditCost: 55,
          lessons: [
            LessonModel(
              id: 'js_1',
              title: 'JavaScript Introduction',
              content: '''
Page 1 – What is JavaScript?
JavaScript is a high‑level, dynamic language that runs primarily in the browser to add interactivity to web pages.

Page 2 – Using JavaScript in HTML
• <script> tags in HTML
• External .js files linked with <script src=\"app.js\"></script>

Page 3 – Variables and Types
• let, const, var
• Primitive types: number, string, boolean, null, undefined, symbol, bigint
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'js_2',
              title: 'Control Flow and Functions',
              content: '''
Page 1 – Control Flow
• if / else, switch
• for, while, do…while loops

Page 2 – Functions
• function add(a, b) { return a + b; }
• Arrow functions: const add = (a, b) => a + b;

Page 3 – Scope
• let / const are block‑scoped
• var is function‑scoped
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'js_3',
              title: 'DOM and Events',
              content: '''
Page 1 – Document Object Model (DOM)
• Represents the HTML page as a tree of nodes
• Access elements with document.getElementById, querySelector etc.

Page 2 – Manipulating the DOM
• Change textContent, innerHTML, styles
• Create and append new elements

Page 3 – Events
• Add listeners: element.addEventListener('click', handler)
• Respond to user actions like clicks, input, key presses
''',
              testQuestions: [
                TestQuestionModel(
                  question: 'Which keyword declares a block‑scoped variable in JavaScript?',
                  options: ['var', 'let', 'static', 'define'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'What does the DOM represent?',
                  options: [
                    'Database schema',
                    'Operating system APIs',
                    'Structured representation of the HTML document',
                    'Browser configuration'
                  ],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which method attaches an event handler?',
                  options: [
                    'element.on()',
                    'element.handleEvent()',
                    'element.addEventListener()',
                    'element.attach()'
                  ],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which keyword should you use to declare a constant value?',
                  options: ['var', 'let', 'const', 'static'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which operator is used for strict equality (value and type)?',
                  options: ['==', '===', '=', '!='],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Where is JavaScript code typically executed for web pages?',
                  options: ['On the database server', 'In the browser', 'Inside the OS kernel', 'Inside a PDF viewer'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which built‑in function shows a simple popup message?',
                  options: ['prompt()', 'console.log()', 'alert()', 'print()'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which method writes a message to the browser developer console?',
                  options: ['log()', 'console.log()', 'debug.log()', 'window.log()'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which symbol begins a single‑line comment in JavaScript?',
                  options: ['#', '//', '/*', '<!--'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which HTML tag is commonly used to include JavaScript code?',
                  options: ['<code>', '<js>', '<script>', '<javascript>'],
                  correctIndex: 2,
                ),
              ],
            ),
          ],
        ),
        // 7. C++
        CourseModel(
          id: 'cpp',
          title: 'C++ Basics',
          description: 'Learn C++ syntax, memory model and object‑oriented features.',
          creditCost: 60,
          lessons: [
            LessonModel(
              id: 'cp_1',
              title: 'C++ Overview and Basics',
              content: '''
Page 1 – What is C++?
C++ is a compiled, general‑purpose language that supports both procedural and object‑oriented programming.

Page 2 – Basic Program
• #include <iostream>
• int main() { std::cout << \"Hello\"; return 0; }

Page 3 – Compilation
• Source files (.cpp) compiled to machine code by a compiler
• You must recompile after code changes
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'cp_2',
              title: 'Types, Pointers and References',
              content: '''
Page 1 – Basic Types
• int, double, char, bool, float
• std::string for text (from <string>)

Page 2 – Pointers
• int* p = &x; – p stores memory address of x
• *p dereferences to the value

Page 3 – References
• int& r = x; – r is an alias for x
• Commonly used for function parameters
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'cp_3',
              title: 'Classes and RAII',
              content: '''
Page 1 – Classes
• class Person { public: std::string name; int age; };
• Objects: Person p; p.name = \"Alex\";

Page 2 – Constructors and Destructors
• Constructors initialize members
• Destructors clean up resources

Page 3 – RAII Concept
Resource Acquisition Is Initialization – tie resource lifetime to object lifetime (e.g. file handles, locks).
''',
              testQuestions: [
                TestQuestionModel(
                  question: 'Which header do you include for standard output in C++?',
                  options: ['<stdio.h>', '<iostream>', '<output>', '<stream>'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'What does a pointer store?',
                  options: [
                    'A copy of a value',
                    'A function name',
                    'A memory address',
                    'A file descriptor only'
                  ],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'What does RAII primarily manage?',
                  options: [
                    'Compilation speed',
                    'Resource lifetime with object lifetime',
                    'User interface layout',
                    'Network requests'
                  ],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which operator is used to access a member through a pointer?',
                  options: ['.', '->', '::', ':='],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which keyword is used to define a constant variable in C++?',
                  options: ['let', 'final', 'const', 'static'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which container is part of the C++ Standard Template Library (STL)?',
                  options: ['vector', 'arraylist', 'list<int>', 'seq'],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'Which cast is safest and checked at runtime for downcasting?',
                  options: ['static_cast', 'dynamic_cast', 'reinterpret_cast', 'const_cast'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which keyword is used to release memory allocated with new?',
                  options: ['delete', 'free', 'release', 'dispose'],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'What does the ++ operator do when placed after a variable (i++)?',
                  options: [
                    'Decrements then uses the value',
                    'Uses the value then increments',
                    'Multiplies by 2',
                    'Divides by 2'
                  ],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which type is commonly used to represent true/false values?',
                  options: ['int', 'bool', 'char', 'double'],
                  correctIndex: 1,
                ),
              ],
            ),
          ],
        ),
        // 8. C#
        CourseModel(
          id: 'csharp',
          title: 'C# Fundamentals',
          description: 'Understand C# syntax, .NET runtime and OOP concepts.',
          creditCost: 55,
          lessons: [
            LessonModel(
              id: 'cs_1',
              title: 'C# and .NET',
              content: '''
Page 1 – What is C#?
C# is a modern, object‑oriented language developed by Microsoft, running on the .NET runtime.

Page 2 – Basic Program
• using System;
• class Program { static void Main(string[] args) { Console.WriteLine(\"Hello\"); } }

Page 3 – Compilation and Execution
Source compiled to Intermediate Language (IL), executed by the Common Language Runtime (CLR).
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'cs_2',
              title: 'Types, Properties and Control Flow',
              content: '''
Page 1 – Value and Reference Types
• Value types: int, double, bool, struct
• Reference types: classes, arrays, strings

Page 2 – Properties
• public int Age { get; set; }
• Encapsulate fields with getters and setters

Page 3 – Control Flow
• if / else, switch
• for, foreach, while, do…while loops
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'cs_3',
              title: 'Classes and LINQ Basics',
              content: '''
Page 1 – Classes and Inheritance
• class Animal { public string Name { get; set; } }
• class Dog : Animal { }

Page 2 – Interfaces and Polymorphism
• interface IWalkable { void Walk(); }
• Classes implement interfaces to define contracts

Page 3 – LINQ Introduction
• Language Integrated Query to work with collections
• var adults = people.Where(p => p.Age >= 18);
''',
              testQuestions: [
                TestQuestionModel(
                  question: 'C# code runs on which runtime?',
                  options: ['JVM', '.NET CLR', 'Python VM', 'Node.js'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which syntax defines an auto‑implemented property?',
                  options: [
                    'public int Age;',
                    'int Age { field; }',
                    'public int Age { get; set; }',
                    'property int Age;'
                  ],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'What is LINQ mainly used for?',
                  options: [
                    'Compiling code',
                    'Querying and transforming collections',
                    'Designing UI',
                    'Managing threads only'
                  ],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which keyword declares a class in C#?',
                  options: ['class', 'type', 'struct', 'object'],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'Which type represents true/false values in C#?',
                  options: ['int', 'bool', 'char', 'string'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which collection type is an ordered, index‑based list?',
                  options: ['Dictionary', 'List<T>', 'HashSet<T>', 'Queue<T>'],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which keyword prevents a method from being overridden?',
                  options: ['sealed', 'override', 'virtual', 'static'],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'Which LINQ method filters elements based on a condition?',
                  options: ['Select', 'OrderBy', 'Where', 'GroupBy'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which statement is used to handle exceptions?',
                  options: ['try/catch', 'if/else', 'switch', 'loop'],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'Which keyword is used to create a new object instance?',
                  options: ['new', 'create', 'make', 'instance'],
                  correctIndex: 0,
                ),
              ],
            ),
          ],
        ),
        // 9. CSS
        CourseModel(
          id: 'css',
          title: 'CSS Essentials',
          description: 'Style web pages with CSS selectors, layout and responsive design.',
          creditCost: 50,
          lessons: [
            LessonModel(
              id: 'cs_1b',
              title: 'CSS Basics and Selectors',
              content: '''
Page 1 – What is CSS?
CSS (Cascading Style Sheets) controls the presentation (look and feel) of HTML documents.

Page 2 – Applying CSS
• Inline styles: style=\"color: red;\"
• Internal styles: <style> in the <head>
• External stylesheet: <link rel=\"stylesheet\" href=\"styles.css\">

Page 3 – Basic Selectors
• element selector: p { color: blue; }
• class selector: .note { … }
• id selector: #header { … }
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'cs_2b',
              title: 'Box Model and Positioning',
              content: '''
Page 1 – CSS Box Model
Each element is a box with content, padding, border and margin.

Page 2 – Display and Position
• display: block, inline, inline‑block, flex, grid
• position: static, relative, absolute, fixed, sticky

Page 3 – Spacing
• margin for space outside the element
• padding for space between content and border
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'cs_3b',
              title: 'Flexbox and Responsive Design',
              content: '''
Page 1 – Flexbox Basics
• display: flex on container
• justify‑content, align‑items for alignment

Page 2 – Responsive Layout
• Use relative units (%, rem, vh, vw)
• Flexible layouts that adapt to screen size

Page 3 – Media Queries
• @media (max‑width: 768px) { … }
• Apply different styles for mobile, tablet and desktop
''',
              testQuestions: [
                TestQuestionModel(
                  question: 'What does CSS stand for?',
                  options: [
                    'Computer Styled Sections',
                    'Cascading Style Sheets',
                    'Creative Style System',
                    'Cascading Script Sheets'
                  ],
                  correctIndex: 1,
                ),
                TestQuestionModel(
                  question: 'Which selector targets an element with id=\"main\"?',
                  options: ['main', '.main', '#main', '*main'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which layout system uses justify‑content and align‑items?',
                  options: ['Grid', 'Flexbox', 'Table', 'Float'],
                  correctIndex: 1,
                ),
              ],
            ),
          ],
        ),
        // 10. SQL
        CourseModel(
          id: 'sql',
          title: 'SQL Fundamentals',
          description: 'Learn SQL queries to create, read and manipulate relational data.',
          creditCost: 55,
          lessons: [
            LessonModel(
              id: 'sq_1',
              title: 'Relational Databases and Tables',
              content: '''
Page 1 – What is SQL?
SQL (Structured Query Language) is used to interact with relational databases.

Page 2 – Tables, Rows and Columns
• Data is stored in tables made of rows and columns
• Each column has a data type

Page 3 – Primary Keys
• Uniquely identify each row
• Often an integer ID column
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'sq_2',
              title: 'SELECT and Filtering',
              content: '''
Page 1 – Basic SELECT
• SELECT * FROM customers;
• SELECT name, city FROM customers;

Page 2 – WHERE Clause
• SELECT * FROM customers WHERE city = 'London';
• Use comparison operators (=, <, >, <=, >=, <>, BETWEEN)

Page 3 – ORDER BY and LIMIT
• ORDER BY column ASC / DESC
• LIMIT to restrict number of rows (database‑specific syntax)
''',
              testQuestions: [],
            ),
            LessonModel(
              id: 'sq_3',
              title: 'Joins and Aggregation',
              content: '''
Page 1 – JOINs
• INNER JOIN returns matching rows between tables
• LEFT JOIN keeps all rows from left table

Page 2 – Aggregate Functions
• COUNT(*), SUM(amount), AVG(price), MIN(date), MAX(score)

Page 3 – GROUP BY
• GROUP BY groups rows that share a value
• Often combined with aggregate functions
''',
              testQuestions: [
                TestQuestionModel(
                  question: 'What does SQL stand for?',
                  options: [
                    'Structured Query Language',
                    'Simple Query Logic',
                    'Sequential Query Language',
                    'Standard Question Language'
                  ],
                  correctIndex: 0,
                ),
                TestQuestionModel(
                  question: 'Which keyword is used to filter rows in a SELECT query?',
                  options: ['ORDER BY', 'GROUP BY', 'WHERE', 'LIKE'],
                  correctIndex: 2,
                ),
                TestQuestionModel(
                  question: 'Which JOIN keeps all rows from the left table?',
                  options: ['INNER JOIN', 'LEFT JOIN', 'RIGHT JOIN', 'FULL JOIN'],
                  correctIndex: 1,
                ),
              ],
            ),
          ],
        ),
      ];
}
