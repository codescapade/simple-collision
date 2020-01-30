package;

import kha.graphics2.Graphics;

class SceneManager {

  var currentScene: Scene;

  public function new() {}

  public function update(dt: Float): Void {
    if (currentScene != null) {
      currentScene.update(dt);
    }
  }

  public function render(buffer: Graphics): Void {
    if (currentScene != null) {
      currentScene.render(buffer);
    }
  }

  public function switchScene(scene: Class<Scene>): Void {
    if (currentScene != null) {
      currentScene.destroy();
    }

    currentScene = Type.createInstance(scene, []);
    currentScene.create();
  }
}