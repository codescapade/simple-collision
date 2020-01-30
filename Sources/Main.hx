package;

import kha.Assets;
import kha.Framebuffer;
import kha.Image;
import kha.Scaler;
import kha.Scheduler;
import kha.System;

import scenes.World01;

class Main {

  static var sceneManager: SceneManager;

  static var prevTime: Float;

  static var dt: Float;

  static var backBuffer: Image;

  static function main(): Void {
    System.start({ title: 'Simple Collision', width: 800, height: 600 }, function(_) {
      Assets.loadEverything(function() {
        sceneManager = new SceneManager();
        prevTime = Scheduler.time();
        backBuffer = Image.createRenderTarget(800, 600);

        sceneManager.switchScene(World01);
        Scheduler.addTimeTask(update, 0, 1 / 60);
        System.notifyOnFrames(render);
      });
    });
  }

  static function update(): Void {
    var time = Scheduler.time();
    dt = time - prevTime;
    sceneManager.update(dt);
    prevTime = time;
  }

  static function render(frames: Array<Framebuffer>): Void {
    var buffer = backBuffer.g2;
    buffer.begin();
    sceneManager.render(buffer);
    buffer.end();

    buffer = frames[0].g2;
    buffer.begin();
    Scaler.scale(backBuffer, frames[0], System.screenRotation);
    buffer.end();
  }
}
