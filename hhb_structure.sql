CREATE TABLE Agence (
    num_agence INTEGER PRIMARY KEY,
    nom_agence TEXT NOT NULL,
    adresse_agence TEXT NOT NULL,
    tel_agence TEXT NOT NULL
);


CREATE TABLE Type_Compte (
    id_type INTEGER PRIMARY KEY,
    designation TEXT NOT NULL
);


CREATE TABLE Client (
    num_client INTEGER PRIMARY KEY,
    nom_client TEXT NOT NULL,
    prenom_client TEXT NOT NULL,
    adresse_client TEXT NOT NULL,
    identifiant_internet TEXT NOT NULL,
    mdp_internet TEXT NOT NULL,
    num_agence INTEGER NOT NULL,
    FOREIGN KEY (num_agence) REFERENCES Agence(num_agence)
);


CREATE TABLE Compte (
    num_compte INTEGER PRIMARY KEY,
    solde REAL NOT NULL,
    id_type INTEGER NOT NULL,
    num_client INTEGER NOT NULL,
    date_creation DATE NOT NULL,
    date_fermeture DATE,
    num_agence INTEGER NOT NULL,
    FOREIGN KEY (id_type) REFERENCES Type_Compte(id_type),
    FOREIGN KEY (num_client) REFERENCES Client(num_client),
    FOREIGN KEY (num_agence) REFERENCES Agence(num_agence),
    CHECK (date_fermeture IS NULL OR date_creation < date_fermeture)
);


CREATE TABLE Carte_Bancaire (
    num_carte INTEGER PRIMARY KEY,
    num_compte INTEGER NOT NULL,
    code_securite TEXT NOT NULL,
    date_delivrance DATE NOT NULL,
    organisme TEXT NOT NULL,
    est_active BOOLEAN NOT NULL,
    FOREIGN KEY (num_compte) REFERENCES Compte(num_compte),
    CHECK (est_active IN (0,1))
);


CREATE TABLE Chequier (
    num_chequier INTEGER PRIMARY KEY,
    num_compte INTEGER NOT NULL,
    date_delivrance DATE NOT NULL,
    num_premier_cheque INTEGER NOT NULL,
    num_dernier_cheque INTEGER NOT NULL,
    est_active BOOLEAN NOT NULL,
    a_ete_detruit BOOLEAN NOT NULL,
    FOREIGN KEY (num_compte) REFERENCES Compte(num_compte),
    CHECK (est_active IN (0,1)),
    CHECK (a_ete_detruit IN (0,1))
);


CREATE TABLE Operation (
    id_operation INTEGER PRIMARY KEY,
    designation TEXT NOT NULL,
    type_operation TEXT NOT NULL,
    montant REAL NOT NULL,
    num_compte INTEGER NOT NULL,
    num_carte INTEGER,
    num_cheque INTEGER,
    FOREIGN KEY (num_compte) REFERENCES Compte(num_compte),
    FOREIGN KEY (num_carte) REFERENCES Carte_Bancaire(num_carte),
    FOREIGN KEY (num_cheque) REFERENCES Chequier(num_cheque),
    CHECK (type_operation IN ('DEBIT', 'CREDIT', 'VIREMENT')),
    CHECK ((num_carte IS NULL AND num_cheque IS NULL) OR (num_carte IS NOT NULL AND num_cheque IS NULL) OR (num_carte IS NULL AND num_cheque IS NOT NULL))
);


CREATE TABLE Cheque (
    num_cheque INTEGER PRIMARY KEY,
    num_chequier INTEGER NOT NULL,
    date_emission DATE NOT NULL,
    FOREIGN KEY (num_chequier) REFERENCES Chequier(num_chequier)
);
