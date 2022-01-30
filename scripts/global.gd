extends Node

#to delete any saved files, see the final comment in the _ready() function

#Global autoload manages a few things:
#the deck information(texture paths, descriptions, name/ID) 
#
#for movement between scenes, temporary arrays store hands and card
#order information as references to IDs in the 'deck' array. This also
#manages saving files, tracking the current card in focus for the progress
#indicator, as well as randomly shuffling the deck. 

#THE DECK
var livedeck : Array = [
	{
		'description1': "I REALLY WANT TO IMPRESS YOU",
		'description2': "you inspire me",
		'name': '46'
	},
	{
		'description1': "I WANT TO GET TO KNOW YOU BETTER",
		'description2': "",
		'name': '27'
	},
	{
		'description1': "I DIDNT UNDERSTAND WHAT A SOULMATE WAS UNTIL I MET YOU",
		'description2': "you've helped me to connect more with my higher self",
		'name': '48'
	},
	{
		'description1': "WHENEVER I'M AROUND YOU I FEEL SET FREE",
		'description2': "I'm usually so cautious and calm, which has me panicking a little. I'm so into you.",
		'name': '18'
	},
	{
		'description1': "I FEEL GUILTY ABOUT GHOSTING YOU",
		'description2': "I didn't know how to give you what you wanted, and it was harder for me to share my feelings about it than it was to just walk away.",
		'name': '02'
	},
	{
		'description1': "YOU ARE A DREAM COME TRUE",
		'description2': "",
		'name': '55'
	},
	{
		'description1': "I'M WORRIED",
		'description2': "if you get too close, you will see the real me.",
		'name': '21'
	},
	{
		'description1': "I'VE BEEN AVOIDING SAYING ANYTHING",
		'description2': "because I'm actually quite shy on the inside, and have no idea if you are friend-zoning me or not.",
		'name': '56'
	},
	{
		'description1': "I CAN'T WAIT TO SEE YOU AGAIN!",
		'description2': "",
		'name': '54'
	},
	{
		'description1': "I FEEL YOUR ENERGY AROUND ME",
		'description2': "when I see your favorite flower, watch a couple strolling together on the beach, or hear your favorite song - It makes me nostalgic for you.",
		'name': '52'
	},
	{
		'description1': "I KNOW IT FEELS LIKE FOREVER",
		'description2': "since we were together - Just hang on, and it'll be over soon. We can pick right back up where we left off.",
		'name': '19'
	},
	{
		'description1': "I AM SENSITIVE TO THE INTENSE EMOTIONAL ENERGY",
		'description2': "around this situation. I need time to be alone and process.",
		'name': '62'
	},
	{
		'description1': "EVERYTHING REMINDS ME OF YOU",
		'description2': "I'm working hard to straighten out my life so I can feel confident enough to approach you again.",
		'name': '38'
	},
	{
		'description1': "I MISS",
		'description2': "when things were simpler and easy between us.",
		'name': '23'
	},
	{
		'description1': "I'M REGRETTING THE THINGS I LAST SAID TO YOU",
		'description2': "I keep going over it in my head",
		'name': '01'
	},
	{
		'description1': "I DONT REALLY DO LONG TERM RELATIONSHIPS",
		'description2': "",
		'name': '64'
	},
]

#UI COLOR MANAGEMENT SECTION
onready var color_dominant : Color = Color(0.917, 0.847, 0.796)
onready var color_compliment : Color = Color(0.678, 0.619, 0.556)
onready var color_accent : Color = Color(0.678, 0.619, 0.556)

#DECK ARRAY MANAGEMENT SECTION

#temp holder for randomization
var deck_copy : Array = []
#temp holder for copy when it is converted to references instead of actual dictionarys
var deck_copy_converted : Array = []
#temp holder to show which cards have already been selected out of the carousel
var deck_copy_chosen_states : Array = []
#temp holder for selected cards during choose your card spread
var carousel_choice : Array = []
#temp holder for carousel choice cards converted to reference instead of actual dictionaries
var carousel_converted : Array = []
#var to hold current spread state information(state is more like spread ID?)
var spread_state_set_to : int
#var to store front or back of card visible
var card_side_displayed : String = "back"
#for scene_type_check, set this var at scene intro to determine carousel cards
var carousel_types : Array = ["CHOOSING", "REVEALING", "JOURNAL"]
var carousel_type_currently_is : int = 0

#PROGRESS INDICATOR SECTION

