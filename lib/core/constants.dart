import 'dart:math';

class Constants {
  static const String appName = 'MindGate';
  static const String appTagline = 'Think Before You Scroll';
  static const int defaultDelaySeconds = 1;
  static const int minDelaySeconds = 1;
  static const int maxDelaySeconds = 30;

  static const List<String> calmMessages = [
    "🍵 Chai bana lo pehle.\nInstagram kahin nahi jaayega!",
    "📚 Ek page padh lo.\nScroll baad mein karna.",
    "🏏 Sachin ne 100 centuries mehnat se banaaye,\nscroll karke nahi.",
    "🧘 Do gehri saansein lo.\nKya tum sach mein Instagram kholna chahte ho?",
    "⏰ India mein average user\n3+ ghante Instagram pe lagata hai.\nAlag bano.",
    "🎯 Aaj ka goal yaad hai?\nYe scroll tujhe wahan nahi le jaayega.",
    "👨‍👩‍👧 Ghar mein koi hai?\nUnse baat karo — real connection\nInstagram se zyaada powerful hai.",
    "🌅 Abhi jo time waste kar rahe ho,\nvoh kabhi wapas nahi aayega.",
    "💪 Har baar jab tum 'Go Back' dabate ho,\ntumhara willpower stronger hota hai.",
    "📱 500 million Indians Instagram use karte hain.\nAlag hona strength hai, weakness nahi.",
    "🎓 JEE, UPSC, CAT — kuch bhi ho,\nhar minute count karta hai.",
    "🌙 Raat ka time hai?\nNeend zyaada zaroori hai Instagram se.",
    "🏃 5 minute walk karo.\nBody aur mind dono fresh ho jaayenge.",
    "✨ Tu jo banna chahta hai,\nvoh Instagram pe nahi milega.",
    "🌿 Ek dum ruko. Socho.\nKya ye scroll sach mein zaroori hai?",
  ];

  static const List<Map<String, String>> indianQuotes = [
    {
      'quote':
          'Dream, Dream, Dream.\nDreams transform into thoughts\nand thoughts result in action.',
      'author': '— Dr. APJ Abdul Kalam 🇮🇳'
    },
    {
      'quote': 'Arise, awake,\nand stop not\ntill the goal is reached.',
      'author': '— Swami Vivekananda 🇮🇳'
    },
    {
      'quote': 'Be the change\nyou wish to see\nin the world.',
      'author': '— Mahatma Gandhi 🇮🇳'
    },
    {
      'quote':
          'You have power over your mind,\nnot outside events.\nRealize this, and you will find strength.',
      'author': '— Marcus Aurelius'
    },
    {
      'quote':
          'It does not matter how slowly you go\nas long as you\ndo not stop.',
      'author': '— Confucius'
    },
    {
      'quote':
          'Small steps every day.\nThoda thoda karke\nbahut kuch hota hai.',
      'author': '— Desi Wisdom 🇮🇳'
    },
    {
      'quote':
          'The secret of getting ahead\nis getting started.\nShuru karo — abhi!',
      'author': '— Mark Twain'
    },
    {
      'quote': 'Koshish karne waalon ki\nkabhi haar nahi hoti.',
      'author': '— Harivansh Rai Bachchan 🇮🇳'
    },
    {
      'quote': 'Success is not final,\nfailure is not fatal:\nit is the courage to continue that counts.',
      'author': '— Winston Churchill'
    },
    {
      'quote':
          'Discipline is the bridge\nbetween goals and\naccomplishment.',
      'author': '— Jim Rohn'
    },
  ];

  static const List<String> doThisInstead = [
    "☕ Ek cup chai ya coffee bana lo",
    "📖 Apni favourite book ke 2 pages padho",
    "🏃 5 minute bahar walk karo",
    "💧 Ek glass paani piyo — hydrated raho!",
    "📝 Aaj ki to-do list likh lo",
    "🧘 5 deep breaths lo — bas itna",
    "📞 Kisi dost ya family member ko call karo",
    "🎵 Apna favourite gaana suno",
    "✍️ Ek cheez likho jo aaj ke liye grateful ho",
    "😴 Raat hai? So jao — neend sabse zaroori hai",
  ];

  static const List<String> indiaFacts = [
    "📱 India has 500M+ Instagram users\n— the most in the world!",
    "⏰ Average Indian spends 2.5 hours\ndaily on social media.",
    "🧠 Social media raises anxiety by 32%\nin young adults (studies show).",
    "💸 1 hour/day saved = 365 hours/year\n= 15 full free days every year!",
    "🎓 Students who limit social media\nscore 20% better in exams.",
  ];

  static const List<String> streakMilestones = [
    "🏆 Legend! 100+ streak — tum champion ho!",
    "👑 50+ streak! Serious dedication — respect!",
    "🔥 25+ streak! Sharma ji ka beta bhi fan hai!",
    "💪 10+ streak! Willpower beast mode ON!",
    "⭐ 5+ streak! Shuruaat achi hai — keep going!",
  ];

  static String getStreakCelebration(int streak) {
    if (streak >= 100) return streakMilestones[0];
    if (streak >= 50) return streakMilestones[1];
    if (streak >= 25) return streakMilestones[2];
    if (streak >= 10) return streakMilestones[3];
    if (streak >= 5) return streakMilestones[4];
    return '';
  }

  static String getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 5) return 'Raat ko jaag rahe ho? 🌙';
    if (hour < 12) return 'Subh Prabhat! 🌅';
    if (hour < 17) return 'Namaste! 🙏';
    if (hour < 21) return 'Shaam ho gayi! 🌆';
    return 'Raat mein scroll? 🌙';
  }

  static String getMotivationalLevel(int streak) {
    if (streak >= 25) return '🏆 Willpower Legend';
    if (streak >= 10) return '💪 Streak Warrior';
    if (streak >= 5) return '⭐ Getting Stronger';
    if (streak >= 1) return '🌱 Journey Begins';
    return 'Think Before You Scroll';
  }

  static String randomDoThisInstead() {
    return doThisInstead[Random().nextInt(doThisInstead.length)];
  }

  static String randomFact() {
    return indiaFacts[Random().nextInt(indiaFacts.length)];
  }

  static Map<String, String> randomQuote() {
    return indianQuotes[Random().nextInt(indianQuotes.length)];
  }
}
