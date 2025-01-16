import 'package:gsheets/gsheets.dart';

var sheetId = '1XGQcmnuYWNjWBjnKccTMhhrAbt4lmAN8g_EUXqWXSEI';

var credentials = r'''
{
    "type": "service_account",
    "project_id": "customersdbgsheet",
    "private_key_id": "a247b06031c09c5478d0917090d1f3e7b74168ac",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCWLpEcJgUGMrZh\niCujQAhVuzdpk4Zb7k99erWifaQWaLAIX8k82brWAm6S6ibrZ1e149vsCdSeqbgo\nosavl0uRJXdIqYIPioWnp79OEEudM06tN7BIYr8mSvxmRrH8cikHYMIYY4OD/8Si\nNwPvKrmOMvLOY9+dLHMRyM4+Q825WYYEVa40P8h+mDRUxstVQH2KjKqvNEAj5CUM\nzY6B/E+1hDdb6G5jV7KajZZ89GrKlGNPr6xH4d1nPFijHMK4AW/7r7LHUbVSknZp\nUsa9XrhprnQUBizCmGmqNFL2iVK0EOKxBO8tMgihnUr/OKOcuhesUr5UXcmZxnq+\nTw/24/wNAgMBAAECggEAFdHUs/ADLVwbWu7Hlkukml4dxilQrVUht/Om5aGXAEl7\n/+94w65HorXOPmqmNm/4kpz1NCVWfqneb4r8zoCvEjrNCqHUG3FvC0WIOi2Mat3M\nOcb8RfwQ1R2yb6KoU+r7Mo74jEYTEs/LkBzppatBs9sLo3hnwgR2AHi6HFpKDrpt\nttUKqoFKVn1mlPk41XlD0GjQWxVJzEbUj535/3Zhkxd9sPKBbxBGv7DTRh1obCMx\nmBUXpg7mtB78HFEtQxWFBqmRBtggobdhknNViHORaxg9U+4RH+CUKtf/q70seLmQ\nNed0JMxFplWhrcU8m8TOx9JiSi6nEtS1ZThCTnyzgQKBgQDP8WlFFB54UNlpfb0k\nNCg4h2gTnn/TALO/olx59ej/8fU23iLo9Ku1j88k9kEQokWMGgVS+8gzNgN+6USM\nUk1DNeQGMKV4gkrev/9RqWBp483OlzwuJdxoHBzMSz6vkach2YwLNS+2cc0X40EO\n6ByuXUtsqNsgJ+MyS5Y3a49VgQKBgQC449HCl/DzKOEXCatBVZYx6y1xHKpERO8b\nutsumeXjEm7fWy80sT3/NQiHPPKq0gWETngj24/GHNL5UnX9YP947bSByDL0z5SN\nUlbn6A1yavlZkGey1gk6R4u4LEYRVduwvOsGtkFeo4Wy3dYVnAKIyCNWd6EJNmwZ\nTI9qBEvkjQKBgQCjVpcBGv+gNKnCsnEa+hlJ5hr7pjnz7Y5EDm4jouVl/pJGihDT\n+jTSxmbJOuH7BewpU9swxvQIPfpa+zLMIm3sSG2X6yhfU8Ep3ZjZdXl1U+q6x5MP\nENBjuwln9AcGdBvbe/4EY7/ZyOR4Shs1cV/uGvx/GtgdFxfgzvztBYEugQKBgA81\ndljKhOCLuVBa1EKQlsVOcjN+xybMgNrIGSWRNU7jgklPR+fOuKnYo/Xz9oZEtn12\nsv1IH2CNmHE37krEgt9gtluCq2Zl+PNTFaEH/qstz4sljNIyNxobLowc4Dqm1GaK\nc87eiSwOyX24L9chOTglNnrzZkTKvEOsf5OZ/OA1AoGANwwFFH/fDGTCUNacG2xX\neKGgqtfSSJ2ESoJVL8+bzFcrXYfov9KO8gP38dQF2l8Pp9HifrbAG2CZMDrjNfKy\n3D/0wpvEybRUBe0GT8wuYGay109B7k3tVSOsDurHSRBR8x8PDaC35PnVWMIcmtwE\namxbLeGw5tV3GonJEclcquc=\n-----END PRIVATE KEY-----\n",
    "client_email": "customers-db-gsheet@customersdbgsheet.iam.gserviceaccount.com",
    "client_id": "112633399195185431627",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/customers-db-gsheet%40customersdbgsheet.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
}''';

final gsheetinit = GSheets(credentials);

var GsheetController;

Worksheet? gsheetCrudUserDetails;

Future<void> GSheetInit() async {
  try {
    GsheetController = await gsheetinit.spreadsheet(sheetId);
    gsheetCrudUserDetails =
        await GsheetController.worksheetByTitle('Customers_DB_Gsheet');

    if (gsheetCrudUserDetails == null) {
      throw Exception('Worksheet not found. Please verify the title.');
    }

    print('Google Sheets initialized successfully.');
  } catch (e) {
    print('Error initializing Google Sheets: $e');
    rethrow;
  }
}
