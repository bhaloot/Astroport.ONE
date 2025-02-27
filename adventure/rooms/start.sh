#!/bin/bash

clear

# Logic in the game is stored in .ben files. This sample has just one 'logic' file.
# You can add more logic files by simply adding a 'sed' command and appropriate .ben file.
# First off, let us reset the game logic. Use this as an example.

sed -i='' 's/on/off/' ../logic/leverlogic.ben

# Who doesn't love ASCII text, right?
# Next up, let's initialise the Title Art
file1="../art/titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
echo

# Next up, let's load in the initial introduction. Script is also stored in .ben files.
sleep 5
file2="../script/opening.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file2"
read -p "Pressez sur [ENTER] pour démarrer..."

# Okay, now that the introduction is out of the way, we can start the first room!
clear
file1="../art/titleart.ben"
while IFS= read -r line
do
    echo "$line"
done <"$file1"
sleep 1

# Here's where you introduce the room to the player. Be sure to tell them if there
# Are exits - but don't give too much away. Make it fun for them to explore!
echo
echo "La téléportation vous a placé debout au centre d'une clairière."
echo "Vous vous trouvez près d'une ancienne bergerie aux gros murs de pierres."
echo "Le toit et une bonne partie des murs sont effondrés."
echo
echo "Tout autour la forêt. Des feuillus. Quelques arbustres épineux."
echo "Sous vos pieds. Le sol est rouge parsemé de cailloux blancs."
echo
echo "Vous pouvez vous diriger selon les points cardinaux."
echo "Au nord un chemin remonte, au sud un passage descend, à l'est, la bergerie, à l'ouest, des traces d'animaux"
echo
echo "Que voulez-vous faire? Les commandes sont : n, e, s, w, u, d et h."

# Now we wait for their response - and send them somewhere accordingly.
while true; do
    read -p "> " nsewuh
    case $nsewuh in
        d ) echo "Vous récupérez un écran portatif interactif par terre."
            echo "Appuyez sur Entrée pour continuer..."
            read -r
              # Exécutez riddle.sh après avoir ramassé l'écran
            ./riddle.sh  
            ;; 
        n ) ./white.sh
            exit ;;
        s ) ./brown.sh
            exit ;;
        e ) ./red.sh
            exit ;;
        w ) ./green.sh
            exit ;;
        u ) echo "Vous ouvrez votre sac il contient une tente, des vêtements, un thermos, une scie pliante et un couteau" ;;
        h ) echo "Comment avez-vous pu arriver ici.? Des souvenirs vous reviennent... https://web.archive.org/web/20211129105224/https://oasis.astroport.com/a-quel-jeu-voulons-nous-jouer/" ;;
        * ) echo "Je suis désolé, je ne vous comprends pas. Les commandes sont : n, e, s, w, u et h..";;
    esac
done
exit
