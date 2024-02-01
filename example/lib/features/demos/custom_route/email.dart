import 'dart:math';

final _r = Random.secure();

class Email {
  Email({
    required this.userName,
    required this.title,
    required this.content,
    required this.timeSent,
  }) : id = _r.nextInt(1 << 10).toString();

  final String id;
  final String userName;
  final String title;
  final String content;
  final DateTime timeSent;
}

final emails = Map<String, Email>.fromIterable(
  [
    Email(
      userName: 'John Doe',
      title: 'Exciting News!',
      content:
          'Dear user, We are thrilled to announce a groundbreaking update to our platform. This new release brings exciting features and enhancements that we believe will greatly improve your experience.' *
              5,
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'Alice Smith',
      title: 'Important Reminder',
      content:
          'Hello there, This is a friendly reminder to complete your profile information. Providing accurate details ensures that you receive relevant updates and personalized recommendations.' *
              10,
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'Bob Johnson',
      title: 'Exclusive Offer Just for You!',
      content:
          'Dear valued customer, As a token of appreciation for your continued support, we are pleased to offer you an exclusive discount on your next purchase. Don\'t miss out on this limited-time offer!' *
              20,
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'Eva Williams',
      title: 'Upcoming Event Details',
      content:
          'Hi, Get ready for an unforgettable experience at our upcoming event! We have lined up exciting activities, guest speakers, and networking opportunities. Save the date and join us for a day filled with inspiration and fun.',
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'Michael Brown',
      title: 'Customer Feedback Request',
      content:
          'Dear user, We value your opinion and would like to hear about your recent experience with our services. Your feedback is essential in helping us enhance and improve our offerings. Share your thoughts with us today!',
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'Sophia Davis',
      title: 'New Product Launch',
      content:
          'Hello, We are delighted to introduce our latest product that is set to revolutionize the way you [use our product/service]. Discover innovative features and enhanced performance. Check out our website for more details.',
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'Matthew Miller',
      title: 'Community Update',
      content:
          'Dear community member, Stay informed about the latest happenings in our community. From upcoming events to recent achievements, we\'ve got you covered. Dive into the latest news and be a part of our thriving community.',
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'Olivia Wilson',
      title: 'Account Security Alert',
      content:
          'Attention user, We detected unusual activity on your account. For your safety, we recommend reviewing your recent login history and updating your password. Take immediate action to secure your account.',
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'Daniel Taylor',
      title: 'Product Tutorial',
      content:
          'Hi, New to our platform? Explore our step-by-step tutorial to make the most out of your experience. Learn about key features, tips, and tricks that will help you navigate seamlessly.',
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'Emma Moore',
      title: 'Invitation to Webinar',
      content:
          'Dear [Name], You are invited to our upcoming webinar on [topic]. Join industry experts as they share insights and best practices. Reserve your spot for this informative session.',
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'Christopher Anderson',
      title: 'Holiday Greetings',
      content:
          'Warm wishes for the holiday season! May your days be filled with joy, laughter, and good company. Thank you for being a part of our community. Here\'s to a wonderful and festive celebration.',
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'Ava Garcia',
      title: 'Technical Support Update',
      content:
          'Hello, We have identified and resolved the recent technical issues reported by users. Our team is committed to providing a seamless experience, and we appreciate your patience. If you encounter any further issues, please reach out to our support team.',
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'William Martinez',
      title: 'Exclusive Sneak Peek',
      content:
          'Dear [Name], Be the first to experience our upcoming product release! Get an exclusive sneak peek into the features that will elevate your [product/service] experience. Stay tuned for the official launch.',
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'Mia Rodriguez',
      title: 'Career Development Workshop',
      content:
          'Hi [Name], Elevate your career with our upcoming workshop on [topic]. Gain valuable insights, network with industry professionals, and take a step towards achieving your career goals. Register now for this enriching opportunity.',
      timeSent: DateTime.now(),
    ),
    Email(
      userName: 'James Lee',
      title: 'Monthly Newsletter',
      content:
          'Greetings, Dive into our monthly newsletter for a roundup of exciting updates, featured content, and upcoming events. Stay connected with the latest news and happenings in our community.',
      timeSent: DateTime.now(),
    ),
  ],
  key: (element) => element.id,
);
