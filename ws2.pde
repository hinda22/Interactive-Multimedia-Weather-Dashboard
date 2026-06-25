// ==========================================================
// Weather Dashboard avec Intro Vidéo + Audio
 // Hind Saada (Master: mp2eea 2025)
// ==========================================================

// ------------------------ LIBRARIES ------------------------
import controlP5.*;        // Importe la bibliothèque ControlP5 pour créer des interfaces graphiques (sliders, boutons…)
import ddf.minim.*;        // Importe Minim pour gérer les fichiers audio (MP3)
import processing.video.*; // Importe la bibliothèque vidéo permettant la lecture de fichiers vidéo

// ------------------------ INTRO ASSETS ------------------------
Movie introVideo;          // Objet vidéo pour afficher l’introduction
Minim minim;               // Gestionnaire audio global pour Minim
AudioPlayer introAudio;    // Lecteur audio pour jouer le fichier MP3 d’introduction
boolean showDashboard = false; // Indique si on doit afficher l’intro (false) ou le dashboard (true)

ControlP5 introCp5;        // Interface graphique uniquement pour l’écran d’introduction

// ------------------------ DASHBOARD GLOBALS ------------------------
ControlP5 cp5;             // Interface graphique principale utilisée dans le Dashboard

float temperature;         // Variable stockant la température
float humidity;            // Variable stockant l’humidité
float pressure;            // Variable stockant la pression
float feltTemp = 0;        // Température ressentie calculée

boolean warming = true;         // Permet d’alterner entre chauffe et refroidissement
boolean manualControl = false;  // false : automatique, true : mode manuel

PFont font;                // Police utilisée pour les textes
PImage hotImg, coldImg, neutralImg; // Images affichées selon la température ressentie

// ==========================================================
// SETUP — Exécuté une seule fois au lancement
// ==========================================================
void setup() {
  size(700, 550);          // Définit la taille de la fenêtre en 700x550 pixels
  smooth();                // Active l’anticrénelage pour des dessins plus lisses

  // -------- Vidéo d’introduction --------
  introVideo = new Movie(this, "entrer.mp4"); // Charge la vidéo MP4 dans l'objet Movie
  introVideo.loop();                           // Lance la lecture en boucle continue
  introVideo.volume(0);                        // Désactive le son de la vidéo (on joue l’audio séparément)

  // -------- Audio d’introduction --------
  minim = new Minim(this);                     // Initialise le moteur audio Minim
  introAudio = minim.loadFile("audio.mp3");    // Charge le fichier MP3
  introAudio.play();                           // Joue le son d’introduction immédiatement

  // -------- Bouton ENTER --------
  introCp5 = new ControlP5(this);              // Crée l’interface CP5 spéciale intro

  introCp5.addButton("enterApp")               // Ajoute un bouton appelé "enterApp"
    .setPosition(550, 30)                      // Position du bouton dans la fenêtre
    .setSize(120, 35)                          // Dimensions du bouton
    .setLabel("ENTER")                         // Texte affiché sur le bouton
    .setColorBackground(color(0, 140, 255))    // Couleur de fond du bouton au repos
    .setColorActive(color(0, 200, 255))        // Couleur quand le bouton est actif (survol/clic)
    .setColorLabel(color(255))                 // Couleur du texte
    .setColorForeground(color(255));           // Couleur du contour du bouton
}

