String headline = "How Population Growth, Industrial Agriculture And Environmental Pollution May Have Weakened Society";
String body = "How Population Growth, Industrial Agriculture And Environmental Pollution May Have Weakened Society How Population Growth, Industrial Agriculture And Environmental Pollution May Have Weakened Society A determined young man with a strong sense of his destiny - to save his country from postmodern collapse. October 30, 2016 Culture The global population in 1800 was about one billion people. Today it stands at over seven times that amount, with the rapidly growing populations of India and Africa expected to increase that to at least nine billion over the coming years. Readers today are well used to the idea that the ‚Äúglobal south‚Äù is densely populated relative to its economic size and area, but this was not always the case. Prior to the collapse of Empire, Europe, having undergone thorough industrialization, was the most densely populated continent in the world. Source: ‚ÄúThe World at Six Billion‚Äù, United Nations, 1999.1950-2100 ‚Äì UN, Dept. of Economic and Social Affairs, Population Division (2011) Europe was also where the world‚Äôs social justice movements‚Äîliberalism, communism and feminism‚Äîbegan, overthrowing the old order of kings, castes and courtship with the vulgar and degenerate world we suffer today. But why did this happen? Why did the immense increase of wealth and prosperity not correspond to an increase of human happiness, but instead lead to the emasculation of men, the breakdown of the family, and the disappearance of religion and morality? In these series of articles, I examine the root causes of this paradox, what one can do about it on an individual dietary level, and what one can do about it on an individual environmental level. I am a strong believer in social change through individual growth, and, having experienced a dramatic turnaround in the quality of my own personality and success of my outcomes as a result of following these strategies, I hope that others can benefit from my knowledge, and similarly make themselves into solid Men. Popular mainstream theories for social degeneration Many authors have postulated economic reasons for this degeneration‚Äîindustrialization, having deprived men of their primary roles as the masters of nature, reduced their worth and attractiveness‚Äîor utility‚Äîin the eyes of women. Relatedly, others argue that technological progress, which increased independence and ability for all, allowed women to go their own way. Another popular argument is that increased prosperity leads to reduced incentive for discipline‚Äîr-selection versus K-selection‚Äîand so prosperous, disciplined societies create a generation of lazy youngsters, fat off the success of their parents, who cause so much havoc with their short sighted policies that their civilization collapses, leading to a new generation of disciplined youngsters who again create greatness. One example of a short-sighted policy would be the feminist political movement, which artificially separated woman from man by giving her, through affirmative action, socially harmful economic independence. While all these explanations bear some truth, none of them delve into the deeply emotional, spiritual, human and thus fundamentally biological causes of social degeneration. Why the mainstream theories are flawed To begin with, a healthy Man and a healthy woman, even with modern technology at their disposal, should not so substantially less love and cherish each other, as seems to be the case today. The proof of this can be seen by examining what it is women do with that technology: a modern loose woman uses technology to go to places where men can ravish her. Even if it gives woman the ability to go it alone, Technology does not diminish her emotional and biological need for man. Further, the availability of technology does not always translate into its adoption‚Äîthe failure of Google Glass is the emblematic example. It does not have to be the case that smartphones are automatically adopted for Slut Culture‚Äîthey do not have to automatically lead to female promiscuity. Anyone familiar with Russian or Japanese women, who have the same technology at hand, but a vastly greater sense of restraint and self-worth, can attest to this fact. Therefore, the technological argument is not sufficient to explain modern degeneracy, although it is certainly a necessary condition. credit: Ninaras credit: moguphotos To briefly examine the argument that Men no longer have (non-financial) utility in the eyes of women: a man is not necessarily attractive to a woman if he actually breaks rocks, or actually kills other people‚Äîinstead, being able to is sufficient.";
PFont headlineFont, bodyFont;
Table table;
PImage desk;
PGraphics c1;
void setup(){
  size(800, 800,P3D);
  // FONT
  headlineFont = createFont("Chomsky.otf", 48);
  bodyFont = createFont("Oldnewspapertypes-449D.ttf", 18);
  
  
  // CANVAS
  c1 = createGraphics(800, 800);
  stroke(80);
  
  table = loadTable("fake-news.csv", "header");
  
  desk = loadImage("desk.jpg");
}

int margin = 30;
int offset = 0;
void draw() {
  
  background(0);
  translate(width/2, height/2, -400);
  rotateX(0.5);
  image(desk, -width, -height, 2*width, 2*height);
  drawNewspaper(headline, body, c1);
  translate(-width/2, -height/2, 400);
  
  for(int i = 0; i < 50; i+=2) {
    int noiseSeed = i+offset;
    pushMatrix();
    rotateY(noise(noiseSeed)*PI*0.05);
 
    beginShape();
    textureMode(NORMAL);
    texture(c1);
    vertex(margin + 100*noise(noiseSeed), margin-i, -i, 0, 0);
    vertex(width-2*margin- 100*noise(noiseSeed),margin, -i, 1, 0);
    vertex(width-2*margin- 100*noise(noiseSeed),height,-i, 1, 1);
    vertex(margin+100*noise(noiseSeed), height, -i,0, 1);
    endShape();
    popMatrix();
  }
}

void drawNewspaper(String headline, String body, PGraphics canvas) {
  canvas.beginDraw();
  canvas.textAlign(CENTER);
  canvas.loadPixels();
  for (int i = 0; i < canvas.pixels.length; i++) {
    canvas.pixels[i] = color(200 + 55*noise(i/4));
  }
  canvas.updatePixels();
  
   
  int margin = 40;
  canvas.fill(40);
  canvas.textFont(headlineFont);
  canvas.text(headline, margin, margin, width-2*margin, height/4-2*margin);
  
  canvas.textFont(bodyFont);
  canvas.text(body, margin, height/4+margin, width-2*margin, height-2*margin);
  canvas.endDraw();

}

void mouseClicked() {
  
  int randomIdx = int(random(table.getRowCount()));
  offset = randomIdx;
  TableRow row = table.getRow(randomIdx);
  
  headline = row.getString("title");
  body = row.getString("text");  
}
