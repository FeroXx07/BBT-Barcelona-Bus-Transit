// Returns the api key as string
String getApiString() {
  const apiKey = "app_id=d18b8b20&app_key=2b2d1c3e52ef4b50ee99c859036873c8";

  if (apiKey.isEmpty) {
    throw AssertionError('APP_KEY is not set');
  }

  return apiKey;
}
