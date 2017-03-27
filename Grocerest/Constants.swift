//
//  Constants.swift
//  Grocerest
//
//  Created by Hugo Adolfo Perez Solorzano on 30/10/15.
//  Copyright © 2015 grocerest. All rights reserved.
//

import Foundation
import UIKit

struct Constants {

    /**
     *  TODO: Colors for Categories
     */


    struct UserMessages {

        static let loginAutomatic = "Login automatico…"

        static let listNoLongerExist = "Spiacenti questa lista non esiste più"
        /// Altri prodotti in arrivo
        static let moreProductsToCome = "Altri prodotti in arrivo"

        /// Nome del Prodotto non puo essere vuoto
        static let noEmptyProductName = "Il nome del prodotto deve essere composto da almeno 2 caratteri"


        /// Il nome della lista non puo essere vuoto

        static let noEmptyListName = "Il nome de la lista non può essere vuoto"

        /// Attenzione
        static let warning = "Attenzione"

        /// La lista verrà eliminata definitivamente
        static let  listDeletion = "Vuoi eliminare definitivamente questa lista?"

        /// ok
        static let ok = "ok"

        /// anulla
        static let anulla = "annulla"

        /// Errore di sistema, riprova più tardi
        static let systemError = "Errore di sistema, riprova più tardi"

        /// Vuoi resettare questa lista?
        static let listReset = "Vuoi resettare questa lista?"

        /// Vuoi duplicare questa lista?

        static let listDuplication = "Vuoi duplicare questa lista?"
    }



    struct ReviewLabels {
        /// Aggiorna la tua recensione
        static let updateReview = "Aggiorna la tua recensione"

        /// Completa la tua recensione
        static let completeReview = "Completa la tua recensione"

        /// Salva la recensione
        static let saveReview = "Salva la recensione"

        /// Cosa ne pensi di questo prodotto?
        static let yourOpinion = "Cosa ne pensi di questo prodotto?"

        /// Aggiorna la recensione
        static let updateReviewButtonLabel = "Aggiorna la recensione"

        /// "Vuoi eliminare questa recensione?"
        static let wantToDeleteReview = "Vuoi eliminare questa recensione?"

        /// "scansiona il codice a barre"
        static let scanBarcodeLegend = "scansiona il codice a barre"

        /// "codice a barre scansionato"
        static let barcodeScanned = "codice a barre scansionato"



    }


    struct FrequencyLabels {
        static let first = "first time"
        static let rarely = "rarely"
        static let once = "once a month"
        static let weekly = "weekly"
        static let every = "every day"
    }



    struct PredefinedUserList {

        static let favourites = "favourites"
        static let hated = "hated"
        static let totry = "totry"
        static let scanned = "scanned"
        static let reviewed = "reviewed"


    }

    struct PredefinedUserListDisplayVersion {
        static let favourites = "Preferiti"
        static let hated = "Da Evitare"
        static let totry = "Da Provare"
        static let scanned = "Scansioni"
        static let reviewed = "Recensiti"
    }

    struct GoogleKeys {
        static let searchFilters = "grocery_or_supermarket|liquor_store|pet_store|shopping_mall"
        static let googleKey = "AIzaSyCfJlTLiBiHYecHdXPnOndipcLNecGEzPQ"
        static let googleRoute = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
        static let geocodeRoute = "https://maps.googleapis.com/maps/api/geocode/json?address="
    }



    static let dateFormat = "yyyy-MM-dd"

    static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

    struct Endpoints {
        static let getUser = "user"

    }

    struct BrandLabels {
        static let grocerestBrandLabel = "Grocerest"
        static let reputationBrandLabel = "good reputation"
    }

    struct AppLabels {

        struct StatsLabels {
            static let statsLabel = "Statistiche"
        }

        /// Add Product
        static let aggiungiProdotto = "Aggiungi Prodotto"

        /// Contacts Access
        static let warningToAccessContacts = "Per poter invitare gli amici è necessario consentire l'accesso ai Contatti dal menu Impostazioni - Grocerest del tuo iPhone"

