# taken from http://brendoman.com/media/users/dan/finctional_companies.txt
company_names = ["Acme, inc.", "Widget Corp", "123 Warehousing", "Demo Company", "Smith and Co.", "Foo Bars", "ABC Telecom", "Fake Brothers", "QWERTY Logistics", "Demo, inc.", "Sample Company", "Sample, inc", "Acme Corp", "Allied Biscuit", "Ankh-Sto Associates", "Extensive Enterprise", "Galaxy Corp", "Globo-Chem", "Mr. Sparkle", "Globex Corporation", "LexCorp", "LuthorCorp", "North Central Positronics", "Omni Consimer Products", "Praxis Corporation", "Sombra Corporation", "Sto Plains Holdings", "Tessier-Ashpool", "Wayne Enterprises", "Wentworth Industries", "ZiffCorp", "Bluth Company", "Strickland Propane", "Thatherton Fuels", "Three Waters", "Water and Power", "Western Gas & Electric", "Mammoth Pictures", "Mooby Corp", "Gringotts", "Thrift Bank", "Flowers By Irene", "The Legitimate Businessmens Club", "Osato Chemicals", "Transworld Consortium", "Universal Export", "United Fried Chicken", "Virtucon", "Kumatsu Motors", "Keedsler Motors", "Powell Motors", "Industrial Automation", "Sirius Cybernetics Corporation", "U.S. Robotics and Mechanical Men", "Colonial Movers", "Corellian Engineering Corporation", "Incom Corporation", "General Products", "Leeding Engines Ltd.", "Blammo", "Input, Inc.", "Mainway Toys", "Videlectrix", "Zevo Toys", "Ajax", "Axis Chemical Co.", "Barrytron", "Carrys Candles", "Cogswell Cogs", "Spacely Sprockets", "General Forge and Foundry", "Duff Brewing Company", "Dunder Mifflin", "General Services Corporation", "Monarch Playing Card Co.", "Krustyco", "Initech", "Roboto Industries", "Primatech", "Sonky Rubber Goods", "St. Anky Beer", "Stay Puft Corporation", "Vandelay Industries", "Wernham Hogg", "Gadgetron", "Burleigh and Stronginthearm", "BLAND Corporation", "Nordyne Defense Dynamics", "Petrox Oil Company", "Roxxon", "McMahon and Tate", "Sixty Second Avenue", "Charles Townsend Agency", "Spade and Archer", "Megadodo Publications", "Rouster and Sideways", "C.H. Lavatory and Sons", "Globo Gym American Corp", "The New Firm", "SpringShield", "Compuglobalhypermeganet", "Data Systems", "Gizmonic Institute", "Initrode", "Taggart Transcontinental", "Atlantic Northern", "Niagular", "Plow King", "Big Kahuna Burger", "Big T Burgers and Fries", "Chez Quis", "Chotchkies", "The Frying Dutchman", "Klimpys", "The Krusty Krab", "Monks Diner", "Milliways", "Minuteman Cafe", "Taco Grande", "Tip Top Cafe", "Moes Tavern", "Central Perk", "Chasers"]

short_texts = [
"Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
"Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
"Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
"Ab illo inventore veritatis.",
"Ullamco laboris nisi",
"Excepteur sint occaecat",
"Ut enim ad minima",
"Neque porro quisquam est, qui dolorem ipsum",
"Sunt in culpa qui officia deserunt mollit",
"Quis nostrud exercitation ullamco laboris",
"Nemo enim ipsam voluptatem quia voluptas",
"Adipisci velit, sed quia non numquam",
"Eius modi tempora incidunt ut labore",
"Et dolore magnam aliquam quaerat voluptatem",
"Quis nostrum exercitationem ullam corporis",
"Iure reprehenderit qui in ea voluptate"]

