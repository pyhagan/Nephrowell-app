import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Library'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLargeScreen = constraints.maxWidth > 600;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What is a Kidney?',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 28 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'The kidneys are two bean-shaped organs located on either side of your spine, just below your rib cage. They are responsible for filtering waste from your blood, balancing your body’s fluids, and forming urine. Kidneys also perform important functions such as regulating blood pressure, producing red blood cells, and maintaining bone health.',
                    style: TextStyle(fontSize: isLargeScreen ? 20 : 18),
                  ),
                  SizedBox(height: 20),
                  ResponsiveImageRow1(isLargeScreen: isLargeScreen),
                  SizedBox(height: 20),
                  Text(
                    'Functions of the Kidney:',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 28 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '- Filter waste products from the blood\n- Balance the body’s fluids\n- Regulate blood pressure\n- Control red blood cell production\n- Maintain bone health',
                    style: TextStyle(fontSize: isLargeScreen ? 20 : 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'About Chronic Kidney Disease?',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 28 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your kidneys do many important jobs. Some of the ways they keep your whole body in balance include:',
                    style: TextStyle(fontSize: isLargeScreen ? 20 : 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '-Removing natural waste products and extra water from your body\n-Helping make red blood cells\n-Balancing important minerals in your body\n-Helping maintain your blood pressure\n-Keeping your bones healthy',
                    style: TextStyle(fontSize: isLargeScreen ? 20 : 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Chronic kidney disease (CKD) is when the kidneys have become damaged over time (for at least 3 months) and have a hard time doing all their important jobs. CKD also increases the risk of other health problems like heart disease and stroke. Developing CKD is usually a very slow process with very few symptoms at first. So, CKD is divided into 5 stages to help guide treatment decisions.',
                    style: TextStyle(fontSize: isLargeScreen ? 20 : 18),
                  ),
                  SizedBox(height: 20),
                  ResponsiveImageRow2(isLargeScreen: isLargeScreen),
                  SizedBox(height: 20),
                  Text(
                    'Some Signs And Symptoms',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 28 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Many people living with CKD do not have any symptoms until the more advanced stages and/or complications develop. If symptoms do happen, they may include:',
                    style: TextStyle(fontSize: isLargeScreen ? 20 : 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '-Foamy urine\n-Urinating (peeing) more often or less often than usual\n-Itchy and/or dry skin\n-Feeling tired\n-Nausea\n-Loss of appetite\n-Weight loss without trying to lose weight',
                    style: TextStyle(fontSize: isLargeScreen ? 20 : 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'People who have more advanced stages of CKD may also notice:',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 20 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '-Trouble concentrating\n-Numbness or swelling in your arms, legs, ankles, or feet\n-Achy muscles or cramping\n-Shortness of breath\n-Vomiting\n-Trouble sleeping\n-Breath smells like ammonia (also described as urine-like or “fishy”)',
                    style: TextStyle(fontSize: isLargeScreen ? 20 : 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Some Causes',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 28 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '-Inherited conditions: polycystic kidney disease\n-kidney cancer\n-Smoking and/or use of tobacco products\n-Obesity\n-Heart disease and/or heart failure\n-Over the age of 60\n-Diabetes\n-High blood pressure (hypertension)\n-Over the age of 60',
                    style: TextStyle(fontSize: isLargeScreen ? 20 : 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Published Documents:',
                    style: TextStyle(
                      fontSize: isLargeScreen ? 28 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
  leading: Icon(Icons.article),
  title: Text('Understanding Chronic Kidney Disease'),
  subtitle: Text('Published by: National Kidney Foundation'),
  onTap: () {
    launchURL('https://www.kidney.org/atoz/content/about-chronic-kidney-disease');
  },
),
ListTile(
  leading: Icon(Icons.article),
  title: Text('The Importance of Kidney Health'),
  subtitle: Text('Published by: Canada Kidney Foundation'),
  onTap: () {
    launchURL('https://kidney.ca/Kidney-Health/Your-Kidneys/Why-Kidneys-are-so-Important');
  },
),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
Future<void> launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class ResponsiveImageRow1 extends StatelessWidget {
  final bool isLargeScreen;

  const ResponsiveImageRow1({Key? key, required this.isLargeScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLargeScreen
        ? Row(
            children: [
              Expanded(child: Image.asset('images/kidney1.jpeg', fit: BoxFit.cover)),
              SizedBox(width: 20),
              Expanded(child: Image.asset('images/kidney2.jpeg', fit: BoxFit.cover)),
            ],
          )
        : Column(
            children: [
              Image.asset('images/kidney1.jpeg', fit: BoxFit.cover),
              SizedBox(height: 20),
              Image.asset('images/kidney2.jpeg', fit: BoxFit.cover),
            ],
          );
  }
}

class ResponsiveImageRow2 extends StatelessWidget {
  final bool isLargeScreen;

  const ResponsiveImageRow2({Key? key, required this.isLargeScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLargeScreen
        ? Row(
            children: [
              Expanded(child: Image.asset('images/stage1.jpeg', fit: BoxFit.cover)),
              SizedBox(width: 20),
              Expanded(child: Image.asset('images/stage2.jpeg', fit: BoxFit.cover)),
            ],
          )
        : Column(
            children: [
              Image.asset('images/stage1.jpeg', fit: BoxFit.cover),
              SizedBox(height: 20),
              Image.asset('images/stage2.jpeg', fit: BoxFit.cover),
            ],
          );
  }
}
