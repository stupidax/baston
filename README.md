# baston
Je de combat 2D à 2 bouttons PC/Mobile.
Jouable à deux sur le même mobile.
Système de jeu en ligne avec rollbacknetcode.

Principe et mécaniques du jeu.

But du jeu : 
	- réduire la vie de l'adversaire à 0.

Un joueur possède une barre de vie et une barre de bouclier.
Le personnage en idle bloque automatique les attaques.
	- cela consomme de la barre de bouclier.

Il y a deux bouttons :
	* un boutton attaque 
	* un boutton parade.
Lorsqu'on réalise une attaque ou une parade, le personnage ne bloque pas.

ATTAQUE :
---------
Les attaques sont des attaques qui se charge en laissant appuyé le boutton attaque.
Elle se réalise lorsqu'on relâche le boutton attaque.
plus on maintien le boutton attaque plus puissante est l'attaque.
Une attaque peut atteindre 3 niveau de puissance.

niveau 0 :	Light
	- inflige peu de dégât
	- n'inflige pas de hit stun
	- vitesse rapide
	- bloquable : inflige peu de dégât dans le bouclier
	- parable

niveau 1 :	Medium
	- inflige des dégâts modérés
	- inflige un hit stun à l'adversaire (recovery en avantage à l'attaquant)
	- vitesse moyenne
	- bloquable : inflige beaucoup de dégât dans le bouclier
	- parable

niveau 2 :	Strong
	- inflige beaucoup de dégât
	- inflige un hit stun à l'adversaire (recovery des deux personnages identiques)
	- imbloquable
	- imparable
	- pour contrer une attaque de niveau 2 il faut
		* soit infliger un hit stun (attaque niveau 1)
		* soit avoir fait subir trois attaque niveau 0 dans un lapse de temps court

Il est possible de cancel la charge d'une attaque par une parade.
	- en appuyant sur le boutton parade alors qu'on charge l'attaque.
	- il n'est pas possible de cancel une attaque si elle est déjà lancée.

Pendant une charge, le personnages est vulnérable car il ne bloque pas.

Une attaque, une fois lancée, possède 3 états de frames :
	- Start-up
	- Actives
	- Recovery

Le nombre de frame est variable en fonction de l'attaque et du personnage.

Pendant le start-up, le personnage est vulnérable car il ne bloque pas.
	- en cas d'attaque :
		* il subit les dégâts
	- en cas de hit_stun :
		* il subit le stun et donc son attaque est arrêté
	- en cas de parade adverse :
		* rien ne se passe durant le start-up d'une attaque

Pendant les frames actives, l'attaque est prioritaire.
	- en cas d'attaque :
		* les dégâts sont infligés en même temps (double touche)
	- en cas de hit_stun :
		* l'attaque la plus puissante remporte le hit_stun
	- en cas de parade :
		* si l'attaque n'est pas imparable, alors l'attaquant subit la contre-attaque.
			l'attaque est annulée, et il subit le contre.

Pendant les recovery frames, le personnage est vulnérable car il ne bloque pas.
	- en cas d'attaque :
		* il subit les dégâts
	- en cas de hit_stun :
		* il subit le stun
	- en cas de parade adverse :
		* rien ne se passe durant le recovery d'une attaque
		
PARADE :
--------
Les parades permettent de contrer les attaques adverses en appuyant sur le boutton parade.
Une parade se lance directement à l'appuie de la touche parade.
Attention cependant il y a un start-up avant qu'elle soit active.
Il est possible de cancel une charge par une parade.
	* la charge est alors imédiatement interompue pour laisser place à la parade
	* attention il y a toujours les start-up frames (voir ci-dessous)
Il n'est pas possible de cancel une parade par une charge d'attaque.
	* il faut attendre d'avoir fini la parade (qu'elle soit réussie ou non) pour relancer une charge.

Une parade, une fois lancée, possède 3 états de frames :
	- Start-up
	- Actives
	- Recovery

Pendant le start-up, le personnage est vulnérable car il ne bloque pas.
	- en cas d'attaque :
		* il subit les dégâts
	- en cas de hit_stun :
		* il subit le stun et donc sa parade est arrêté

Pendant les frames actives, la parade est prioritaire sur l'attaque active
	- en cas d'attaque : (durant les frames actives)
		* si l'attaque n'est pas imparable, alors l'attaquant subit la contre-attaque.
			l'attaque est annulée, et il subit le contre.
	- en cas de hit_stun :
		* cela signifie qu'il a subit une attaque imparable
		* voir les résultats d'une attaque imparable.
	- en cas de parade adverse :
		* rien ne se passe

Pendant les recovery frames, le personnage est vulnérable car il ne bloque pas.
	- en cas d'attaque :
		* il subit les dégâts
	- en cas de hit_stun :
		* il subit le stun
	- en cas de parade adverse :
		* rien ne se passe durant le start-up d'une attaque

Si la parade réussie, il se réalise une contre-attaque.
les personnages sont alors comme immobilisés et le temps s'arrête le temps de l'animation du contre
chaque personnage subit ses recovery frame et redémarre à la frame prêt.

BLOQUER :
---------
par défaut notre personnage défend l'attaque (sauf les imparables)
chaque attaque subit

HIT_STUN & BLOCK_STUN :
-----------------------

un hit stun est le nombre de frame pendant lequel le personnage subit l'attaque 
et ne peut donc rien faire.
un block stun est le nombre de frame pendant lequel le personnage bloque
et ne peut donc rien faire.

si le hit stun est supérieur au recovery de l'attaque, l'attaquant pourra agir plus tôt
si le hit stun est équivalent au recovery de l'attaque, aucun avantage
si le hit stun est inférieur au recovery de l'attaque, alors le defenseur pourra agir plus tôt

si le block stun est supérieur au recovery de l'attaque, l'attaquant pourra agir plus tôt
si le block stun est équivalent au recovery de l'attaque, aucun avantage
si le block stun est inférieur au recovery de l'attaque, alors le defenseur pourra agir plus tôt

le hit stun affecte l'attaquant
le block stun affecte le défenseur

le hit stun dépend des personnages, en attaque et en défense.

DATA FRAME :
------------

voici donc les frames data pour chaque personnage :
	FRAME DATA
		frames de charge
			niv 1
			niv 2
			cap_max
		frames d'attaque (pour chaque type : light, medium, strong)
			start-up
			active
			recovery
		frames de parade
			start-up
			active
			recovery
		frames de block_stun (le nombre de stun_frame que rajoute le fait de bloquer l'attaque)
			light
			medium
		frames de hit_stun (le nombre de stun_frame que rajoute l'attaque si elle touche)
			light
			medium
			strong (identique pour tous)
		frames de counter (si parade réussie)
			counter (identique pour tous) idem hit_stun strong
	STATS DATA
		Life_max
		Shield_max
		Dégâts
			light
			medium
			strong
		Dégât
			counter
		Shield_break
			light
			medium
		
