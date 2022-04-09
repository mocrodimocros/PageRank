with Ada.Integer_Text_IO;            use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;              use Ada.Float_Text_IO;
with Ada.Command_Line;               use Ada.Command_Line;
with Ada.Text_IO;                    use Ada.Text_IO;
with Ada.Strings.Unbounded;
with matrice_naive;
with matrice_creuse;

procedure google is
    type T_Double is digits 6;
    No_File_Error, Argument_I_Error, Argument_A_Error : Exception;
    package SU renames Ada.Strings.Unbounded;
	use SU;
        

   procedure analyse_commande ( mode : out T_Double ; it_max :out integer ; alpha : out T_Double ; nom_fichier : out Unbounded_String ) is
      Type T_Tabul is array(1..6) of T_Double;
      Tab_args : T_Tabul;
      indice : integer := 1;
      
      function Est_entier_positif(ch : in String) return Boolean is
      begin
	    if Float'Value(ch) /= float(Integer'Value(ch)) or Integer'Value(ch) <= 0 then
		    raise Argument_I_Error;
	    else
	    	return(True);
	    end if;
      Exception
	    when Constraint_Error => raise Argument_I_Error;
      end Est_entier_positif;

	function Est_Reel(ch : in String) return Boolean is
	begin
		if Float'Value(ch) <= 0.0 or Float'Value(ch) >= 1.0 then
			raise Argument_A_Error;
		else
			return(True); 
		end if;
	Exception
		when Constraint_Error => raise Argument_A_Error;
	end Est_Reel;

	function Indice_Fichier(ch: in String) return Boolean is

	begin
			return (SU.Count(To_Unbounded_String(ch), ".net") = 1);
	Exception
		when Constraint_Error => raise No_File_Error;
                when Name_Error => raise No_File_Error;
	end Indice_Fichier;

   
   begin
       --Création d'un tableau de 5 colonnes dont les éléments sont 0.0 ou 1.0 :
       --ces 5 colonnes représentent le nombre d'arguments de la ligne de commande
       --sans compter l'agument "fichier". Si l'argument est présent, 1.0 est mis
       --dans la colonne qui lui est associée , et 0.0 sinon. 
       for i in 1..5 loop
           Tab_args(i) := 0.0;
       end loop;
       --Exploiter les paramètres de la ligne de commande
	  if Argument_Count = 0 then
		 raise No_File_Error;
      else
        while indice <= Argument_Count loop
           if Argument(indice) = "-P" then
               Tab_args(1) := 1.0;
               indice := indice + 1;
           elsif Argument(indice) = "-I" and then Est_entier_positif(Argument(indice+1)) then
               Tab_args(2) := 1.0;
               Tab_args(3) := T_Double'Value(Argument(indice+1));
               indice := indice + 2;
           elsif Argument(indice) = "-A" and then Est_Reel(Argument(indice+1)) then
               Tab_args(4) := 1.0;
               Tab_args(5) := T_Double'Value(Argument(indice+1));
               indice := indice + 2;
           elsif Indice_Fichier(Argument(indice)) then
               nom_fichier := To_Unbounded_String(Argument(indice));
               indice := indice + 1;
           end if;
       end loop;
       
       mode := Tab_args(1);

       if Tab_args(2) = 1.0 then
           it_max := Integer(Tab_args(3));
       else
           it_max := 150;
       end if;

       if Tab_args(4) = 1.0 then
           alpha := Tab_args(5);
       else
           alpha := 0.85;
       end if;
     end if;
     
     
   end analyse_commande;

   function identifier_nbr_pages return integer is
      nbr : integer;
      alpha: T_Double;
      it_max: integer;
      name: Unbounded_String;
      fich: File_Type;
      mode: T_Double;
   begin
      analyse_commande(mode,it_max,alpha,name);
      Put(To_String(name));
      New_Line;
      open (fich,In_File,To_String(name));
      get (fich , nbr);
      close (fich);
      return nbr;
   end identifier_nbr_pages;

   package matrice_naive_sujet is new matrice_naive(identifier_nbr_pages,T_Reel =>T_Double);
         use matrice_naive_sujet;

   package matrice_creuse_sujet is new matrice_creuse(identifier_nbr_pages,T_Reel =>T_Double);
         use matrice_creuse_sujet;

   modee : T_Double;
   iteration_max :  integer ;
   alphaa : T_Double ;
   nom_fich : Unbounded_String ;
   fich, page_rank ,weight : File_Type;
   nbr_pages : integer;

   procedure google_naive is
       i, j, indice : integer;
       pi, V_indice : T_Vecteur;
       M : T_Matrice;
   begin
    --Création d'une matrice de taille nbr_pages² remplie de 0
    Initialiser(M);
    Put_line("Matrice initialisée");
    
    --lecture du fichier contenant le réseau
    open (fich,In_File,To_String(nom_fich));
    Skip_Line(fich);
    
    --Remplacer chaque case d'indices (i,j) de la matrice M par 1.
    while not End_Of_File(fich) loop
         get(fich ,  i);
         get(fich , j);
         Enregistrer ( M , i ,j );
         skip_line(fich);
    end loop;
    close (fich);
    Put_Line("Matrice H cree");
    
    --Diviser chaque ligne de la matrice M par le nombre d'éléments différents
    --de 0 de cette même ligne.
    Diviser_nbr1(M);
    
    --Remplacer les lignes de 0 par 1
    remplir_ligne_vide(M);
    
    --On multiplie chaque élément de la matrice par le premier argument et on le
    --somme avec le deuxième argument
    enregistrer_ElemLine(M,alphaa,(1.0-alphaa)/T_Double(nbr_pages));
    Put_Line("Matrice G cree");
    
    --Remplacer les éléments du vecteur pi par le deuxième argument
    remplir_allVec(pi,1.0/T_Double(nbr_pages));
    Put_Line("Pi initialise");
    
    --calcul des itérations sur le vecteur pi
    indice := 1;
    while indice <= iteration_max loop
        affecter_vecteur(pi , prod_vecteur_matrice(M,pi) );
        indice := indice + 1;
    end loop;
    Put_Line("Pi calcule");
    
    --Création d'un vecteur V_indice qui contient les indices de 1 à nbr_pages
    Generer_Vecteur(V_indice);
    Trier_decroissant (pi , V_indice);
    Put_Line("Table de classement");
    
    --Création du fichier PageRank
    Create(page_rank,out_File,name =>"PageRank.org");
    close(page_rank);
    Open(page_rank, out_File, name => "PageRank.org");

    --Remplissage du fichier PageRank
    for i in 1..nbr_pages loop
        put ( page_rank , Integer(Element_vecteur(V_indice , i))-1 , 1);
        new_line (page_rank);
    end loop;
    close(page_rank);
    Put_Line ("fichier PageRank rempli");
    
    --Création du fichier Poids
    Create(weight,out_File,name =>"Poids.p");
    close(weight);
    Open(weight, out_File, name => "Poids.p");
    
    --Remplissage du fichier Poids
    put (weight , nbr_pages,1);
    put (weight , " ");
    put (weight , float(alphaa),1);
    put (weight , " ");
    put (weight , iteration_max, 1);
    new_line (weight);
    for i in 1..nbr_pages loop
        put ( weight , float(Element_vecteur(pi , i)),1);
        new_line (weight);
    end loop;
    close(weight);
    Put_Line ("fichier Poids rempli");
   end google_naive;

   procedure google_creuse is
       i, j, indice : integer;
       MH_creuse : T_Table_Colonne;
       liste_lignes, pii , terme_1, terme_2, terme_31, terme_32, Vector_indice : T_Vector;
   begin
        --Création de la matrice creuse MH_creuse sous forme d'un tableau d'une 
        --seule dimension et dont chaque élément est un chainage de pointeur
        --chaque pointeur pointe vers l'indice de la ligne dont au moin un élément
        --est non nul
        initialiser_tab(MH_creuse);
        --Création d'un tableau liste_lignes dans lequel on va stocker le nombre
        --d'élément non nulles d'une ligne donnée.
        initialiser_vec(liste_lignes);
        open (fich,In_File,To_String(nom_fich));
        Skip_Line(fich);
        while not End_Of_File(fich) loop
            get(fich ,  i);
            get(fich , j);
            ajouter_elem (MH_creuse , j+1 , i+1 );
            Additionner_ElemVec (liste_lignes , i+1 , 1.0);
            skip_line(fich);
        end loop;
        close (fich);
        Put_Line("matrice H creuse initialisée");
        
        --Création du vecteur pii des poids
        initialiser_vec(pii);
        for i in 1..nbr_pages loop
            enregistrer_vec(pii , i , 1.0/T_Double(nbr_pages));
        end loop;
        Put_Line("Vecteur pi initialisé");
        
        
        --Création de trois vecteurs qui représentent en réalité des termes
        --qui simplifient le calcul du produit vectoriel permettant de calculer
        --les itérations du vecteur pii. Le détail de ce calcul est présent
        --dans le rapport.
        initialiser_vec(terme_1);
        initialiser_vec(terme_2);
        initialiser_vec(terme_32);
        indice := 1;
        while indice <= iteration_max loop
        
            --Calcul du premier terme
            affectation_vecteur(terme_1 , pii);
            for i in 1..nbr_pages loop
                if element_a_emplacement(liste_lignes,i) = 0.0 then
                    remplir_ToutVec(terme_1 , (alphaa/T_Double(nbr_pages))*element_a_emplacement(terme_1,i));
                end if;
            end loop;

            --Calcul du deuxième terme
            remplir_ToutVec(terme_2 , ((1.0-alphaa)/T_Double(nbr_pages))*sommer_ElemVec(pii));

            --Calcul du troisième terme qui contient le produit entre la matrice H creuse et le vecteur pii 
            affectation_vecteur(terme_32 , pii);
            initialiser_vec(terme_31);
            for i in 1..nbr_pages loop
                 enregistrer_vec(terme_31 , i , prod_vecteur_vcreux ( terme_32 , case_table(MH_creuse , i) , alphaa , liste_lignes));
            end loop;

            --Vecteur résultat final de l'itération en cours
            affectation_vecteur( pii , somme_vector( terme_1 , somme_vector(terme_2 , terme_31)));
            put(indice);
            new_line;
            indice := indice + 1;

        end loop;
        Put_Line("Vecteur pi calculé");
        
        --Libération de la mémoire après avoir utilisé la matrice H creuse
        for i in 1..nbr_pages loop
            Vider(MH_creuse , i);
        end loop;

        --Création d'un tableau contenant les indices de 1 à nbr_pages
        generer_vec(Vector_indice);
        Trier_decroissant_vector (pii , Vector_indice);
        Put_Line("Table de classement");

        --Création du fichier PageRank
        Create(page_rank,out_File,name =>"PageRank.org");
        close(page_rank);
        Open(page_rank, out_File, name => "PageRank.org");

        --Remplissage du fichier PageRank
        for i in 1..nbr_pages loop
            put ( page_rank , Integer(element_a_emplacement(Vector_indice , i))-1 , 1);
            new_line (page_rank);
        end loop;
        close(page_rank);
        Put_Line ("fichier PageRank rempli");
        
        --Création du fichier Poids
        Create(weight,out_File,name =>"Poids.p");
        close(weight);
        Open(weight, out_File, name => "Poids.p");
        
        --Remplissage du fichier Poids
        put (weight , nbr_pages,1);
        put (weight , " ");
        put (weight , float(alphaa));
        put (weight , " ");
        put (weight , iteration_max, 1);
        new_line (weight);
        for i in 1..nbr_pages loop
            put ( weight , float(element_a_emplacement(pii , i)) , 1);
            new_line (weight);
        end loop;
        close(weight);
        Put_Line ("fichier Poids rempli");
   end google_creuse;

begin
    --Extraction des paramètres de la commande
    analyse_commande(modee, iteration_max, alphaa, nom_fich);
    nbr_pages := identifier_nbr_pages;
    
    --Entamer la procedure de calcul suivant le choix du mode
    if modee = 1.0 then
        google_naive;
    else
        google_creuse;
    end if;

Exception
    when Argument_I_Error => Put_Line("Le paramètre -I doit être un entier naturel non nul.");
    when Argument_A_Error => Put_Line("Le paramètre -A doit être un réel compris entre 0 et 1.");
    when No_File_Error => Put_Line("Pas de fichier ou nom de fichier erroné.");

end google;
