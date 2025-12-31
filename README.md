# christmas-greeting-card1

Introduction
Welcome to the Agentforce 360 League Holiday Challenge! Get ready to spread some festive cheer while building your Agentforce skills. 🎉



The holidays are all about connection, warmth, and personalization. To celebrate the season, build an Employee Agent that you can use to create customized greeting cards for your colleagues, friends, and family.



We hope these custom greeting cards will replace boring WhatsApp forwards this season. :)



Before you begin
Clone the SFDX project code from this repository or download it as a zip file.
Open the project in VS Code, and Authorize the trial org you created above.
Deploy the entire force-app folder, which will give you the required classes, Lightning Web Components and Static Resources needed for this challenge.
Add https://agentforce-360-league-353a8a8aec02.herokuapp.com to Trusted URLs from Setup.
Its time to start working on the use case. As you make changes, deploy the code to the org. We can only validate the deployed code. So making changes locally will not be enough.



User Story
You will be creating an Employee Agent that does the following

Asks the user the following information
Name of the person creating the greeting
The name of the recipient of the greeting
The relationship with the recipient
This information is sent to a Prompt Template that creates a personalized message
Then, you are prompted to choose an image template for the greeting card.
Once you choose the image template, the agent invokes an external endpoint with all the above information.
The external endpoint then generates the greeting card, and returns a download link.
Task 1: Create a prompt template
Create a Flex Prompt Template with the name: HolidayGreetingPrompt
This template accepts a single text input with the name ‘Relationship’.
Here is a sample prompt to use - but feel free to tweak it based on your requirements.
Write a warm holiday greeting for my <INSERT RELATIONSHIP MERGE FIELD>.

Tone Guide:
If the relationship is professional (e.g., Colleague, Boss), keep it polite and concise.
If the relationship is personal (e.g., Friend, Family), make it heartfelt and cheerful.
Only return the text of the message itself.
Do not show the sender name, relationship, or recipient name

Message Length:
The generated message length should always be less then 300 characters.
Save and Activate the prompt template.
Task 2: Invoke External Service to Generate the Greeting Card
Create an External Credential
From the External Credentials Tab inside Named Credentials, create an External Credential with the name Greeting Service Cred.
Choose No Authentication as the Authentication Protocol.
Add a new Principal with the name All.
Create a Named Credential
Give the name “Holiday Greeting Service”. Ensure the API name is Holiday_Greeting_Service.
The URL is https://agentforce-360-league-353a8a8aec02.herokuapp.com
Choose the previously created External Credential
For the System Administrator profile, give access to the principal All, in the Enabled External Credential Principal Access section.
Update the HolidayGreetingGenerator Apex class to make a callout to the external service. Within the callExternalImageService method, add the required Apex code for the following
Endpoint: <Holiday_Greeting_Service Named Credential>/api/greeting/generate
Method: POST
Timeout: 120 seconds
Body: A serialized version of bodyMap variable.
Task 3: Create an Agent Action using the Prompt Template
From Setup, navigate to Agentforce Assets, click Actions tab and create a New Agent Action.
Configure the action as follows:
Field	Value
Reference Action Type	Prompt Template
Reference Action	HolidayGreetingPrompt
Agent Action Label	HolidayGreetingPrompt
Agent Action API Name	HolidayGreetingPrompt
Click Next.
Uncheck Show loading text for this action.
Update Agent Action Instructions with ‘Generates a personalized holiday greeting message based on a recipient's relationship type. Use this when a user wants to write a holiday card, send a greeting, or create a holiday Image for a specific person.’
Add the following instruction for the Relationship input parameter: Relationship of the Recipient with the Sender
Check Show in conversation for Prompt Response.
Click Finish.


Task 4: Create an Apex Action to generate holiday greeting image.
From Setup, navigate to Agentforce Assets, click Actions tab and create a New Agent Action.
Configure the action as follows:
Field	Value
Reference Action Type	Apex
Reference Action Category	Invocable Method
Reference Action	Generate Holiday Greeting Image
Agent Action Label	Generate Holiday Greeting Image
Agent Action API Name	Generate_Holiday_Greeting_Image
Click Next.
Uncheck Show loading text for this action.
Update Agent Action Instructions with ‘Calls external service to create an Image and returns the URL’
Check Collect from user for Template Id input parameter.
Select HolidayTemplateSelector as the data type for the Template Id.
We are using custom lightning types here, which you have learnt in Challenge 1. Refer to the LWC components in your project, to see how we implemented this.
Check Show in conversation for Download URL.
Select Rich Text as output from the dropdown.
Click Finish.


Task 5: Create a new Employee Agent
Create a new Employee Agent with the name Holiday Agent.
Add a new topic
Name: Holiday Card Creation
Classification Description: This topic helps user create, design, or send a holiday card or greeting. This topic handles message generation, template selection, and Image creation.
Scope: Use this topic when a user wants to create, design, or send a holiday card or greeting. This topic handles message generation, template selection, and Image creation.
Add the following instructions:
You must always ask for sender's and receiver's name. Don't add placeholders.
Call the 'Holiday Message Prompt' to generate a greeting. Show the message to the user for approval. Once a message is generated using the prompt template, show it to the user, and if they are satisfied, then proceed. If not, keep generating the message until the user is satisfied
Once the message is approved by the end user, always display the 'holidayTemplateSelector' LWC so the user can choose a visual design. Be explicit about the question - ask them to choose a template for their greeting card.
After the user picks a template, call the 'Generate Holiday Greeting Image' action using the generated message and the chosen template.
Provide the resulting Image URL to the user with a festive closing. Always output the Image URL as clickable HTML hyperlink.
Add the 2 actions you previously created
Generate Holiday Greeting Image
HolidayGreetingPrompt
Test your agent
A sample conversation goes something like this

You: i want to send a greeting card to my friend Satya
Agent: Could you tell me your relationship with Satya? For example, is Satya a close friend, colleague, or something else? This will help me craft the perfect holiday greeting!
You: close friend
Agent: Wishing you a joyful holiday season filled with warmth and laughter. May this time bring you peace and happiness as you create cherished memories with loved ones. Looking forward to all the wonderful moments we will share in the coming year. Happy holidays!
You: looks good
Agent: Great! Now, let's pick a template for your greeting card. <Shows a list of templates>
You: <Click on an image, and click Submit>
Agent: Your holiday greeting card for Satya is ready! Click the link below to view and download it.
If the URL is redacted in the builder, you need to add https://agentforce-360-league-353a8a8aec02.herokuapp.com to the Trusted URLs from Setup. You can still see the downloadUrl from the planner interface within your builder.



Note: The conversation you have with the agent might not look exactly like what we listed above. Overall, your agent must ask you for your name, the recipients name, and ask you to choose a template for the greeting.



Happy Holidays, and feel free to generate and share these greeting cards with your teammates on the LinkedIn group.

# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
