with ada.Unchecked_Deallocation;
package body matrice_creuse is
    procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_ptr);

    procedure initialiser_tab (Tab : out T_Table_Colonne) is
    begin
        for i in 1..nbr_pages loop
            Tab(i) := null;
        end loop;
    end initialiser_tab;

    function Est_Vide (tab : in T_Table_Colonne ; i : in integer) return boolean is
    begin
        return tab(i) = null;
    end Est_Vide;

    procedure ajouter_elem (Tab : in out T_Table_Colonne; i : in integer ; j : in Integer) is
        procedure enreg ( lc : in out T_ptr ; j : in integer) is
        begin
            if lc = null then
                lc := new T_Cellule;
                lc.all.ligne := j;
                lc.all.suivante := null;
            else

                enreg(lc.all.suivante , j);
            end if;
        end enreg;
    begin
        enreg(Tab(i) , j);
    end ajouter_elem;

    function emplacement (lc : in T_ptr ) return Integer is
    a : integer;
    begin
        if lc /= null then
            a := lc.all.ligne;
        end if;
        return a;
    end emplacement;

    procedure initialiser_vec (Vect : out T_vector) is
    begin
        for i in 1..nbr_pages loop
            Vect(i) := 0.0;
        end loop;
    end initialiser_vec;

    procedure enregistrer_vec (Vect : in out T_vector ; i : in Integer ; a : in T_Reel) is
    begin
        Vect(i) := a;
    end enregistrer_vec;

    procedure remplir_ToutVec (V : in out T_vector ; a : in T_Reel) is
    begin
        for i in 1..nbr_pages loop
            V(i) := a;
        end loop;
    end remplir_ToutVec;

    procedure affectation_vecteur (V1 : in out T_Vector ; V2 : in T_Vector) is
    begin
        V1 := V2 ;
    end affectation_vecteur;

    procedure modif_elements_vector_unifie ( v : in out T_Vector ; a : in T_Reel) is
    begin
        for i in 1..nbr_pages loop
            v(i) := a;
        end loop;
    end modif_elements_vector_unifie;

    function sommer_ElemVec (V : in T_Vector) return T_Reel is
        s : T_Reel := 0.0;
    begin
        for i in 1..nbr_pages loop
            s := s + V(i);
        end loop;
        return s;
    end sommer_ElemVec;

    procedure Additionner_ElemVec (V : in out T_Vector ; i : in Integer ; a : in T_Reel) is
    begin
        V(i) := V(i) + a;
    end Additionner_ElemVec;

    function element_a_emplacement (V : in T_vector ; i : in integer ) return T_Reel is
    begin
        return V(i);
    end element_a_emplacement;



    function somme_vector ( V1 : in T_Vector ; V2 : in T_Vector) return T_Vector is
    s_vecteur : T_Vector;
    begin
        for i in 1..nbr_pages loop
            s_vecteur(i) := V1(i) + V2(i);
        end loop;
        return s_vecteur;
    end somme_vector;

    procedure Trier_decroissant_vector(Vect1:in out T_Vector;Vect2:in out T_Vector) is
      position: Integer;
      Max_Poids : T_Reel;
      Indice : T_Reel;

    begin
      for I in 1..nbr_pages-1 loop
         Max_Poids := Vect1(I);
         Indice := Vect2(I);
         position := I;
         for K in I+1..nbr_pages loop
            if Vect1(K) > Max_Poids then
               position:=K;
               Max_Poids:= Vect1(position);
               Indice:=Vect2(position);
            end if;
         end loop;

         Vect1(position):= Vect1(I);
         Vect1(I):= Max_Poids;
         Vect2(position) := Vect2(I);
         Vect2(I):= Indice;
      end loop;
    end Trier_decroissant_vector;

    function case_table (tab : in T_Table_Colonne ; i : in Integer) return T_ptr is
    begin
        return tab(i);
    end case_table;

    function prod_vecteur_vcreux (V : in T_Vector ; lc : in T_ptr ; alpha : in T_Reel; Vn : in T_Vector) return T_Reel is
    s : T_Reel;

    begin
        s := 0.0;
        if lc = null then
            s := s + 0.0;
        else

            s := s + V(lc.all.ligne)*alpha/Vn(lc.all.ligne) + prod_vecteur_vcreux(V , lc.all.suivante , alpha ,Vn );

        end if;
        return s;
    end prod_vecteur_vcreux;

    procedure modif_elements_vector (V : in out T_Vector ; i : in Integer ; a : in T_Reel) is
    begin
        V(i) := a;
    end modif_elements_vector;


    procedure generer_vec ( vect : out T_vector) is
    begin
       for i in 1..nbr_pages loop
           vect(i) := T_Reel(i);
       end loop;
    end generer_vec;

    procedure Vider (tab : in out T_Table_Colonne ; i : in Integer) is
        procedure Vider_ptr (lc :in out T_ptr) is
        begin
            if lc /= null then
                Vider_ptr (lc.all.suivante);
                Free (lc);
            else
                null;
            end if;
        end Vider_ptr;
    begin
        Vider_ptr(tab(i));
    end Vider;
end matrice_creuse;
