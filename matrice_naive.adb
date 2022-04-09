package body matrice_naive is


   procedure Initialiser(M: out T_Matrice) is
   begin
       for i in 1..nbr_pages loop
           for j in 1..nbr_pages loop
               M(i,j) := 0.0;
           end loop;
       end loop;
   end Initialiser;


   procedure Enregistrer (M : in out T_Matrice ; i : in Integer ; j : in Integer) is
   begin
      M(i+1 , j+1) := 1.0;
   end Enregistrer;


   procedure Diviser_nbr1 (M : in out T_Matrice ) is
   sum : T_Reel;
   begin
      for i in 1..nbr_pages loop
        sum := 0.0;
        for j in 1..nbr_pages loop
            if M(i,j) /= 0.0 then
                sum := sum + 1.0;
            else
                null;
            end if;
        end loop;
        if sum = 0.0 then
            null;
        else
            for j in 1..nbr_pages loop
                M(i,j) := M(i,j)/sum;
            end loop;
        end if;
      end loop;
   end Diviser_nbr1;


   procedure remplir_ligne_vide (M : in out T_Matrice) is
   index : integer;
   moteur : boolean;
   begin
      for i in 1..nbr_pages loop
        index := 1;
        moteur := True;
        while index <= nbr_pages and moteur loop
            if M(i,index) /= 0.0 then
                moteur := False;
            else
                index := index + 1;
            end if;
        end loop;

        if moteur then
            for j in 1..nbr_pages loop
                M(i,j) := 1.0/T_Reel(nbr_pages);
            end loop;
        else
            null;
        end if;
      end loop;
   end remplir_ligne_vide;


   procedure enregistrer_ElemLine (M : in out T_Matrice ; a : in T_Reel ; b : in T_Reel) is
   begin
       for i in 1..nbr_pages loop
           for j in 1..nbr_pages loop
               M(i,j) := a*M(i,j) + b;
           end loop;
       end loop;
   end enregistrer_ElemLine;


   procedure remplir_allVec (V : in out T_Vecteur ; a : in T_Reel) is
   begin
       for i in 1..nbr_pages loop
           V(i) := a;
       end loop;
   end remplir_allVec;


   procedure affecter_vecteur (V1 : in out T_Vecteur ; V2 : in T_Vecteur) is
   begin
       V1 := V2;
   end affecter_vecteur;


   procedure modifier_element_vecteur ( V : in out T_Vecteur ; a : in T_Reel; i : in Integer) is
   begin
       V(i) := a;
   end modifier_element_vecteur;


   function prod_vecteur_matrice ( M : in T_Matrice ; pi : in T_Vecteur ) return T_Vecteur is
   intermediaire : T_Reel;
   produit_vect_matrice : T_Vecteur;
   begin
      for j in 1..nbr_pages loop
            intermediaire := 0.0;
            for i in 1..nbr_pages loop
                intermediaire := intermediaire + pi(i) * M(i,j);
            end loop;
            produit_vect_matrice(j) := intermediaire;
      end loop;
      return produit_vect_matrice;
   end prod_vecteur_matrice;


   function Element_Vecteur (V : in T_vecteur ; i : in Integer) return T_Reel is
   begin
       return V(i);
   end Element_Vecteur;


   procedure Trier_decroissant(Vect1:in out T_Vecteur;Vect2:in out T_Vecteur) is
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
   end Trier_decroissant;


   procedure Generer_Vecteur ( vect : out T_vecteur) is
   begin
       for i in 1..nbr_pages loop
           vect(i) := T_Reel(i);
       end loop;
   end Generer_Vecteur;


end matrice_naive;
