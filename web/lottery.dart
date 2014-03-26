import 'dart:html';
import 'dart:math' as math;
import 'dart:convert' show JSON;
import 'dart:async' show Future;
import 'package:game_loop/game_loop_html.dart';

int width = 1000;
int height = 200;
var ctx;

GameLoopHtml gameLoop;
bool started = false;
int maxRandomNumbers = 20;
int count;


class Participants {
  static List<String> names = [];
  
  static Future readyParticipants() {
    var path = 'participants.json';
    return HttpRequest.getString(path)
        .then(_parseParticipantsFromJSON);
  }
  
  static _parseParticipantsFromJSON(String jsonString) {
    Map participants = JSON.decode(jsonString);
    names = participants['names'];
  }

}


void main() {
  
  CanvasElement canvas = createCanvas();
  
  gameLoop = new GameLoopHtml(canvas);
  gameLoop.start();
  var timer = gameLoop.addTimer((timer) => showRandomName(), 0.3, periodic:true);
  
  Participants.readyParticipants()
    .then((_) {
      //on success
    })
    .catchError((arrr) {
      print('Error initializing participants: $arrr');
    });

}

CanvasElement createCanvas() {
  CanvasElement canvas = new CanvasElement();
  var container = querySelector("#container");
  container.append(canvas);
  canvas.width = width;
  canvas.height = height;
  Element button = querySelector("#button");
  ctx = canvas.context2D;
  button.onClick.listen((event) => shuffle());
  
  return canvas;
}


void shuffle(){
  started = true;
  count = 0;  
}

void showRandomName() {
    if (started && count < maxRandomNumbers) {
      var random = new math.Random();
      num randomNumber = random.nextInt(Participants.names.length)+1;  
      ctx..fillStyle = "rgb(185,185,185)"
        ..fillRect(10, 10, width, height)
        ..strokeStyle = "black"
        ..font = '100px Arial'
        ..fillStyle = "rgb(6,162,216)"
        ..fillText(Participants.names[randomNumber-1], 20,height-50);
      count++;
    }
    
    
}