        /// Location Access
        static let warningToAccessLocation = "Per poter accedere è necessario consentire l'accesso ala tua posizione dal menu Impostazioni - Grocerest del tuo iPhone"

        /// Gestisci Lista
        static let manageList = "Gestisci lista"

        /// Gestisci Partecipanti
        static let manageCollaborators = "Gestisci partecipanti"

        /// Aggiungi Partecipanti
        static let addCollaborators = "Aggiungi partecipanti"

        /// Dimenticato nome utente o password?
        static let accessDataForgotten = "Dimenticato nome utente o password?"
        /// Privacy Policy"
        static let privacyPolicy = "Privacy Policy"
        /// Facebook
        static let facebookLabel = "Facebook"
        /// OK
        static let okLabel = "OK"
        /// Logout
        static let logoutLabel = "Esci"
        /// Riprova
        static let retryLabel = "Riprova"
        /// Scarica
        static let downloadLabel = "Scarica"
        /// Registrati
        static let registrationLabel = "Registrati"
        /// Accedi
        static let accessLabel = "Accedi"
        /// Hai già un account?
        static let hasAccount = "Hai già un account?"
        /// Nome
        static let namePlaceHolder = "Nome"
        /// Cognome
        static let lastNamePlaceHolder = "Cognome"
        /// Nickname
        static let nicknamePlaceHolder = "username"
        /// Email
        static let emailPlaceHolder = "Email"
        /// Password
        static let passwordPlaceHolder = "Password"
        /// Accetto i Termini di servizio
        static let acceptTermsOfService = "Accetto i Termini di servizio"
        /// Iscrivimi alla newsletter
        static let acceptNewsletter = "Voglio essere informato su promozioni,\ninziative, novità"
        /// Quali sono le tue categorie preferite?
        static let selectFavoriteCategories = "A quali categorie sei più interessato?"
        /// Add all
        static let addAll = "Add all"
        /// Select 3 categories
        static let selectSomeCategories = "Seleziona 3 Categorie"
        /// Top review label = Recensici
        static let topReviewLabelText = "Prodotti in evidenza"
        /// Latest mofified lists
        static let lastModifiedLists = "Liste della spesa"
        /// Invite Friends
        static let inviteFriendsLabel = "Invita Amici"
        /// Recensioni da completare
        static let daCompletare = "Recensioni da completare"
        /// Esplora le categorie
        static let esploraCategorie = "Esplora le categorie"
        /// Cosa ne pensi?
        static let voteLabel1 = "cosa ne pensi? "
        /// tocca per votare
        static let voteLabel2 = "tocca per votare"
        /// frequency -> quanto spesso usi il prodotto?
        static let frequencyLabel = "quanto spesso usi il prodotto? "
        /// primaVolta
        static let freqFirstTime = "PRIMA VOLTA"
        /// raramente
        static let freqRarely = "RARAMENTE"
        /// una volta al mese
        static let freqMontly = "1 VOLTA AL MESE"
        /// una volta a settimana
        static let freqWeakly = "1 VOLTA A SETTIMANA"
        /// tutti i giorni
        static let freqDaily = "TUTTI I GIORNI"
        /// completa la tua recensione
        static let completeReviewLabel = "se vuoi altri 4 punti reputation"
        /// scrivi un commento
        static let writeACommentButton = "SCRIVI UN COMMENTO"
        /// scrivi una recensione
        static let writeAReview = "Scrivi un commento"
        /// tocca per modificare commento
        static let modifyReview = "tocca per modificare commento"
        /// Invita i tuoi Amici
        static let inviteYourFriends = "INVITA I TUOI AMICI"
        /// Sai che puoi condividere ..
        static let inviteYourFriendsText = "Fai crescere la Community\n e guadagna punti Reputation"
        /// Aggiungi prodott
        static let addProducts = "Cerca Prodotto"
        ///Livello Grocerest
        static let grocerestLevel = "Esperienza"
        // Reputation
        static let reputation = "Reputation"
        // Esperto hardcoded
        static let harcodedEsperto = "Esperto"


