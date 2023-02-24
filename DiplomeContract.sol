// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "./Token.sol";

contract DiplomeContract {
    address private owner;
    address private token;

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
        uint256 IdEtablisement;
        uint256 IdEntreprise;
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

    mapping(address => uint256) AddressAgents;
    mapping(uint256 => Etablisement) public Etablisements;

    mapping(uint256 => Etudiant) Etudiants;

    mapping(uint256 => Diplome) public Diplomes;

    mapping(uint256 => Entreprise) public Entreprises;
    mapping(address => uint256) public AddressEntreprises;


    uint256 public NbAgents;
    uint256 public NbDiplomes;
    uint256 public NbEntreprises;
    uint256 public NbEtudiants;

    constructor(address tokenaddress) {
        token = tokenaddress;
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

    function evaluate_student(        
        uint256 etudiantid,
        string memory sujetPfe,
        string memory entrepriseStagePfe,
        string memory nomEtPrenomMaitreDuStage,
        uint256 dateDebutStage,
        uint256 dateFinStage,
        string memory evaluation
    ) public {

        uint256 id = AddressEntreprises[msg.sender];
        require(Etudiants[etudiantid].IdEntreprise == id, "Etudient non rattache a l'entreprise");
        Etudiants[etudiantid].SujetPfe = sujetPfe;
        Etudiants[etudiantid].EntrepriseStagePfe = entrepriseStagePfe;
        Etudiants[etudiantid].NomEtPrenomMaitreDuStage = nomEtPrenomMaitreDuStage;
        Etudiants[etudiantid].DateDebutStage = dateDebutStage;
        Etudiants[etudiantid].DateFinStage = dateFinStage;
        Etudiants[etudiantid].Evaluation = evaluation;

        require(
            Token(token).allowance(owner, address(this)) >= 15,
            "Erreur transaction non valide"
        );

        require(
            Token(token).transferFrom(owner, msg.sender, 15),
            "Erreur transaction"
        );
    }

    /**Un agent d’un établissement d’enseignement supérieur peut créer et sauvegarder
    un profil pour un étudiant lorsque ce dernier commence son stage de fin d’étude.
    - Un agent d’un établissement d’enseignement supérieur peut ajouter un diplôme et mettre à jour les informations de son titulaire.
    **/
    function ceate_student_onStage(
        string memory nom,
        string memory prenom
    ) public {

        uint256 id = AddressAgents[msg.sender];
        require(id != 0, "not etablisement");

        // I reduce the number of data
        // else I could get an error "stack to deep"
        Etudiant memory e;
        e.Nom = nom;
        e.Prenom = prenom;

        NbEtudiants += 1;
        Etudiants[NbEtudiants] = e;
    }

    // Un agent de recrutement peut créer un compte pour son entreprise.
    function create_entreprise_account(
        string memory nom, 
        string memory secteur, 
        uint256 dateCreation, 
        string memory taille, 
        string memory pays, 
        string memory adresse, 
        string memory courriel, 
        string memory telephone,
        string memory siteWeb) public {

            Entreprise memory e;
            e.Nom = nom;
            e.Secteur = secteur;
            e.DateCreation = dateCreation;
            e.Taille = taille;
            e.Pays = pays;
            e.Adresse = adresse;
            e.Courriel = courriel;
            e.Telephone = telephone;
            e.SiteWeb = siteWeb;

            NbEntreprises += 1;
            Entreprises[NbEntreprises] = e;
            AddressEntreprises[msg.sender] = NbEntreprises;
    }

    function add_diplome (
        uint256 idTitulaire, 
        string memory nomEtablisement, 
        uint256 idEtablisement, 
        string memory mention, 
        uint256 dateObtention) public {
            require(AddressAgents[msg.sender] == idEtablisement, "Pas autorise a creer un diplome pour l'etablissement");
            Etudiant memory etud = Etudiants[idTitulaire];
            require(etud.IdEtablisement == idEtablisement, "L'etudiant ne fait pas partie de l'etablissement");
            Diplome memory d;
            d.EtudiantId = idTitulaire;
            d.NomEtablissement = nomEtablisement;
            d.EtablissementId = idEtablisement;
            d.Mention = mention;
            d.DateObtention = dateObtention;
    }

}
