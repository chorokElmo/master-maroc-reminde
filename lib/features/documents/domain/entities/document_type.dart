enum DocumentType {
  diploma,
  transcript,
  cv,
  motivationLetter,
  nationalId,
  passportPhoto,
  englishCertificate,
  frenchCertificate,
}

extension DocumentTypeX on DocumentType {
  String get label => switch (this) {
        DocumentType.diploma => 'Diploma',
        DocumentType.transcript => 'Transcript',
        DocumentType.cv => 'CV',
        DocumentType.motivationLetter => 'Motivation Letter',
        DocumentType.nationalId => 'National ID',
        DocumentType.passportPhoto => 'Passport Photo',
        DocumentType.englishCertificate => 'English Certificate',
        DocumentType.frenchCertificate => 'French Certificate',
      };
}
