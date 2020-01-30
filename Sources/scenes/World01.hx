package scenes;

import kha.input.Keyboard;
import kha.input.KeyCode;
import kha.graphics2.Graphics;
import objects.Box;

class World01 extends Scene {

  var boxes: Array<Box>;

  var gravity: Float = 400;

  var player: Box;

  var leftDown: Bool = false;

  var rightDown: Bool = false;

  var jumpDown: Bool = false;

  var grounded: Bool = false;

  public override function create() {
    trace('world 01 created');
    boxes = [];

    var floor = new Box(20, 500, 760, 20);
    floor.isStatic = true;
    boxes.push(floor);

    var floor2 = new Box(100, 400, 200, 30);
    floor2.isStatic = true;
    boxes.push(floor2);

    for (i in 0...2) {
      var b = new Box(300 + 50 * i, 400, 20, 20);
      b.dragX = 2;
      boxes.push(b);
    }
    player = new Box(390, 400, 20, 30);
    player.dragX = 3;
    boxes.push(player);

    Keyboard.get().notify(keyDown, keyUp);
  }

  public override function update(dt:Float) {

    if (leftDown) {
      player.velocityX -= 400 * dt;
    } else if (rightDown) {
      player.velocityX += 400 *dt;
    }

    if (jumpDown && grounded) {
      player.velocityY = -300;
    }

    for (box in boxes) {
      if (!box.isStatic) {
        box.velocityY += gravity * dt;
      }
    }

    for (box in boxes) {
      box.update(dt);
    }

    grounded = false;
    for (box in boxes) {
      for (box2 in boxes) {
        if (box == box2) {
          continue;
        }
        if (box.bounds.overlaps(box2.bounds)) {
          separate(box, box2);
        }
      }
    }
  }

  public override function render(buffer:Graphics) {
    for (box in boxes) {
      box.render(buffer);
    }
  }

  public override function destroy() {
    
  }

  function keyDown(key: KeyCode): Void {
    if (key == Left) {
      leftDown = true;
    } else if (key == Right) {
      rightDown = true;
    } else if (key == Up) {
      jumpDown = true;
    }
  }

  function keyUp(key: KeyCode): Void {
    if (key == Left) {
      leftDown = false;
    } else if (key == Right) {
      rightDown = false;
    } else if (key == Up) {
      jumpDown = false;
    }
  }

  function separate(box1: Box, box2: Box): Void {
    if (box1.isStatic) {
      return;
    }

    var overlapX: Float = Math.min(box1.bounds.brX, box2.bounds.brX) - Math.max(box1.bounds.tlX, box2.bounds.tlX);
    var overlapY: Float = Math.min(box1.bounds.brY, box2.bounds.brY) - Math.max(box1.bounds.tlY, box2.bounds.tlY);
    if (overlapX != 0 && overlapY != 0) {
      if (overlapX > overlapY) {
        overlapX = 0;
      } else {
        overlapY = 0;
      }
    } else {
      return;
    }
    
    overlapX = box1.x > box2.x ? overlapX : -overlapX;
    overlapY = box1.y > box2.y ? overlapY : -overlapY;
    if (box1 == player) {
      if (overlapY < 0) {
        grounded = true;
      }
    }

    if (!box2.isStatic) {
      if (overlapX != 0) {
        overlapX *= 0.5;
        box1.x += overlapX;
        box2.x -= overlapX;

        var box1VelX = Math.sqrt((box2.velocityX * box2.velocityX * box2.mass) / box1.mass) * (box2.velocityX > 0 ? 1: -1);
        var box2VelX = Math.sqrt((box1.velocityX * box1.velocityX * box1.mass) / box2.mass) * (box1.velocityX > 0 ? 1: -1);
        var average = (box1VelX + box2VelX) * 0.5;
        box1VelX -= average;
        box2VelX -= average;
        // trace('one: ${box1VelX}, two: ${box2VelX}');
        box1.velocityX = average + box1VelX * box1.bounce;
        box2.velocityX = average + box2VelX * box2.bounce;

        if (box1.velocityX > -20 && box1.velocityX < 20) {
          box1.velocityX = 0;
        }

        if (box2.velocityX > -20 && box2.velocityX < 20) {
          box2.velocityX = 0;
        }
      }

      if (overlapY != 0) {
        overlapY *= 0.5;
        box1.y += overlapY;
        box2.y -= overlapY;

        var box1VelY = Math.sqrt((box2.velocityY * box2.velocityY * box2.mass) / box1.mass) * (box2.velocityY > 0 ? 1: -1);
        var box2VelY = Math.sqrt((box1.velocityY * box1.velocityY * box1.mass) / box2.mass) * (box1.velocityY > 0 ? 1: -1);
        var average = (Math.abs(box1VelY) + Math.abs(box2VelY)) * 0.5;
        box1VelY -= average;
        box2VelY -= average;
        box1.velocityY = average + box1VelY * box1.bounce;
        box2.velocityY = average + box2VelY * box2.bounce;

        if (box1.velocityY > -20 && box1.velocityY < 20) {
          box1.velocityY = 0;
        }

        if (box2.velocityY > -20 && box2.velocityY < 20) {
          box2.velocityY = 0;
        }
      }
    } else {
      if (overlapX != 0) {
        box1.x += overlapX * 0.5;
        box1.velocityX = -box1.velocityX * box1.bounce;
        if (box1.velocityX > -20 && box1.velocityX < 20) {
          box1.velocityX = 0;
        }
      }
      
      if (overlapY != 0) {
        box1.y += overlapY * 0.5;
        box1.velocityY = -box1.velocityY * box1.bounce;
        if (box1.velocityY > -20 && box1.velocityY < 20) {
          box1.velocityY = 0;
        }
      }
    }    
  }
}