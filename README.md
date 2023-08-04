# UNITEST
Ce cadre d'application permet de faire des tests unitaires pour des programmes écrit en Turbo Pascal.

<h3>Liste des unités du projets</h3>

<table>
  <tr>
    <th>Nom</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>UNITEST.PAS</tr>
    <td>Cette unité contient les outils pour faire des tests unitaires.</td>
  </tr>
</table>

<h3>Exemple</h3>
Voici un exemple d'utilisation:
<code>
 Program VotreProgramme;

Uses UNITEST;

 { ... Votre code ... }

BEGIN
 { ... Votre code ... }
 Plan(4);
 IsInteger('Test 1',4,4);
 IsInteger('Test 2',7,7);
 IsBoolean('Test 3',True,True);
 IsReal('Test 4',1.0,1.0);
 Pass('Plan de test 1-2-3-4');
END. 
</code>
on obtiendra un résultat ressemblant à ceci :
<samp>
<pre>
1..4
Test 1 : BON
Test 2 : BON
Test 3 : BON
Test 4 : BON
Plan de test 1-2-3-4 : BON
</pre>
</samp>
