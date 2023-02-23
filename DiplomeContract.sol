// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract DiplomeContract{

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
  mapping(address => uint256) AddressEtablisements;

  uint256 public NbEtablisements;

  // Un agent d’un établissement d’enseignement supérieur peut créer un compte pour
  // son établissement qui va servir à enregistrer les jeunes diplômés et leurs diplômes.
  function create_etablissement_account(Etablisement memory e, address a) private {
      NbEtablisements += 1;
      Etablisements[NbEtablisements] = e;
      AddressEtablisements[a] = NbEtablisements;
  }

  function create_student_onStage(Etudiant memory e) private {
        e.exist = true;
        NbEtudiants += 1;
        Etudiants[NbEtudiants] = e;
    }

}
