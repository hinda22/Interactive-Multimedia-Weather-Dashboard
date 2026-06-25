# Interactive Multimedia Weather Dashboard

## Overview

Interactive Multimedia Weather Dashboard is a weather station simulation developed using Processing. The application combines multimedia elements, graphical user interfaces, and real-time weather data simulation to create an engaging and interactive user experience.

The system features an introductory video with audio playback, followed by a dynamic dashboard that displays simulated meteorological parameters including temperature, humidity, atmospheric pressure, and perceived temperature.

The project was developed as part of the "Développement et Solutions" course within the Professional Master's program in Electrical and Electronic Engineering.

---

## Features

### Multimedia Introduction

* Introductory video screen
* Background audio playback
* Interactive ENTER button for navigation

### Weather Dashboard

* Real-time weather simulation
* Temperature monitoring
* Humidity monitoring
* Atmospheric pressure monitoring
* Feels-like temperature calculation

### Interactive Controls

* Automatic simulation mode
* Manual adjustment mode
* Interactive sliders
* Dynamic switching between AUTO and MANUAL modes

### Visual Feedback

* Weather-dependent background images
* Animated vertical gauges
* Color-coded indicators
* Real-time value updates

---

## Technologies Used

* Processing
* ControlP5
* Minim
* Processing Video Library

---

## Project Structure

```text
project/
│
├── main.pde
├── entrer.mp4
├── audio.mp3
├── hot5.png
├── cold5.png
├── neutral3.png
└── README.md
```

---

## Libraries

### ControlP5

Used to create graphical user interface components:

* Buttons
* Sliders
* Interactive controls

### Minim

Used for audio management:

* Audio loading
* Audio playback
* Audio control

### Processing Video

Used for:

* Video playback
* Video frame management
* Multimedia introduction screen

---

## Weather Simulation

Since no physical sensors are connected, weather data is generated using mathematical models and random values.

The simulation includes:

* Random initialization of meteorological parameters
* Temperature oscillation between heating and cooling phases
* Sinusoidal humidity variation
* Sinusoidal atmospheric pressure variation

This approach allows realistic weather behavior without requiring external hardware such as Arduino boards or sensors.

---

## Dashboard Parameters

### Temperature

Range:

```text
-10°C to 50°C
```

### Humidity

Range:

```text
0% to 100%
```

### Atmospheric Pressure

Range:

```text
950 hPa to 1050 hPa
```

### Feels-Like Temperature

The perceived temperature is calculated using a simplified model:

* Cold conditions amplify the sensation of cold.
* High humidity increases the sensation of heat.

---

## How to Run

### Requirements

Install:

* Processing IDE
* ControlP5 Library
* Minim Library
* Processing Video Library

### Steps

1. Clone the repository

```bash
git clone https://hinda22/Interactive-Multimedia-Weather-Dashboard.git
```

2. Open the project in Processing IDE.

3. Ensure all multimedia assets are located inside the data folder.

4. Run the sketch.

---


---

## Future Improvements

* Integration with real weather sensors
* Arduino connectivity
* IoT implementation
* Weather data storage
* Historical trend analysis
* Mobile-friendly interface
* Online weather API integration

---

## Author

Hind Saada

Professional Master's Degree in Electrical and Electronic Engineering (EEA)

Specialization: Integration of Electrical Circuits Dedicated to Renewable Energies

Academic Year: 2025–2026



This project was developed within the framework of the "Développement et Solutions" course and demonstrates the integration of multimedia technologies, graphical interfaces, simulation techniques, and interactive programming using Processing.