// ==========================================================
// DRAW — Exécuté en boucle (≈60 images/seconde)
// ==========================================================
void draw() {

  // ======================================================
  // 1) ÉCRAN D’INTRODUCTION (VIDEO + AUDIO)
  // ======================================================
  if (!showDashboard) {                     // Si showDashboard == false, on reste sur l'écran d'intro

    if (introVideo.available())             // Vérifie si une nouvelle frame de la vidéo est disponible
      introVideo.read();                    // Lit et décode cette frame

    image(introVideo, 0, 0, width, height); // Affiche la vidéo sur toute la fenêtre
    return;                                 // Quitte la fonction draw → empêche d’afficher le Dashboard
  }

  // ======================================================
  // 2) DASHBOARD MÉTÉO (AFFICHAGE PRINCIPAL)
  // ======================================================
  background(45);                            // Remplit l’écran d’une couleur gris foncé

  // -------- Mode automatique --------
  if (!manualControl) {                      // Si le mode manuel n’est PAS activé :

    if (warming) {                           // Si la température est en phase de montée
      temperature += 0.5;                    // Augmente progressivement la température
      if (temperature > 30) warming = false; // Si elle dépasse 30°C, on inverse vers refroidissement
    } else {                                 // Sinon, phase de descente
      temperature -= 0.5;                    // Diminue la température
      if (temperature < 5) warming = true;   // Si elle descend sous 5°C, on repasse à la montée
    }

    humidity = 60 + sin(frameCount * 0.05) * 20;  // Simule une humidité oscillante autour de 60%
    pressure = 1013 + sin(frameCount * 0.03) * 10; // Simule une pression oscillante autour de 1013 hPa

    cp5.getController("temperature").setValue(temperature); // Met à jour le slider Température
    cp5.getController("humidity").setValue(humidity);       // Met à jour le slider Humidité
    cp5.getController("pressure").setValue(pressure);       // Met à jour le slider Pression
  }

  // -------- Mode manuel --------
  temperature = cp5.getController("temperature").getValue(); // Récupère la valeur du slider Température
  humidity    = cp5.getController("humidity").getValue();    // Récupère la valeur du slider Humidité
  pressure    = cp5.getController("pressure").getValue();    // Récupère la valeur du slider Pression

  // -------- Calcul température ressentie --------
  feltTemp = calcFeltTemperature(temperature, humidity);     // Appelle la fonction pour calculer le “feels like”

  // -------- Affichage image météo --------
  if (feltTemp >= 25)        image(hotImg, 0, 0);     // Affiche l’image chaude si température forte
  else if (feltTemp <= 10)   image(coldImg, 0, 0);    // Affiche l’image froide si température faible
  else                       image(neutralImg, 0, 0); // Affiche l’image neutre sinon

  // -------- Affichage des titres --------
  fill(255);                                  // Texte en blanc
  textAlign(CENTER);                          // Centre le texte horizontalement
  textSize(30);                               // Taille de police
  text("Weather Station Dashboard", width/2, 40); // Titre principal

  textSize(26);                               // Taille du texte secondaire
  text("Feels Like: " + nf(feltTemp, 2, 1) + " °C", width/2, 80); // Affiche température ressentie

  // -------- Message météo --------
  String msg;                                 // Variable texte pour le message météo
  color msgColor;                             // Couleur du message

  if (feltTemp >= 25) {                       // Si chaud
    msg = "It feels HOT";
    msgColor = color(255, 80, 50);
  } else if (feltTemp <= 10) {                // Si froid
    msg = "It feels COLD";
    msgColor = color(100, 180, 255);
  } else {                                    // Tempérée
    msg = "It feels Comfortable";
    msgColor = color(150, 255, 150);
  }

  fill(msgColor);                             // Applique la couleur choisie
  text(msg, width/2, 120);                    // Affiche le message

  // -------- Barres verticales --------
  drawBar(width/4 - 50, 350, temperature, -10, 50,  "°C",  "Temper.",  color(255, 100, 100)); // Barre Temp.
  drawBar(width/2 - 50, 350, humidity,     0, 100, "%",   "Humidity", color(100, 180, 255)); // Barre Hum.
  drawBar(width*3/4 - 50,350, pressure,    950,1050,"hPa","Pressure", color(150, 255, 150)); // Barre Press.
}

// ==========================================================
// ÉVÈNEMENT VIDÉO — Appelé automatiquement par Processing
// ==========================================================
void movieEvent(Movie m) {
  m.read();                 // Lit et charge la nouvelle frame vidéo
}

// ==========================================================
// BOUTON ENTER — Quand on clique, on démarre le dashboard
// ==========================================================
void enterApp() {
  showDashboard = true;     // Passe au Dashboard
  introAudio.pause();       // Arrête l'audio
  introVideo.stop();        // Stoppe la vidéo d’intro
  setupDashboard();         // Initialise les éléments du dashboard
}