        struct MenuLabels {
            /// Home
            static let menuHome = "Home"
            /// Le mie liste
            static let menuLists = "Le mie liste"
            /// Prodotti
            static let menuProducts = "Prodotti"
            /// Trova Shop
            static let menuShops = "Trova Shop"
            /// Utenti
            static let menuUsers = "Utenti"
            /// Impostazioni
            static let menuSettings = "Assistenza"
            /// Help
            static let menuHelp = "Simboli"
            /// LOG OUT
            static let menuLogout = "LOG OUT"
        }

        struct ListLabels {
            /// New List
            static let createnNewList = "Crea una nuova lista"
            /// fake list 1
            static let listMainOne = "Lista festa di Federica"
            /// fake list 2
            static let listMainTwo = "Spesa per Ferragosto"
        }

        struct ToolBarLabels {
            /// Le mie liste
            static let myLists = "Le mie liste"
            /// Crea una lista
            static let createAList = "Crea una lista"
        }

    }

    struct BrandFonts {
        // sizes are referred to the mockup which is based on iphone 6
        // iphone 6 has a width of 750px (375 dp)
        // therefore we can scale most font proportionally based on that

        static let baseWidth:CGFloat = 375.0
        static let currentWidth:CGFloat = UIScreen.main.bounds.width * 1.0
        static let scale:CGFloat = currentWidth / baseWidth;

        /// Avenir size: 11
        static let verySmallLabelFontA = UIFont(name: "Avenir", size: 22.00 / masterRatio)
        /// Avenir size: 13
        static let smallLabelFontA = UIFont(name: "Avenir", size: 26.00 / masterRatio)
        /// Avenir size: 15
        static let mediumLabelFontA = UIFont(name: "Avenir", size: 30.00 / masterRatio)
        /// Avenir - Book 15
        static let avenirBookFont = UIFont(name: "Avenir-Book", size: 30.00 / masterRatio)
        /// Avenir - Light 13.5
        static let avenirLight13 = UIFont(name: "Avenir-Light", size: 27.00 / masterRatio)
        /// Avenir - Light 15
        static let avenirLight15 = UIFont(name: "Avenir-Light", size: 30.00 / masterRatio)
        /// Avenir - Light 16
        static let avenirLight16 = UIFont(name: "Avenir-Light", size: 32.00 / masterRatio)
        /// Avenir - Light 30
        static let avenirLight30 = UIFont(name: "Avenir-Light", size: 60.00 / masterRatio)
        /// Avenir - Light 20
        static let avenirLight20 = UIFont(name: "Avenir-Light", size: 40.00 / masterRatio)
        /// Avenir - Book 12
        static let avenirBook12 = UIFont(name: "Avenir-Book", size: 24.00 / masterRatio)
        /// Avenir - Roman 12
        static let avenirRoman12 = UIFont(name: "Avenir-Roman", size: 24.00 / masterRatio)
        /// Avenir - Roman 13
        static let avenirRoman13 = UIFont(name: "Avenir-Roman", size: 26 / masterRatio)
        /// Avenir - Roman 15
        static let avenirRoman15 = UIFont(name: "Avenir-Roman", size: 30.00 / masterRatio)
        /// Avenir - Roman 16
        static let avenirRoman16 = UIFont(name: "Avenir-Roman", size: 32.00 / masterRatio)
        /// Avenir - Book 11
        static let avenirBook11 = UIFont(name: "Avenir-Book", size: 22.00 / masterRatio)
        /// Avenir Heavy 10
        static let avenirHeavy10 = UIFont(name: "Avenir-Heavy", size: 20.00 / masterRatio)
        /// Avenir - Heavy 12
        static let avenirHeavy12 = UIFont(name: "Avenir-Heavy", size: 24.00 / masterRatio)

        /// Avenir - Heavy 15
        static let avenirHeavy15 = UIFont(name: "Avenir-Heavy", size: 30.00 / masterRatio)