# Names have been taken from http://www.alt-starfleet-rpg.org/misc/namegen.html
names = ["Allen", "Bob", "Carlton", "David", "Ernie", "Foster", "George", "Howard", "Ian", "Jeffery", "Kenneth", "Lawrence", "Michael", "Nathen", "Orson", "Peter", "Quinten", "Reginald", "Stephen", "Thomas", "Morris", "Victor", "Walter", "Xavier", "Charles", "Anthony", "Gordon", "Percy", "Conrad", "Quincey", "Armand", "Jamal", "Andrew", "Matthew", "Mark", "Gerald", "Buck", "Darian", "Adrian", "Geordi", "Jason", "Dmitri", "Sergei", "Slava", "Piotr", "Pavel", "Kevin", "Jose", "Salvador", "Mark", "Vincente", "Pedro", "William", "Trent", "Ronald", "Clarke", "Simon", "Hikaru", "Nguyen", "Alexei", "Lon", "Willard", "Noonien", "Jake", "Benjamin", "Joseph", "Montgomery", "Elias", "Nikolai", "Paul", "Cyrus", "Gregory", "Orfil", "Eric", "Christopher", "Rene", "Jean-Jacques", "Jean-Paul", "Jean-Pierre", "Maurice", "Bela", "Zefram", "Miles", "Isaac", "Kusatsu", "Enrique", "Fenton", "James", "Gary", "Wyatt", "Leonard", "Kieran", "Seamus", "Ryan", "Samuel", "Robert", "Tiberius", "Khan", "Lee", "Walker", "Anton", "Julian", "Hanson", "Sigmund", "Hans", "Hienz", "Stefan", "Frank", "Lewis", "Albert", "Arne", "Wesley", "Louis", "Arthur", "Jonathan", "Richard", "Sean", "Gabriel", "Morgan", "Tristan", "Hideki", "Ichiro", "Arthur", "Brandon",  "Eusbaldo", "Demetrius", "Shawn", "Corey", "Joshua", "Donald", "Edward", "Gerard", "Theodore", "Paul", "Rakeem", "Austin", "Darrell", "Justin", "Decarise", "Ethan", "Cody", "Alice", "Bonnie", "Cassie", "Donna", "Ethel", "Grace", "Heather", "Jan", "Katherine", "Julie", "Marcia", "Patricia", "Mabel", "Jennifer", "Dorthey", "Mary Ellen", "Jacki", "Jean", "Betty", "Diane", "Annette", "Dawn", "Jody", "Karen", "Mary Jane", "Shannon", "Stephanie", "Kathleen", "Emily", "Tiffany", "Angela", "Christine", "Debbie", "Karla", "Sandy", "Marilyn", "Brenda", "Hayley", "Linda", "Zarabeth", "Yuta", "Kasidy", "Ishara", "Mirasta", "Samantha", "Varria", "Kestra", "Tressa", "Leah", "Sharon", "Gillian", "Juliana", "Natalya", "Jaxa", "Areel", "Elizabeth", "Norah", "Helena", "Mira", "Rain", "Roana", "Claire", "Janice", "Deborah", "Marie", "Beverly", "Linnis", "Carolyn", "Alyssa", "Keiko", "Molly", "Marissa", "Melissa", "Natira", "Alynna", "Nara", "Marlena", "Meribor", "Melanie", "Marla", "Kila", "Lyris", "Susanna", "Leeta", "Natima", "Silva", "Anastasia", "Kira", "Kelinda", "Xenia", "Lenara", "Miranda", "Isabella", "Mariah", "Nancy", "Gia", "Faith", "Eudana", "Elani", "Droxine", "Natasha", "Jenna", "Christine", "Callista", "Kareen", "Erika", "Hannah", "Arissa", "Ariel", "Amanda", "Alcia", "Amber", "Brittni", "Kristina", "Savannah", "Mason", "Latiecia", "Keyona", "Bethany", "Olivia", "Lisha", "Lara", "Chariti", "Reyna", "Alejandra", "Valeria", "Magion", "Telachia"]

