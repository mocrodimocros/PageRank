generic
    nbr_pages: Integer;
    type T_Reel is digits <>;

package matrice_naive is

   type T_Matrice is limited private;
   type T_Vecteur is limited private;


   --Crée une matrice de taille nbr_pages² remplie de 0
   procedure Initialiser(M: out T_Matrice) ;

   --Remplace l'élément M(i,j) par 1.0
   procedure Enregistrer (M : in out T_Matrice ; i : in Integer ; j : in Integer);

   --Divise chaque ligne par le nombre de 1 présent dans cette ligne
   procedure Diviser_nbr1 (M : in out T_Matrice );

   --Remplace les lignes où tous les éléments sont égaux à 0 par 1/nbr_pages   (nbr_pages réprésente la taille de la matrice)
   procedure remplir_ligne_vide (M : in out T_Matrice);

   --Modifie chaque élément de la matrice de façon linéaire
   procedure enregistrer_ElemLine (M : in out T_Matrice ; a : in T_Reel ; b : in T_Reel);

   --Modifie tous les éléments d'un vecteur par un même élément
   procedure remplir_allVec (V : in out T_Vecteur ; a : in T_Reel);

   --Affecte la valeur d'un vecteur à un autre
   procedure affecter_vecteur (V1 : in out T_Vecteur ; V2 : in T_Vecteur);

   --------Modifie l'élément d'indice i du vecteur par a
   procedure modifier_element_vecteur ( V : in out T_Vecteur ; a : in T_Reel; i : in Integer);

   --Effectue le produit vecteur, matrice et retourne un vecteur
   function prod_vecteur_matrice (M : in T_Matrice ; pi : in T_Vecteur ) return T_vecteur;

   --Retourne l'élément d'indice i du vecteur
   function Element_Vecteur (V : in T_vecteur ; i : in Integer) return T_Reel;

   --Trie dans l'ordre décroissant un vecteur et applique les mêmes changement à un deuxième vecteur comportant les indices du premiers vecteur
   procedure Trier_decroissant (Vect1: in out T_Vecteur; Vect2 : in out T_Vecteur);

   --Genere un vecteur comportant les indices de 1 à nbr_pages
   procedure Generer_Vecteur ( vect : out T_vecteur);

private

    type T_Matrice is array(1..nbr_pages,1..nbr_pages) of T_Reel;
    type T_Vecteur is array(1..nbr_pages) of T_Reel;

end matrice_naive;