        /// Avenir - Book 20
        static let avenirBook10 = UIFont(name: "Avenir-Book", size: 20.00 / masterRatio)
        /// AVenir - Book 15
        static let avenirBook15 = UIFont(name: "Avenir-Book", size: 30.00 / masterRatio)
        /// Avenir Medium 10
        static let avenirMedium10 = UIFont(name: "Avenir-Medium", size: 20.00 / masterRatio)
        /// Avenir Medium 11
        static let avenirMedium11 = UIFont(name: "Avenir-Medium", size: 22.00 / masterRatio)
        /// Avenir Medium 26
        static let avenirMedium13 = UIFont(name: "Avenir-Medium", size: 26.00 / masterRatio)
        /// Avenir Medium 15
        static let avenirMedium15 = UIFont(name: "Avenir-Medium", size: 30.00 / masterRatio)
        /// Avenir Medium 20
        static let avenirMedium20 = UIFont(name: "Avenir-Medium", size: 40.00 / masterRatio)
        /// Ubuntu light - 18
        static let ubuntuLight18 = UIFont(name: "Ubuntu-Light", size: 36.00 / masterRatio)
        /// Ubuntu medium 16
        static let ubuntuMedium16 = UIFont(name: "Ubuntu-Medium", size: 32.00 / masterRatio)
        /// Ubuntu medium 15
        static let ubuntuMedium15 = UIFont(name: "Ubuntu-Medium", size: 30.00 / masterRatio)

        /// Ubuntu medium 14
        static let ubuntuMedium14 = UIFont(name: "Ubuntu-Medium", size: 28.00 / masterRatio)

        /// Avenir Heavy 11
        static let avenirHeavy11 = UIFont(name: "Avenir-Heavy", size: 22.00 / masterRatio)
        /// Ubuntu Medium 20
        static let ubuntuMedium20 = UIFont(name: "Ubuntu-Medium", size: 40.00 / masterRatio)
        /// Ubuntu Medium 18
        static let ubuntuMedium18 = UIFont(name: "Ubuntu-Medium", size: 36.00 / masterRatio)
        /// Ubuntu Regular 16
        static let ubuntuRegular16 = UIFont(name: "Ubuntu", size: 32.00 / masterRatio)

        /// Ubuntu - Bold 11
        static let ubuntuBold11 = UIFont(name: "Ubuntu-Bold", size: 22.00 / masterRatio)

        /// Ubuntu - Bold 14
        static let ubuntuBold14 = UIFont(name: "Ubuntu-Bold", size: 28.00 / masterRatio)

        /// Ubuntu - Bold 15
        static let ubuntuBold15 = UIFont(name: "Ubuntu-Bold", size: 30.00 / masterRatio)

        /// Ubuntu - Bold 18
        static let ubuntuBold18 = UIFont(name: "Ubuntu-Bold", size: 36.00 / masterRatio)

        /// Ubuntu - Bold 28
        static let ubuntuBold28 = UIFont(name: "Ubuntu-Bold", size: 56.00 / masterRatio)

        /// Ubuntu - Bold 38
        static let ubuntuBold38 = UIFont(name: "Ubuntu-Bold", size: 76 / masterRatio)


    }

    struct BrandAssetsSizes {
        /// Logo size: w:113.055 h:101.75
        static let logoSize = CGSize(width: 226.11 / masterRatio, height: 203.5 / masterRatio)


    }

    struct UISizes {
        /// Big button size - w:225.00 h:41.50
        static let bigButtonSize = CGSize(width: 450.00 / masterRatio, height: 83.50 / masterRatio)
        /// barHeight - h:50
        static let standardBarHeight = 100 / masterRatio
        /// Standard uiTextField - w:171 h:19
        static let uitextFieldSize = CGSize(width: 342 / masterRatio , height: 38 / masterRatio)
        /// Cell standardRowHeigth h: 75
        static let grocerestStandardHeightCell = 150 / masterRatio as CGFloat
        /// Vote Button Size
        static let voteButtonSize = CGSize(width: 86 / masterRatio, height: 86 / masterRatio)
        /// small size vote Button
        static let smallVoteButtonSize = CGSize(width: 43 / masterRatio, height: 43 / masterRatio)

