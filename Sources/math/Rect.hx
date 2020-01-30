package math;

class Rect {
  public var x: Float;
  public var y: Float;
  public var width: Float;
  public var height: Float;

  public var tlX(get, null): Float;
  public var tlY(get, null): Float;

  public var brX(get, null): Float;
  public var brY(get, null): Float;

  public function new(x: Float, y: Float, width: Float, height: Float) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  public function overlaps(rect: Rect): Bool {
    return !(x > rect.x + rect.width || x + width < rect.x || y > rect.y + rect.height || y + height < rect.y);
  }

  public function hasPoint(xPos: Float, yPos: Float): Bool {
    return xPos >= x && xPos <= x + width && yPos >= y && yPos <= y + height;
  }

  function get_tlX(): Float {
    return x;
  }

  function get_tlY(): Float {
    return y;
  }

  function get_brX(): Float {
    return x + width;
  }

  function get_brY(): Float {
    return y + height;
  }
}