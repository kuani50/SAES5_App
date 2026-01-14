import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../providers/auth_provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String firstName = "";
  String lastName = "";
  String gender = "";
  String phone = "";
  String address = "";
  String postalCode = "";
  String city = "";
  String country = "";
  String complementAddress = "";
  String errorMessage = '';
  String birthDate = "";

  Future<void> submitForm() async {
    final provider = context.read<ProjectProvider>();

    setState(() {
      errorMessage = '';
    });

    bool result = await Provider.of<AuthProvider>(context, listen: false)
        .register(
          email,
          password,
          firstName,
          lastName,
          gender,
          phone,
          birthDate,
          address,
          postalCode,
          city,
          country,
          complementAddress,
        );
    if (result == false) {
      setState(() {
        errorMessage = 'There was a problem with your registration.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Email',
                icon: Icon(Icons.mail),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter an email address' : null,
              onSaved: (value) => email = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Password',
                icon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a password' : null,
              onSaved: (value) => password = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'First name',
                icon: Icon(Icons.person),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a first name' : null,
              onSaved: (value) => firstName = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Last name',
                icon: Icon(Icons.person_outline),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a last name' : null,
              onSaved: (value) => lastName = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Gender',
                icon: Icon(Icons.wc),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a gender' : null,
              onSaved: (value) => gender = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Phone',
                icon: Icon(Icons.phone),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a phone number' : null,
              onSaved: (value) => phone = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Address',
                icon: Icon(Icons.home),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter an address' : null,
              onSaved: (value) => address = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Complement address (optional)',
                icon: Icon(Icons.add_location),
              ),
              onSaved: (value) => complementAddress = value ?? '',
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Postal code',
                icon: Icon(Icons.markunread_mailbox),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a postal code' : null,
              onSaved: (value) => postalCode = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'City',
                icon: Icon(Icons.location_city),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a city' : null,
              onSaved: (value) => city = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Country',
                icon: Icon(Icons.flag),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a country' : null,
              onSaved: (value) => country = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Date de naissance',
                icon: Icon(Icons.flag),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a birth date' : null,
              onSaved: (value) => birthDate = value!,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              child: TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    submitForm();
                  }
                },
                child: const Text("S'inscrire"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