        /// Commented IconSize 44.5
        static let commentedIconSize = CGSize(width: 89 / masterRatio, height: 89 / masterRatio)
        /// reviewCommentBox w: 237 h: 45
        static let reviewCommentBox = CGSize(width: 474 / masterRatio, height: 104 / masterRatio)
        /// menu icon size
        static let menuIconSize = CGSize(width: 52 / masterRatio, height: 52 / masterRatio)
        /// List Icon 87/2
        static let listIconSize = CGSize(width: 87 / masterRatio, height: 87 / masterRatio)
        /// standard disclosure icon
        static let disclosureIcon = CGSize(width: 16 / masterRatio, height: 30 / masterRatio)
        /// badge size
        static let badgeIcon = CGSize(width: 30.00 / masterRatio, height: 30.00 / masterRatio)
    }

    struct Categories {
        static let alimentari = "Alimentari "
        static let bevande = "Bevande "
        static let prodottiPerLaCasa = "Prodotti per la casa"
        static let curaDellaPersona = "Cura della persona"
        static let infanzia = "Infanzia "
        static let prodottiPerAnimali = "Prodotti per animali"
        static let integratoriEDietetiti = "Integratori e dietetici"
        static let cancelleria = "Cancelleria "
        static let giocattoli = "Giocattoli "
        static let libri = "Libri "
    }

    struct CategoryIcons {
        static let alimentari = "icon_alimentari"
        static let bevande = "icon_bevande"
        static let prodottiPerLaCasa = "icon_prodotti_per_la_casa"
        static let curaDellaPersona = "icon_cura_della_persona"
        static let infanzia = "icon_infanzia"
        static let prodottiPerAnimali = "icon_prodotti_per_animali"
        static let integratoriEDietetiti = "icon_integratori_e_dietetici"
        static let cancelleria = "icon_cancelleria"
        static let giocattoli = "icon_giocattoli"
        static let libri = "icon_libri"

    }

    struct SelectCategories {
        static let alimentari = "select_alimentari"
        static let bevande = "select_bevande"
        static let prodottiPerLaCasa = "select_prodotti_per_la_casa"
        static let curaDellaPersona = "select_cura_persona"
        static let infanzia = "select_infanzia"
        static let prodottiPerAnimali = "select_prodotti_animali"
        static let integratoriEDietetiti = "select_integratori"
        static let cancelleria = "select_cancelleria"
        static let giocattoli = "select_giocattoli"
        static let libri = "select_libri"

    }

    struct SelectedCategories {
        static let alimentari = "selected_alimentari"
        static let bevande = "selected_bevande"
        static let prodottiPerLaCasa = "selected_prodotti_per_la_casa"
        static let curaDellaPersona = "selected_cura_persona"
        static let infanzia = "selected_infanzia"
        static let prodottiPerAnimali = "selected_prodotti_animali"
        static let integratoriEDietetiti = "selected_integratori"
        static let cancelleria = "selected_cancelleria"
        static let giocattoli = "selected_giocattoli"
        static let libri = "selected_libri"

    }

    struct HarcodedStrings {
        /// Fake comment
        static let fakeComment = "Ottima brillantezza per i miei piatti che oggi splendono davvero più che mai! Il suo profumo evoca le spiagge del lontano Oriente e le ..."
        ///Fake userName
        static let userNameSample = "Mario Mari"


        struct Products {
            static let prodotti = ["Chinotto Lurisia", "Aranciata San Pellegrino",
            "Sapone Artigianale della Riviera", "Acqua Minerale San Benedetto", "Chinotto Gianni", "Red wine", "Some nice soap"]
        }
    }

    struct RegistrationFieldNames {
        static let name = "firstname"
        static let lastName = "lastname"
        static let nickName = "username"
        static let email = "email"
        static let password = "password"
        static let termsOfUse = "termsOfUse"
        static let newsletter = "newsletter"

    }


}
