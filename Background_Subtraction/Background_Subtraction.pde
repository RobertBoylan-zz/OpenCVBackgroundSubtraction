import gab.opencv.*;
import processing.video.*;

Movie video;
OpenCV opencv;

int typeIndex = 0;

void setup() {

  size(1280, 720);

  video = new Movie(this, "CameraHighway.mp4");
  video.play();

  opencv = new OpenCV(this, width, height);

  opencv.startBackgroundSubtraction(5, 3, 0.5);
}

void draw() {
  if (video!=null && video.width>0 && video.height>0) {

    opencv.loadImage(video);

    opencv.updateBackground();

    opencv.dilate();
    opencv.erode();

    if (typeIndex == 0) {
      image(video, 0, 0, width, height);
    } else if (typeIndex == 1) {
      image(opencv.getOutput(), 0, 0, width, height);
    } else if (typeIndex == 2) {
      image(opencv.getOutput(), 0, 0, width, height);
      blend(video, 0, 0, width, height, 0, 0, width, height, DARKEST);
    }

    noFill();
    stroke(255, 0, 0);
    strokeWeight(3);

    if (frameCount >= 30 && (typeIndex == 0 || typeIndex == 1)) {
      for (Contour contour : opencv.findContours()) {
        contour.draw();
      }
    }
  }
}

void movieEvent(Movie m) {
  m.read();
}

void keyReleased() {
  if (keyCode == RIGHT) {
    typeIndex++;

    if (typeIndex > 2) {
      typeIndex = 0;
    }
  } else if (keyCode == LEFT) {
    typeIndex--;

    if (typeIndex < 0) {
      typeIndex = 2;
    }
  }
}