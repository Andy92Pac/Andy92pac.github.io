---
title: "Trafic mongo"
author: "AHAMADA Farid, MPONDO BLACK Andy, Narjes NALOUTI & Tinhinene MAHTAL"
---


1. Présentation des données
2. Dashboard
  + 2.1 Carte
  + 2.2 Localisation capteur sélectionné
  + 2.3 Informations capteur sélectionné
  + 2.4 Statistique descriptives (Plot)
  + 2.5 Série temporelle
 

***


## 1. Présentation des données

Sur le réseau parisien, la mesure du trafic s’effectue majoritairement par le biais de boucles électromagnétiques implantés dans la chaussée.
Deux types de données sont ainsi élaborés :
 le taux d’occupation, qui correspond au temps de présence de véhicules sur la boucle en pourcentage d’un intervalle de temps fixe (une heure pour les données fournies). Ainsi, 25% de taux d’occupation sur une heure signifie que des véhicules ont été présents sur la boucle pendant 15 minutes. Le taux fournit une information sur la congestion routière. L’implantation des boucles est pensée de manière à pouvoir déduire, d’une mesure ponctuelle, l’état du trafic sur un arc.
 le débit est le nombre de véhicules ayant passé le point de comptage pendant un intervalle de temps fixe (une heure pour les données fournies).
Ainsi, l’observation couplée en un point du taux d’occupation et du débit permet de caractériser le trafic. Cela constitue l’un des fondements de l’ingénierie du trafic, et l’on nomme d’ailleurs cela le « diagramme fondamental ».
Un débit peut correspondre à deux situations de trafic : fluide ou saturée, d’où la nécessité du taux d’occupation. A titre d’exemple : sur une heure, un débit de 100 véhicules par heure sur un axe habituellement très chargé peut se rencontrer de nuit (trafic fluide) ou bien en heure de pointe (trafic saturé).

***

## 2. Dashboard

Ce dashboard permet de visualiser les données des capteurs de trafic disponibles sur le site d'OpenData de Paris.

__2.1 Carte__

Il est composé d'une carte de capteurs sur laquelle l'ensemble des capteurs sont représentés.

__2.2 Informations capteur sélectionné__

Il est possible de cliquer sur ces derniers afin d’obtenir plus de détails.
Ainsi, lors d’un clic sur un capteur, il sera possible d’obtenir l’adresse associée à celui-ci, mais également sa latitude et sa longitude.

__2.3 Statistique descriptives (Plot)__

En plus de cela, plusieurs graphiques s’afficheront.
Ceux-ci permettent de visualiser graphiquement les taux d’occupation récoltés par le capteur sélectionné : depuis le début, par année, par mois et enfin par jour.

__2.4 Série temporelle__

Pour finir, le dashboard permet également, lorsque les données le permettent, de réaliser des prédictions du taux et du débit en fonction des données récoltées précédemment.

***