
PhileasConfiguration phileasConfiguration = ConfigFactory.create(PhileasConfiguration.class);

FilterService filterService = new PhileasFilterService(phileasConfiguration);

BinaryDocumentFilterResponse response = filterService.filter(filterProfiles, context, documentId, body, MimeType.APPLICATION_PDF, MimeType.IMAGE_JPEG);
