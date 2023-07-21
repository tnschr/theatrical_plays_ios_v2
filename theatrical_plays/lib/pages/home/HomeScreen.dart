import 'package:flutter/material.dart';
import 'package:theatrical_plays/models/Actor.dart';
import 'package:theatrical_plays/models/Movie.dart';
import 'package:theatrical_plays/models/Theater.dart';
import 'package:theatrical_plays/pages/Home.dart';
import 'package:theatrical_plays/pages/actors/ActorInfo.dart';
import 'package:theatrical_plays/pages/movies/MovieInfo.dart';
import 'package:theatrical_plays/pages/theaters/TheaterInfo.dart';
import 'package:theatrical_plays/using/MyColors.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  List<Movie> homeMovies = [];
  List<Actor> homeActors = [];
  List<Theater> homeTheaters = [];
  HomeScreen(this.homeMovies, this.homeActors, this.homeTheaters);
  @override
  _HomeScreenState createState() => _HomeScreenState(
      homeMovies: homeMovies,
      homeActors: homeActors,
      homeTheaters: homeTheaters);
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie>? homeMovies = [];
  List<Actor>? homeActors = [];
  List<Theater>? homeTheaters = [];
  _HomeScreenState({this.homeMovies, this.homeActors, this.homeTheaters});
  List<Actor> homescreenActors = [
    Actor('https://image.tmdb.org/t/p/w300/nv5TR9NiELEGPJUQqVLEqZzcGZb.jpg',
        6911, 'Γιώργος Καραμίχος'),
    Actor('https://image.tmdb.org/t/p/w300/mR3QlGx3y68uVZriNzoOLOnwPy.jpg',
        5044, 'Γιώργος Νινιός'),
    Actor('https://image.tmdb.org/t/p/w300/oiectxNJB7ctBwRKY45ChonEbjw.jpg',
        7544, 'Γιώργος Παπαγεωργίου')
  ];
  List<Movie> homescreenMovies = [
    Movie(
        509,
        'Το δικό μας Σινεμά',
        null,
        'ΑΛΣΟΣ ΠΕΔΙΟΝ ΤΟΥ ΑΡΕΩΣ Ι.Κ.Ε',
        'https://www.viva.gr/tickets/getattachment/d8b548e8-490c-488f-9939-afd8ed7e821c/%ce%a4%ce%9f-%ce%94%ce%99%ce%9a%ce%9f-%ce%9c%ce%91%ce%a3-%ce%a3%ce%99%ce%9d%ce%95%ce%9c%ce%91---Online-Streaminfc370b491-a9e4.png',
        null,
        "Το θεατρικό μιούζικαλ, με ρεκόρ εισιτήριων, των Θανάση Παπαθανασίου και Μιχάλη Ρέππα σε μια παράσταση πρωταγωνιστών, που σκηνοθετούν ο Θανάσης Παπαθανασίου, ο Μιχάλης Ρέππας και ο Φωκάς Ευαγγελινός.\\n \\nΣΑΒΒΑΤΟ 30/1 ΚΑΙ ΚΥΡΙΑΚΗ 31/1/2021 & extra παράσταση λόγω μεγάλης ζήτησης ΔΕΥΤΕΡΑ 1/2\\nΗ παράσταση της χρόνιας, με πάνω από 8Ο παραστάσεις και 150.000 θεατές!!!\\n17 υπέροχοι ηθοποιοί, 37 τραγούδια με 12μελή ζωντανή ορχήστρα, 24μελές μπαλέτο & 1.000 κοστούμια επί σκηνής και 300 περούκες!\\n \\nΈπειτα από την τεράστια αγκαλιά, χιλιάδων θεατών όλων των ηλικιών, το καλοκαίρι του 2019, η υπέρ-παραγωγή, “Το δικό μας σινεμά”, το θεατρικό μιούζικαλ με την υπογραφή του συγγραφικού δίδυμου των μεγάλων επιτυχιών Θανάση Παπαθανασίου και Μιχάλη Ρέππα και τις ευφάνταστες χορογραφίες του Φωκά Ευαγγελινού, έρχεται, για πρώτη φορά, μέσω online streaming*, από το ιστορικό Θέατρο Άλσος, στις οθόνες σας!\\nΗ πολυσυζητημένη παράσταση, που άφησε εποχή, ζωντανεύει - διαδικτυακά αυτή τη φορά - για να ζήσετε, από την άνεση του σπιτιού σας, την μαγεία του παλιού Ελληνικού κινηματογράφου, μέσα από τα studio της Φίνος Φιλμ!\\nΟ Σπύρος Παπαδόπουλος, η Δέσποινα Βανδή, ο Παύλος Χαϊκάλης, ο Κώστας Κόκλας, η Κατερίνα Λέχου, ο Μέμος Μπεγνής, ο Γιώργος Χρανιώτης, η Σύλβια Δελικούρα, η Παρθένα Χοροζίδου, η Ευγενία Σαμαρά, η Μαριλού Κατσαφάδου, η Μαριαλένα Ροζάκη, ο Γιώργος Τσούρμας, ο Γιάννης Ρούσος, ο Δημήτρης Γαλάνης και σε ξεχωριστούς ρόλους η Πηνελόπη Πιτσούλη, η Ελένη Γερασιμίδου και ο Γιώργος Κωνσταντίνου είναι έτοιμοι να δώσουν άλλη διάσταση στα βράδια σας, στις 30 & 31/1/2021, από την μεγάλη σκηνή του πιο εμβληματικού θερινού θεάτρου της Αθήνας.\\nΕξαιρετικές ερμηνείες, υπέροχα τραγούδια, χορός και 1.000 κοστούμια, μέσα σε ένα ευφάνταστο σκηνικό, με υψηλής ποιότητας υπηρεσίες στον ήχο και φώτα τελευταίας τεχνολογίας, δίνουν το στίγμα της παράστασης.\\n“Το δικό μας σινεμά”, είναι η ιστορία κάποιων καλλιτεχνών που ξεκινάνε περίπου το 1955 όταν πια αρχίζει η μεγάλη άνοδος του κινηματογράφου, ζουν την μεγάλη δόξα της δεκαετίας του '60 και ακολουθούν την πτώση του σινεμά στη δεκαετία του '70.\\nΜε νοσταλγία, χιούμορ, τρυφερότητα αλλά και συγκίνηση μας θυμίζουν μια εποχή που έχουμε αγαπήσει και συνεχίζουμε να αγαπάμε. “Το δικό μας σινεμά” είναι ένα ταξίδι στη χρυσή εποχή του παλιού καλού ελληνικού κινηματογράφου.\\n“Το δικό μας σινεμά”, με χαρακτήρες και τραγούδια αγαπημένα, μεγάλες επιτυχίες που έχουν γραφτεί στην ψυχή και τη μνήμη μας, περιδιαβαίνει τα χρόνια της μεγάλης ανόδου, της ακμής και της παρακμής του ελληνικού κινηματογράφου μέσα από τις ζωές κάποιων πρωταγωνιστών του κινηματογράφου.\\nΜια παραγωγή του MK GROUP, των Ηλία Μαροσούλη και Άγγελου Κοταρίδη.\\n*H κινηματογράφηση έχει γίνει εν ώρα παράστασης από κάμερες υψηλής ποιότητας σε ανάλυση full hd και με τον φυσικό ήχο της παράστασης, δημιουργώντας μία εμπειρία θέασης at-home για κινητά, tablets,  υπολογιστές και smart TV.\\n \\nINFO:\\nONLINE STREAMING - Θέατρο ΑΛΣΟΣ\\nΗμερομηνία: Σάββατο 30/1 & Κυριακή 31/1/21\\nΔιάρκεια παράστασης: 2μιση ώρες\\nΤιμή εισιτήριου: 15 € \\n \\nΛίγα λόγια για το έργο …\\nO Πέτρος (Σπύρος Παπαδόπουλος) είναι πρωταγωνιστής του θεάτρου και κάνει τις πρώτες του ταινίες στη δεκαετία του ’50. Είναι παντρεμένος με την Μιράντα (Κατερίνα Λέχου) η οποία είναι σταρ του θεάτρου και περιφρονεί το σινεμά αλλά κάνει και κάποιες ταινίες για να βγάζει χρήματα. Η Μιράντα  έχει μια κόρη από τον προηγούμενο γάμο της, την Δανάη (Ευγενία Σαμαρά).\\nΗ Μαίρη (Δέσποινα Βανδή) είναι μια πετυχημένη τραγουδίστρια που στην δεκαετία του '50 κάνει ρόλους σε ταινίες του άντρα της, Γιώργου (Κώστας Κόκλας) που είναι σεναριογράφος και σκηνοθέτης.\\nΌταν ο Πέτρος και η Μαίρη συνεργάζονται για πρώτη φορά σε μια ταινία του Γιώργου αρχίζει μια ιστορία με έρωτες, ανταγωνισμούς, φιλοδοξίες και διαψεύσεις.\\nΗ ιστορία αυτή κρατάει μέχρι το ΄77 την χρονιά που πεθαίνει ο Φιλοποίμενας Φίνος και στην ουσία λήγει η ιστορία του παλιού ελληνικού κινηματογράφου. Γύρω από αυτά τα τέσσερα πρόσωπα περιστρέφεται ένας ολόκληρος κόσμος από καλλιτέχνες που ζουν και εργάζονται στα στούντιο της Φίνος Φιλμ.\\nΟ Χρόνης (Παύλος Χαικάλης) είναι ο χορογράφος των επιτυχιών της εποχής.\\nΗ Ζωγραφούλα (Ελένη Γερασιμίδου) είναι η μητέρα του Πέτρου.\\nΟ Κώστας (Γιώργος Κωνσταντίνου) και η Δέσπω (Πηνελόπη Πιτσούλη) είναι ζευγάρι παλιών ηθοποιών απο τα μπουλούκια που έχουν δύο κόρες την Μαίρη και την Ντίνα (Παρθένα Χοροζίδου), μια μοδίστρα στα στούντιο του Φίνου.\\nΟ Στέφανος (Μέμος Μπεγνής) είναι ανερχόμενος ζεν πρεμιέ εκείνης της εποχής, όπως και ο Παύλος (Γιώργος Χρανιώτης) ο οποίος είναι παντρεμένος με μια στάρλετ την Φανή (Σύλβια Δελικούρα).\\nΚαι μην αναζητήσετε οποιαδήποτε ομοιότητα με πραγματικά πρόσωπα ή γεγονότα. Γιατί το χαρισματικό δίδυμο επινοεί προς τέρψιν των θεατών ιστορίες που εμπνέονται από την πραγματική ζωή του χτες και του σήμερα και τις μπολιάζει με μοναδικά τραγούδια, μεγάλες επιτυχίες της εποχής σε νέες ενορχηστρώσεις που ερμηνεύονται από τους ηθοποιούς και την με 12μελή ζωντανή ορχήστρα. Συμμετέχει 24μελές μπαλέτο.\\n \\nΕυχαριστούμε πολύ!",
        false),
    Movie(
        530,
        'Τέλος του Παιχνιδιού',
        null,
        'ΝΑΜΑ – ΛΥΚΟΦΩΣ Ι.Κ.Ε.',
        'https://www.viva.gr/tickets/getattachment/232be7ca-c7d2-4c0f-be82-88fab33836b6/%ce%a4%ce%b5%ce%bb%ce%bf%cf%82-%cf%84%ce%bf%cf%85-%ce%a0%ce%b1%ce%b9%cf%87%ce%bd%ce%b9%ce%b4%ce%b9%ce%bf%cf%8505040124-543c-4bde-a969-920f2d.png',
        null,
        "Το Σύγχρονο Θέατρο εγκαινιάζει την συνεργασία του με τον σπουδαίο ηθοποιό Δημήτρη Καταλειφό, με την παράσταση «Τέλος του Παιχνιδιού» του Σάμουελ Μπέκετ, ενός από τα σημαντικότερα έργα της παγκόσμιας δραματουργίας, σε σκηνοθεσία Γιώργου Σκεύα. Την εξαιρετική σύνθεση συντελεστών συμπληρώνουν οι ηθοποιοί Άρης Μπαλής, Όλγα Δαμάνη και Γιώργος Ζιόβας. «Τετέλεσται». Σε ποιο άλλο θεατρικό έργο, η πρώτη-πρώτη λέξη του κειμένου ακυρώνει εξ’ αρχής τη θεατρική Πράξη, την Πράξη της ζωής, επικυρώνοντας, παράλληλα, το μότο του Σάμουελ Μπέκετ πως το τέλος βρίσκεται στην αρχή, και ωστόσο συνεχίζουμε; Με την αγορά των εισιτηρίων σας αποδέχεστε τους Όρους Χρήσης των εισιτηρίων: https://drive.google.com/file/d/12_qQU25ecnZEcz3gy5HgBPQeS-E73Uhu/view?usp=sharing Για αγορά μειωμένων εισιτηρίων επικοινωνήστε με το ταμείο του θεάτρου στο 210 3464380     ",
        false),
    Movie(
        507,
        'Ο Απρόσκλητος Επισκέπτης',
        null,
        'ΕΛΙΑΡΤ ΠΟΛΙΤΙΣΤΙΚΕΣ ΕΚΔΗΛΩΣΕΙΣ',
        'https://www.viva.gr/tickets/getattachment/36631a29-305c-438a-b596-4a2208d250aa/%ce%9f-%ce%91%cf%80%cf%81%ce%bf%cf%83%ce%ba%ce%bb%ce%b7%cf%84%ce%bf%cf%82-%ce%95%cf%80%ce%b9%cf%83%ce%ba%ce%b5%cf%80%cf%84%ce%b7%cf%82ebab1a2c-bbdc-439a-937a-6c.png',
        null,
        "Ο Απρόσκλητος Επισκέπτης  της Άγκαθα Κρίστι (1957) στο θέατρο ELIART Μια συγκλονιστική ιστορία αστυνομικού σασπένς, νουάρ ατμόσφαιρας και εξιχνίασης φόνων.   Μέσα σε μια ιδιαίτερα δύσκολη περίοδο για τον πλανήτη, την ελληνική κοινωνία, τους Αθηναίους θεατρόφιλους και φυσικά τη φετινή θεατρική σεζόν, εμείς στο ELIART, εξακολουθούμε να κάνουμε όνειρα. Εργαζόμαστε στις πρόβες μας εντατικά για να ξεκινήσουμε στις 16 του Οκτώβρη (αρχική ημερομηνία έναρξης παραστάσεων) και ανοίξαμε και την προπώληση των εισιτηρίων. Και φέτος το θέατρο ELIART απαντάει στον ζόφο των ημερών με το έργο που πέρυσι αγκαλιάστηκε με θέρμη από το αθηναϊκό κοινό. Για δεύτερη συνεχή χρονιά, «Ο Απρόσκλητος επισκέπτης» της Άγκαθα Κρίστι σε σκηνοθεσία του Γιώργου Φρατζεσκάκη, ένα κλασικό αστυνομικό έργο με πολλές ανατροπές, είναι η δική μας πρόταση, για 90 λεπτά απόδρασης και αληθινής ψυχαγωγίας. Στην πυκνή ομίχλη της Νότιας Ουαλίας, ο Μάικλ Σταρκβέντερ χάνει τον έλεγχο του αυτοκινήτου του και πέφτει σ’ ένα χαντάκι. Βρίσκεται στη μέση του πουθενά και στην προσπάθειά του να βρει βοήθεια, μπαίνει σε μια απομονωμένη έπαυλη. Στην ξεκλείδωτη μπαλκονόπορτα, τον περιμένει μια έκπληξη: Ένας άντρας είναι νεκρός. Λίγο πιο πέρα, μ’ ένα περίστροφο στο χέρι, μια όμορφη γυναίκα. Η Λόρα Γουόρικ. Η γυναίκα που παραδέχεται πως δολοφόνησε το σύζυγό της. Ο Μάικλ γοητευμένος από τη νεαρή χήρα, αποφασίζει να τη βοηθήσει, επιχειρώντας να κατασκευάσουν από κοινού ένα ακλόνητο άλλοθι. Μήπως όμως δεν είναι αυτή τελικά η δολοφόνος; Και αν όχι, γιατί καλύπτει τα ίχνη του ενόχου; Ένα σπίτι γεμάτο πιθανούς υπόπτους. Θα καταφέρει, άραγε, ο απρόσκλητος επισκέπτης να βρει τον δολοφόνο προτού να είναι πολύ αργά; Στο θέατρο ELIART -που δικαίως χαρακτηρίζεται η αστυνομική σκηνή της Αθήνας- μετά τις μεγάλες επιτυχίες («Η παγίδα» του Ρομπέρ Τομά, για 3 σεζόν, «Δέκα μικροί νέγροι» της αξεπέραστης μετρ του αστυνομικού είδους Άγκαθα Κρίστι, για 2 σεζόν και «Ο επιθεωρητής έρχεται» του Τζον Πρίσλεϊ για 2 σεζόν), σας περιμένουμε κάθε Παρασκευή , Σάββατο και Κυριακή για να λύσουμε το μυστήριο του φόνου του «Απρόσκλητου Επισκέπτη». Να σημειωθεί επίσης, ότι στο ELIART, το οποίο επιπλέον αερίζεται πριν και μετά την παράσταση από την κεντρική του πόρτα, λειτουργεί εξαερισμός, ενώ θα τηρηθούν όλοι οι κανόνες υγιεινής που επιτάσσει το Πρωτόκολλο υγείας και υγιεινής του ΕΟΔΥ. Ταυτότητα παράστασης: «Ο απρόσκλητος επισκέπτης» της Άγκαθα Κρίστι Αστυνομικό Δράμα-Διάρκεια : 90 ' Μετάφραση: Αντώνης Γαλέος Σκηνοθεσία – μουσική επιμέλεια: Γιώργος Φρατζεσκάκης Σκηνικό: Βαλεντίνο Βαλάσης Κοστούμια: Βεστιάριο ELIART Φωτισμοί: Παναγιώτης Μανούσης Βοηθοί σκηνοθέτη: Ελένη Βουτυρά, Στάθης Λαγκάδας Τα κοστούμια της κ. Λαμπρίδου σχεδίασε και επιμελήθηκε o Αλέξανδρος Κομπόγιωργας Παίζουν οι ηθοποιοί: Οδυσσέας Σταμούλης Ιλιάς Λαμπρίδου Σοφία Μανωλάκου Γιώργος Φρατζεσκάκης Αννέτα Παπαθανασίου Σαράντος Γεωγλερής Κώστας Ζέκος Νίκος Καϊνός Art Work: Λουκάς Μελάς Φωτογραφίες -βίντεο art: Ra's Eye Μακιγιάζ: Άννα Μαρία Μπάμπη Κομμώσεις: Γρηγορία Τζήβα  Επικοινωνία θέατρο ELIART: Μαρίκα Αρβανιτοπούλου Παραγωγή: Ιωάννης Ρουμελιώτης – Θέατρο ELIART Πού: Θέατρο ELIART, Κωνσταντινουπόλεως 127, Βοτανικός, τηλ.: 210 3477677 Πότε: από Οκτώβρη κάθε Παρασκευή, Σάββατο και Κυριακή, έως την Κυριακή των Βαϊων. Ώρες: Παρασκευή στις 21:00, Σάββατο 18:15 και 21:00, Κυριακή στις 18:15 Διάρκεια: 90 λεπτά Εισιτήρια - Γενική είσοδος:15 €, 12 € (φοιτητές, άνεργοι, πολύτεκνοι, ΑμεΑ και άνω των 65). Ομαδικά εισιτήρια άνω των 15 ατόμων: 10 €. Προπώληση: Viva.gr και στο Ταμείο του θεάτρου ELIART ",
        false)
  ];

  List<Theater> homescreenTheaters = [
    Theater(302, 'Νέος Ακάδημος', 'Athens, Αττική', null),
    Theater(305, 'Σύγχρονο Θέατρο', 'Κεραμεικός, Αττική', null),
    Theater(303, 'Θέατρο Μικρο Χορν', 'Κολωνάκι, Αττική', null)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().black,
      body: Container(
        color: MyColors().black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 205,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return buildActorTile(index);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 20);
                  },
                  itemCount: homescreenActors.length),
            ),
            SizedBox(
              height: 20,
              width: 10,
              child: FloatingActionButton.extended(
                heroTag: "btn1",
                label: Text('See more actors',
                    style: TextStyle(color: MyColors().cyan)), // <-- Text
                backgroundColor: MyColors().gray,
                onPressed: () {
                  Home.of(context)?.setBottomNav('Actors');
                },
              ),
            ),
            Divider(color: MyColors().gray),
            SizedBox(
                height: 205,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return buildMovieTile(index);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 20);
                    },
                    itemCount: homescreenMovies.length)),
            SizedBox(
              height: 20,
              width: 10,
              child: FloatingActionButton.extended(
                heroTag: "btn2",
                label: Text('See more movies',
                    style: TextStyle(color: MyColors().cyan)), // <-- Text
                backgroundColor: MyColors().gray,
                onPressed: () {
                  Home.of(context)?.setBottomNav('Movies');
                },
              ),
            ),
            Divider(color: MyColors().gray),
            SizedBox(
                height: 205,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return buildTheaterTile(index);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 20);
                    },
                    itemCount: homescreenTheaters.length)),
            SizedBox(
              height: 20,
              width: 10,
              child: FloatingActionButton.extended(
                heroTag: "btn3",
                label: Text('See more theaters',
                    style: TextStyle(color: MyColors().cyan)), // <-- Text
                backgroundColor: MyColors().gray,
                onPressed: () {
                  Home.of(context)?.setBottomNav('Theaters');
                },
              ),
            ),
            Divider(color: MyColors().gray)
          ],
        ),
      ),
    );
  }

  Widget buildActorTile(int index) => Container(
      width: 130,
      // height: 50,
      color: MyColors().black,
      child: Card(
          color: MyColors().black,
          child: Wrap(children: <Widget>[
            // Image.network(homeActors[index].image),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(homescreenActors[index].image),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ActorInfo(homescreenActors[index].id)));
              },
              title: Center(
                child: Text(
                  homescreenActors[index].fullName,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: MyColors().cyan, fontSize: 14),
                ),
              ),
            ),
          ])));

  Widget buildMovieTile(int index) => Container(
      width: 130,
      color: MyColors().black,
      child: Card(
          color: MyColors().black,
          child: Wrap(children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage:
                      NetworkImage(homescreenMovies[index].mediaUrl!),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MovieInfo(homescreenMovies[index].id)));
              },
              title: Center(
                child: Text(
                  homescreenMovies[index].title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: MyColors().cyan, fontSize: 14),
                ),
              ),
            )
          ])));

  Widget buildTheaterTile(int index) => Container(
      width: 130,
      color: MyColors().black,
      child: Card(
          color: MyColors().black,
          child: Wrap(children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      'https://thumbs.dreamstime.com/z/location-pin-icon-165980583.jpg'),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TheaterInfo(homescreenTheaters[index].id)));
              },
              title: Center(
                child: Text(
                  homescreenTheaters[index].title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: MyColors().cyan, fontSize: 14),
                ),
              ),
            )
          ])));
}
