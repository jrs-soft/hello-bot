# HelloBot Architecture (Salesforce Apex + Flow)

This project implements a chatbot orchestration pattern using Salesforce Flow and Apex, with the Strategy design pattern to manage multiple conversation types.

## Architecture Overview

![Architecture Diagram](./diagram.svg)

### ✅ Flow

- User-friendly welcome screen
- Offers choices (tracking, support, etc.)
- Passes user inputs to an Apex Action with parameters

### ✅ BotController

- Single point of entry for Apex logic
- Receives the action and payload from the Flow
- Delegates to the BotFactory to decide the strategy

### ✅ BotFactory

- Contains the routing logic to select the correct strategy
- Returns the appropriate `BotStrategy` implementation

### ✅ Bot Strategies (Strategy Pattern)

- `TrackingStrategy`
- `SupportStrategy`
- `ReturnPolicyStrategy`
- `ServiceContractStrategy`
  
Each strategy implements the common `BotStrategy` interface.

- Strategies **should** be simple, delegating business rules to a *Service* layer.

### ✅ Service Layer

For example:
- `TrackingService` processes the business logic for tracking orders
- The Service delegates to a Repository for persistence

### ✅ Repository Layer

For example:
- `TrackingRepository` handles actual database writes
- It can directly call DML to persist to Salesforce objects

### ✅ InteractionLogger

- A helper component to centralize logging of interactions
- Saves records into the `InteractionLog__c` object

### ✅ InteractionLog__c

Custom object to store:
- Action
- Payload
- Status
- Timestamp
- User

---

## Deployment

You can deploy using Salesforce DX:

```bash
sf project deploy start --source-dir force-app

## Future Improvements

Here are ideas for enhancing this architecture in future iterations:

### 1️⃣ Logging / Auditing

- Enrich the current `InteractionLogger` to include:
  - response time
  - flow execution context
  - error stack traces (if any)
  - conversation session ID  
- This will provide more complete traceability for debugging and compliance.

---

### 2️⃣ Externalizing Messages

- Move static strings, such as debug logs and user messages, to Salesforce **Custom Labels**.
- This allows easy translation or message changes without modifying Apex code.

---

### 3️⃣ Extensible Strategy Mapping

- Today the `BotFactory` hardcodes the mapping of actions to strategies.
- In future, consider leveraging **Custom Metadata Types** to map `action → Apex class name` dynamically.
- This will make the bot more configurable without code changes.

---

### 4️⃣ External Logging Integrations

- Integrate with Salesforce **Platform Events**, or external tools like ELK / Splunk, to send conversation data in real time.
- This improves monitoring and facilitates analytics beyond the Salesforce UI.

---