// ==========================================================
// INITIALISATION DU DASHBOARD
// ==========================================================
void setupDashboard() {

  font = createFont("Arial", 18); // Charge une police personnalisée
  textFont(font);                 // Applique la police

  temperature = random(-10, 50);  // Température initiale aléatoire
  humidity    = random(20, 90);   // Humidité initiale aléatoire
  pressure    = random(980,1030); // Pression initiale aléatoire

  hotImg     = loadImage("hot5.png");     // Charge image météo chaude
  coldImg    = loadImage("cold5.png");    // Charge image météo froide
  neutralImg = loadImage("neutral3.png"); // Charge image météo neutre

  hotImg.resize(width, height);           // Ajuste les images à la taille de la fenêtre
  coldImg.resize(width, height);
  neutralImg.resize(width, height);

  cp5 = new ControlP5(this);              // Crée l'interface graphique principal CP5

  // -------- Couleurs sliders --------
  color bg  = color(35);        // Fond gris foncé
  color fg  = color(255);       // Texte blanc
  color c1  = color(255, 80, 80);  // Couleur Température
  color c2  = color(60, 160, 255); // Couleur Humidité
  color c3  = color(80, 255, 150); // Couleur Pression

  cp5.addSlider("temperature")          // Crée un slider Température
     .setPosition(150, 450)             // Position
     .setSize(400, 22)                  // Taille
     .setRange(-10, 50)                 // Intervalle
     .setValue(temperature)             // Valeur initiale
     .setColorBackground(bg)            // Couleur du fond
     .setColorForeground(c1)            // Couleur du slider
     .setColorActive(c1)                // Couleur quand actif
     .getCaptionLabel().setColor(fg);   // Couleur du texte

  cp5.addSlider("humidity")             // Slider Humidité
     .setPosition(150, 480)
     .setSize(400, 22)
     .setRange(0, 100)
     .setValue(humidity)
     .setColorBackground(bg)
     .setColorForeground(c2)
     .setColorActive(c2)
     .getCaptionLabel().setColor(fg);

  cp5.addSlider("pressure")             // Slider Pression
     .setPosition(150, 510)
     .setSize(400, 22)
     .setRange(950, 1050)
     .setValue(pressure)
     .setColorBackground(bg)
     .setColorForeground(c3)
     .setColorActive(c3)
     .getCaptionLabel().setColor(fg);

  cp5.addButton("toggleManual")         // Bouton pour activer/désactiver le mode manuel
     .setPosition(550, 30)
     .setSize(120, 35)
     .setLabel("AUTO")
     .setColorBackground(color(80))
     .setColorActive(color(150))
     .setColorForeground(color(255))
     .setColorLabel(color(255));
}

// ==========================================================
// FONCTION : Dessine une barre verticale animée
// ==========================================================
void drawBar(float x, float yBase, float value, float minVal, float maxVal,
             String unit, String label, color c) {

  float h = map(value, minVal, maxVal, 0, 220); // Convertit la valeur en hauteur
  float y = yBase - h;                          // Calcule la position du haut de la barre

  noStroke();                                   // Désactive les contours
  fill(0, 0, 0, 60);                             // Ombre noire transparente
  rect(x+10, y+10, 80, h, 20);                   // Dessine ombre

  fill(c);                                      // Couleur principale de la barre
  rect(x, y, 80, h, 20);                         // Barre verticale

  stroke(255);                                  // Bordure blanche
  noFill();
  rect(x, y, 80, h, 20);                         // Contour de la barre

  noStroke();
  fill(255);
  textAlign(CENTER);
  textSize(20);
  text(label, x+40, yBase+40);                  // Affiche le nom de la mesure

  textSize(22);
  text(nf(value,2,1)+" "+unit, x+40, y-15);     // Affiche la valeur numérique
}

// ==========================================================
// CALCUL TEMPERATURE RESSENTIE (Wind Chill / Humidex simplifié)
// ==========================================================
float calcFeltTemperature(float T, float H) {
  if (T < 10)
    return T - (10 - T) * 0.7; // Si froid, l’humidité amplifie la sensation de froid

  return T + H / 5.0;          // Si chaud, l’humidité amplifie la sensation de chaleur
}

// ==========================================================
// BOUTON AUTO/MANUAL — Change de mode
// ==========================================================
void toggleManual() {
  manualControl = !manualControl;  // Inverse l’état manuel/automatique

  if (manualControl)               // Change le texte affiché sur le bouton
    cp5.getController("toggleManual").setLabel("MANUAL");
  else
    cp5.getController("toggleManual").setLabel("AUTO");
}
