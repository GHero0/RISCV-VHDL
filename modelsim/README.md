# ENSSAT-SNum2-RISC-V-design
## Simulation avec ModelSim

Ce repertoire est parfait pour réaliser vos simulations modelsim. Pour vous simplifier la vie quelques scripts ont été développés par votre enseignants. Toutefois avant de pouvoir les utiliser vous devez charger les variables d'environnement afin d'accéder aux outils. Pour cela tapez une des deux commandes ci-dessous en fonction du shell que vous utiliser:

```shell
$ source ./scripts/env.sh
$ source ./scripts/env.tsh
```

Maintenant que les outils sont configurées, vous pouvez lancer la simulation des différents modules directement en ligne de commande. Par exemple pour lancer la simulation du module **mem_load.vhd**, il vous suffit d'écrire:

```shell
$ ./scripts/vsim_load.sh
```

Le script se charge de lancer modelsim et de lui faire compiler les fichiers nécessaires à la simulation du testbench. Ensuite la simulation est executée 1000 ms avant de se terminer. En théorie, une fois que vous aurez complété les testbenchs, si aucune assertion ne reporte d'erreurs, on peut considerer que cela fonctionne parfaitement ;-)

Il est possible de lancer modelsim en mode graphique au lieu d'utiliser le mode terminal. Pour cela, il suffit de modifier la ligne suivante:

```shell
vsim mem_store_tb -c -quiet -do "set NumericStdNoWarnings 1; run 1000ms; exit"
```

Enlever le flag **-c** pour passer en mode graphique et enlever la commande **exit** pour que l'outil ne se ferme pas une fois la simulation terminée.

Les autres scripts présents dans le repertoire permettent de simuler les autres modules et le SoC intégrant le coeur RISC-V.
