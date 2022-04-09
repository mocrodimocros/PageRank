generic
    nbr_pages: Integer;
    type T_Reel is digits <>;


package matrice_creuse is
    type T_Table_Colonne is limited private;
    type T_Vector is limited private;
    type T_ptr is limited private;

    --Cr�er un tableau de nbr_pages colonnes dont les �l�ments sont des
    --chainages de pointeurs.
    procedure initialiser_tab (Tab : out T_Table_Colonne);

    --V�rifier si le pointeur se trouvant � la colonne i du tableau tab pointe
    --vers la valeur nulle.
    function Est_Vide (tab : in T_Table_Colonne ; i : in integer) return boolean;

    --Cr�er une nouvelle cellule dans le chainage se trouvant � la colonne i
    --du tableau et y mettre la valeur j
    procedure ajouter_elem (Tab : in out T_Table_Colonne; i: in Integer ; j : in Integer);

    --Retourner la valeur vers laquelle pointe lc
    function emplacement (lc : in T_ptr) return Integer;

    --Cr�er un vecteur rempli de 0.0
    procedure initialiser_vec (Vect : out T_vector);

    --Remplacer V(i) par a
    procedure enregistrer_vec (Vect : in out T_vector ; i : in Integer ; a : in T_Reel);

    --Remplacer tous les �l�ments du vecteurs V par a.
    procedure remplir_ToutVec (V : in out T_Vector ; a : in T_Reel);

    --Associer les �l�ments du vecteur V2 au vecteur V1.
    procedure affectation_vecteur (V1 : in out T_Vector ; V2 : in T_Vector);

    -------Remplacer tous les �l�ments du vecteur V par a.
    procedure modif_elements_vector_unifie (V : in out T_Vector ; a : in T_Reel);

    --Retourner la somme des �l�ments de V.
    function sommer_ElemVec (V : in T_Vector) return T_Reel;

    --Remplacer V(i) par V(i) + a
    procedure Additionner_ElemVec (V : in out T_Vector ; i : in Integer ; a : in T_Reel);

    --Retourner l�l�ment � l'emplacement i du vecteur V
    function element_a_emplacement (V : in T_vector ; i : in integer ) return T_Reel;

    --Retourne la somme de deux vecteurs
    function somme_vector ( V1 : in T_Vector ; V2 : in T_Vector) return T_Vector;

    --Trier les �l�ments d'un vecteur Vect1 dans l'ordre d�croissant, est appliquer les
    --m�mes changements de position au vecteur Vect2
    procedure Trier_decroissant_vector (Vect1: in out T_Vector; Vect2 : in out T_Vector);

    --Retourner le pointeur tab(i)
    function case_table (tab : in T_Table_Colonne ; i : in Integer) return T_ptr;

    --Effectuer le produit vectoriel entre un vecteur plein et une matrice creuse
    function prod_vecteur_vcreux (V : in T_Vector ; lc : in T_ptr ; alpha : in T_Reel; Vn : in T_Vector) return T_Reel;

    -----Remplacer V(i) par a
    procedure modif_elements_vector (V : in out T_Vector ; i : in Integer ; a : in T_Reel);

    --Cr�er un vecteur contenant les nombres de 1.0 � float(nbr_pages)
    procedure generer_vec ( vect : out T_vector);

    --Lib�rer la m�moire apr�s utilisation
    procedure Vider (tab : in out T_Table_Colonne ; i : in Integer);

private
    Type T_Vector is array(1..nbr_pages) of T_Reel;
    Type T_Cellule;
    Type T_ptr is access T_Cellule;
    Type T_Cellule is
       record
        ligne : integer;
        suivante : T_ptr;
       end record;
    Type T_Table_Colonne is array(1..nbr_pages) of T_ptr;
end matrice_creuse;
