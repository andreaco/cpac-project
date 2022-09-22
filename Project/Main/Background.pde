void drawBackground() {
  if (!DEBUG) {
    canvas.fill(0, 7);
    canvas.rect(0, 0, width, height);
  }
  else {
    background(0);
  }
}