#for cardlayoutprogress, to know which configuration to use for cards, stock or custom
#NOTE THIS NEEDS SETUP : Currently there will not be any custom spreads, so it will
#only be a few basic spreads and one open style with a high limit of cards. I might
#be considering allowing users to pull 'clarifiers' but that's maybe once it's all ready.
var _layout_states : Array = ["Love for Two", "Love for just you",]
#same as above
var _layout_states_cards_in_each : Array = [3, 5,]
#spread info and actual stock descriptions
var tarot_spread_info : Array = [
	{
		'spread name': 'Love for Two',
		'spread description': 'Compatibility between you and another',
		'number of cards': 3,
		'position titles': ["Your Compatibility", "Your Blockages", "Their Blockages"],
		'position interpretations': ["Your compatibility is about you and them, Do you have any friendship? Is it just a romantic love?", "Your blockages may or may not prevent you from having a strong relationship with this person", "Their blockages may or may not prevent them from having a strong relationship with you"],
		'user position notes': [["", ], ["", ], ["", ]],
		'user general notes': ["", "", ],
	},
	{
		'spread name': 'Love for just you',
		'spread description': 'Just you, and the love you have for yourself',
		'number of cards': 5,
		'position titles': ["Your blockages to love", "Your current situation", "What you're leaving behind", "What's coming in for you", "How you can get ready for love"],
		'position interpretations': ["Anything that's preventing you from loving yourself fully", "How are you feeling about love lately?", "Is there anything you've made progress with?", "What is around the corner?", "Practical action steps or things to focus on in the meantime"],
		'user position notes': [["", ], ["", ], ["", ], ["", ], ["", ]],
		'user general notes': ["", "", ],
	}
]
#global storage to indicate which card is the focus. Used in both hidden carousel and see
#your cards
var current_card_in_spread : int = 0
#used for comparing with current position as well as indicator lights in cardlayoutprogress
var total_cards_in_scene : int = 0
#used to store the card in focus name? or position...needs work
var current_cardid_in_center_card : String = ""
#used to store rng seeds
var seeds : Array = ["evoke", "announce", "veteran", "fiscal", "author", "artist", "gown", "fiber", "connect", "miss", "text", "timber"]

#PERSISTENT DATA SECTION 

# user data file path storage
onready var save_file : String = "user://user.data"
#stores up-to-date user data during runtime
onready var user_data : Dictionary = {}
#stores current (and hopefully recently saved) runtime data
onready var runtime_user_data : Dictionary = {
	"saved_readings": {},
	"journal_entries": {},
	"seeds": {},
	"deck_notes": [{'01': "something I wrote myself"}, {"02": "A second note for testing"},\
	 {"03": "A third note for testing"}, {"04": "A fourth note for testing"}, \
	 {"05": "A fifth note for testing"}, {"06": "A sixth note for testing"}, \
	 {"07": "A seventh note for testing"}, {"08": "An eighth note for testing"}, \
	 {"09": "A ninth note for testing"}, {"10": "A tenth note for testing"}, \
	 {"11": "An eleventh note for testing"}, {"12": "A twelfth note for testing"}],
}

#OS related and settings vars
onready var os_screen_size : Vector2 = Vector2(1080, 1920)

func _ready():
	OS.low_processor_usage_mode = true
	on_start_load_user()

func on_start_load_user():
	#create a new save file
	var file : File = File.new()
	#if the file exists, open it, and pull the data into user_data var, then close the save_file
	if file.file_exists(save_file):
		file.open(save_file, File.READ)
		user_data = file.get_var(true)
		file.close()
#if the user_data file is empty, add whatever is in runtime_user_data to it
	if user_data.empty():
		user_data = runtime_user_data
		print("user_data empty")
	#if it's not empty, add user_data to runtime_user_data so it can be accessed during runtime
	elif not user_data.empty():
		runtime_user_data = user_data
		#uncomment the line below this one, and then comment the line above this one to delete current save file
		#user_data = runtime_user_data
		#save_user_data()

func save_user_data():
	#open the user_data file and store what's in runtime_user_data to it
	var file : File = File.new()
	file.open(save_file, File.WRITE)
	user_data = runtime_user_data
	file.store_var(user_data, true)
	file.close()

func draw():
	if deck_copy.size() == 0:
		_shuffle_deck()
	else:
		clear_decks()
		_shuffle_deck()


func clear_decks():
	#clear all deck storage related variables for a clean start
	deck_copy.clear()
	deck_copy_converted.clear()
	deck_copy_chosen_states.clear()
	carousel_choice.clear()
	
func _shuffle_deck():
	#NOTE: currently randomized using only built - in RNGS, this will need to be 
	#updated to reflect user generated RNGs by hashing user created images and using
	#the hash as that seed. Seeds can be stored in user data for recall, and would like
	#to also store deck states so the deck can become a permananent and 'living'
	#fixture in the app.
	deck_copy = livedeck.duplicate()
	randomize()
	deck_copy.shuffle()
	for i in deck_copy:
		deck_copy_chosen_states.append("available")
	for i in deck_copy:
		_compare_against_deck(i, "runtime")

func _compare_against_deck(carousel_card, app_state):
	if app_state == "runtime":
		for dict in livedeck:
			if dict.name == carousel_card.name:
				deck_copy_converted.append(livedeck.find(dict))
				break
			else:
				pass
	if app_state == "savetime":
		for i in carousel_choice:
			carousel_converted.append(livedeck[i].name)