lastnames = ["Adams", "Bowden", "Conway", "Darden", "Edwards", "Flynn", "Gilliam", "Holiday", "Ingram", "Johnson", "Kraemer", "Hunter", "McDonald", "Nichols", "Pierce", "Sawyer", "Saunders", "Schmidt", "Schroeder", "Smith", "Douglas", "Ward", "Watson", "Williams", "Winters", "Yeager", "Ford", "Forman", "Dixon", "Clark", "Churchill", "Brown", "Blum", "Anderson", "Black", "Cavenaugh", "Hampton", "Jenkins", "Prichard", "Albert", "Aster", "Aylebourne", "Bailey", "Barclay", "Barrows", "Bates", "Benbeck", "Bennett", "Bell", "Benteen", "Bokai", "Boone", "Boyce", "Brack", "Brahms", "Brand", "Brianon", "Burleigh", "Bristow", "Burke", "Calloway", "Campio", "Castillo", "Cartwright", "Levia", "Samsonov", "Cheskis", "Chilton", "Clemons", "Coleman", "Crater", "deWitt", "deJan", "Danar", "Day", "Denning", "deSoto", "Evans", "Chancellor", "Farralon", "Yamamoto", "Finney", "Flint", "Frazier", "Fullerton", "Garcia", "Garrett", "Garth", "Green", "Harriman", "Hawk", "Haskins", "Hedford", "Henley", "Hill", "Howard", "Hudson", "Jakara", "Jared", "Jameson", "Jellico", "Jones", "Kalomi", "Kargan", "Karnas", "Karidian", "Keel", "Kelso", "Kennely", "Kim", "Singh", "Kolrami", "Komananov", "Kyle", "Landon", "Donovan", "Lavelle", "Lafite", "Leijten", "Lense", "Leyton", "Loran", "Louvois", "Maddox", "MacDuff", "MacDonald", "Maxwell", "Masters", "Merrick", "Mendez", "Miller", "Mirren", "Moriarty", "Mordock", "Mendon", "Muniz", "Rodriguez", "Martinez", "Nakamura", "Nechayev", "Abramowitz", "Neria", "Neyla", "Newton", "Nilrem", "Noah", "Nogami", "Terla", "O'Connel", "O'Malley", "Odan", "Ogawa", "Okala", "Onara", "Otner", "Palmer", "Pazlar", "Peers", "Perrin", "Piper", "Plasus", "Porter", "Potemkin", "Preston", "Quaice", "Quinn", "Ramart", "Radue", "Rasmussen", "Ramsey", "Palomar", "Remmick", "Tolen", "Ressik", "Rice", "Riley", "Robinson", "Rogers", "Ronin", "Sandoval", "Sargon", "Seyetik", "Shelby", "Shaw", "Sloane", "Sito", "Sobi", "Stadi", "Starling", "Decker", "Stone", "Styles", "Tagana", "T'su", "Tainer", "Talar", "Tarses", "Tayman", "Tiron", "Tracey", "Torres", "Tralesta", "Varani", "Valtane", "Vigo", "Wallace", "Wesley", "Yates", "Zweller", "Zimmerman", "Brickhouse", "Coxum", "Esquivias", "Aguilar", "Lockamy", "Ocampo", "Ballentine", "Cabrera", "Gautier", "Hoffman", "Ingram", "Soriano", "Farias", "Geddie", "Laraway", "Ponce", "Espino", "Cerda", "Barksdale", "Burnette", "Wetherington", "Cardone", "McCullen"]


desc "Creates invoices for testing purposes"
task :generate_invoices, [:arg1] => :environment do |t, args|
  args.with_defaults(:arg1 => 10)
  1.upto(Integer(args[:arg1])) do |i|
    invoice = Invoice.create(
      :number => i,
      :customer_name => company_names[rand(0..company_names.length - 1)],
      :customer_identification => 'X123',
      :customer_email => '%s@%s.com' %
        [names[rand(0..names.length - 1)].downcase,
         lastnames[rand(0..lastnames.length - 1)].downcase]
    )
    1.upto(rand(1..10)) do |i|
      item = InvoiceItem.create(
        :description => short_texts[rand(0..short_texts.length - 1)],
        :quantity => 1 + Integer(rand * 10),
        :discount => 0,
        :unitary_cost => (rand * 10).round(2))
      invoice.invoice_items.push(item)
    end
    invoice.save!
  end
end

