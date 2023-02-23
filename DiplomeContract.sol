// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract DiplomeContract {
  address private owner;

  struct Etablisement {
      string Nom;
      string Type;
      string Pays;
      string Adresse;
      string SiteWeb;
      uint256 AgentId;
  }

  struct Etudiant {
    string Nom;
    string Prenom;
    uint256 DateDeNaissance;
    string Sexe;
    string Nationalite;
    string StatutCivil;
    string Adresse;
    string Courriel;
    string Telephone;
    string Section;
    string SujetPfe;
    string EntrepriseStagePfe;
    string NomEtPrenomMaitreDuStage;
    uint256 DateDebutStage;
    uint256 DateFinStage;
    string Evaluation;
  }

  struct Diplome {
      uint256 EtudiantId;
      string NomEtablissement;
      uint256 EtablissementId;
      string Pays;
      string Type;
      string Specialite;
      string Mention;
      uint256 DateObtention;
  }

  struct Entreprise {
      string Nom;
      string Secteur;
      uint256 DateCreation;
      string Taille;
      string Pays;
      string Adresse;
      string Courriel;
      string Telephone;
      string SiteWeb;
  }

  mapping(uint256 => Etablisement) public Etablisements;
  mapping(address => uint256) AddressAgents;
  mapping(uint256 => Diplome) public Diplomes;
  mapping(uint256 => Entreprise) public Entreprises;
  mapping(address => uint256) public AddressEntreprises;
  mapping(uint256 => Etudiant) Etudiants;

  uint256 public NbAgents;
  uint256 public NbDiplomes;
  uint256 public NbEntreprises;
  uint256 public NbEtudiants;

  constructor() {
      owner = msg.sender;
      NbAgents = 0;
      NbEntreprises = 0;
      NbDiplomes = 0;
  }
    
  // Un agent d’un établissement d’enseignement supérieur peut créer un compte pour
  // son établissement qui va servir à enregistrer les jeunes diplômés et leurs diplômes.
  function create_etablissement_account(string memory nom, string memory pays, string memory typeEtablissement, string memory adresse, string memory siteWeb) public {
      Etablisement memory e;
      e.Nom = nom;
      e.Pays = pays;
      e.Adresse = adresse;
      e.SiteWeb = siteWeb;
      e.Type = typeEtablissement;
      NbAgents += 1;
      e.AgentId = NbAgents;
      AddressAgents[msg.sender] = e.AgentId;
      Etablisements[e.AgentId] = e;
  }

    /**Un agent d’un établissement d’enseignement supérieur peut créer et sauvegarder
    un profil pour un étudiant lorsque ce dernier commence son stage de fin d’étude.
    - Un agent d’un établissement d’enseignement supérieur peut ajouter un diplôme et mettre à jour les informations de son titulaire.
    **/
    function ceate_student_onStage(Etudiant memory e) private {
        NbEtudiants += 1;
        Etudiants[NbEtudiants] = e;
    }
        
    function update_student(Diplome memory d)private{
        NbDiplomes += 1;
        Diplomes[NbDiplomes] = d;
    }

    // Un agent de recrutement peut créer un compte pour son entreprise.
    function create_entreprise_account(Entreprise memory e, address a) public {
        NbEntreprises += 1;
        Entreprises[NbEntreprises] = e;
        AddressEntreprises[a] = NbEntreprises;
    }

}
