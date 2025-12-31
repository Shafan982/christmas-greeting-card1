global with sharing class HolidayGreetingGenerator {

    @InvocableMethod(
        label='Generate Holiday Greeting Image'
        description='Calls external service to create an Image and returns the URL'
    )
    global static List<ImageResponse> generateImage(List<ImageRequest> requests) {

        List<ImageResponse> responses = new List<ImageResponse>();

        for (ImageRequest req : requests) {
            String templateId =
                (req.templateData != null && String.isNotBlank(req.templateData.templateId))
                ? req.templateData.templateId
                : 'template1';

            ImageResponse response = callExternalImageService(
                req.recipientName,
                req.holidayMessage,
                templateId,
                req.fromName
            );

            responses.add(response);
        }
        return responses;
    }

    // ---------------- REQUEST CLASS ----------------
    @JsonAccess(serializable='always' deserializable='always')
    global class ImageRequest {

        @InvocableVariable(
            label='Recipient Name'
            description='Name of the recipient for the holiday greeting'
            required=true
        )
        global String recipientName;

        @InvocableVariable(
            label='Generated Message'
            description='The holiday greeting message to be included in the Image. Always confirm the message with the user.'
            required=true
        )
        global String holidayMessage;

        @InvocableVariable(
            label='Template ID'
            description='Template ID to use for Image generation. Always ask to choose the template'
            required=true
        )
        global TemplateData templateData;

        @InvocableVariable(
            label='From Name'
            description='Name of the sender for the holiday greeting'
            required=true
        )
        global String fromName;
    }

    // ---------------- RESPONSE CLASS ----------------
    @JsonAccess(serializable='always' deserializable='always')
    global class ImageResponse {

        @InvocableVariable(
            label='Download URL'
            description='URL to download the generated Image'
        )
        global String downloadUrl;
    }

    // ---------------- TEMPLATE DATA ----------------
    global class HolidayTemplateSelector  {
        @InvocableVariable(required=true)
        global String templateId;
    }

    // ---------------- CALLOUT METHOD ----------------
    private static ImageResponse callExternalImageService(
        String name,
        String message,
        String templateId,
        String fromName
    ) {
        ImageResponse imageResponse = new ImageResponse();

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        // ✅ Named Credential endpoint
        request.setEndpoint('callout:Holiday_Greeting_Service/api/greeting/generate');

        // ✅ POST method
        request.setMethod('POST');

        // ✅ Timeout 120 seconds
        request.setTimeout(120000);

        // ✅ Headers
        request.setHeader('Content-Type', 'application/json');

        // Request body
        Map<String, String> bodyMap = new Map<String, String>{
            'templateId' => templateId,
            'message' => message,
            'to' => name,
            'from' => fromName
        };

        // ✅ Serialize body
        request.setBody(JSON.serialize(bodyMap));

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            try {
                Map<String, Object> responseMap =
                    (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                Boolean success = (Boolean) responseMap.get('success');

                if (success == null || !success) {
                    throw new ImageGenerationException(
                        'Image generation failed: success=false'
                    );
                }

                if (responseMap.containsKey('downloadUrl')) {
                    imageResponse.downloadUrl =
                        (String) responseMap.get('downloadUrl');
                } else {
                    throw new ImageGenerationException(
                        'Image generation failed: downloadUrl missing'
                    );
                }

            } catch (Exception e) {
                throw new ImageGenerationException(
                    'Error parsing response: ' + e.getMessage()
                );
            }
        } else {
            throw new ImageGenerationException(
                'HTTP Error ' + response.getStatusCode() + ': ' + response.getBody()
            );
        }

        return imageResponse;
    }

    // ---------------- CUSTOM EXCEPTION ----------------
    global class ImageGenerationException extends Exception {}
}