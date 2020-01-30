package objects;

import kha.Color;
import kha.graphics2.Graphics;
import math.Rect;

class Box {

  public var x: Float;
  public var y: Float;
  public var width: Float;
  public var height: Float;

  public var bounds: Rect;

  public var isStatic: Bool;

  public var velocityX: Float;

  public var velocityY: Float;

  public var mass: Float = 1;

  public var bounce: Float = 0;

  public var dragX: Float = 0;

  public var dragY: Float = 0;

  public function new(x: Float, y: Float, width: Float, height: Float) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;

    bounds = new Rect(x, y, width, height);
    isStatic = false;
    velocityX = 0;
    velocityY = 0;
  }

  public function update(dt: Float): Void {
    if (!isStatic) {
      if (velocityX - dragX > 0) {
        velocityX -= dragX;
      } else if (velocityX + dragX < 0) {
        velocityX += dragX;
      } else {
        velocityX = 0;
      }
      

      if (velocityY - dragY > 0) {
        velocityY -= dragY;
      } else if (velocityY + dragY < 0) {
        velocityY += dragY;
      } else {
        velocityY = 0;
      }

      x += velocityX * dt;
      y += velocityY * dt;
    }

    updateBounds();
  }

  public function render(buffer: Graphics): Void {
    buffer.color = Color.White;

    buffer.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
  }

  function updateBounds(): Void {
    bounds.x = x;
    bounds.y = y;
    bounds.width = width;
    bounds.height = height;
  }
}