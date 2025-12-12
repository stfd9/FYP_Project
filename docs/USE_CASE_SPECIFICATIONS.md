# Use Case Specifications - Pet Health Monitoring System

---

## 1. LOGIN

| Field | Description |
|-------|-------------|
| **Use Case Name** | Login |
| **Actor(s)** | User, Admin |
| **Brief Description** | This use case allows the user to authenticate themselves and gain access to the application's features. |
| **Precondition** | The user must have an account in the system. |
| **Postcondition** | The user is successfully authenticated and is directed to the main application dashboard or home screen. |
| **Main Flow of Events** |
|
| **Actor Action** | **System Response** |
| 1. User enters their Email. | |
|  | 4. System validates credentials. |
| 2. User enters their Password. | |
|  | 5. System creates a user session. |
| 3. User clicks the "Log in" button. | |
|  | 6. System directs the user to the homepage. |
| **Alternative Flow** | A1 (Social Login): User selects Facebook or Google icon; system redirects to provider, obtains OAuth token and links or creates a local account so user is logged in.<br/>A2 (Password Reset): User clicks "Forgot Password"; system sends reset email and user resets password via token. |
| **Exception Flow** | E1 (Missing Fields): System shows field-specific error messages.<br/>E2 (Invalid Credentials): System shows "Invalid email or password."<br/>E3 (Account Locked): System locks account after repeated failures and notifies the user. |
| **Functional Requirement** | 1. System shall allow users to log in using email/password. 2. System shall support third-party authentication. 3. System shall establish secure sessions. 4. System shall validate input formats. 5. System shall support password reset. |
| **Non-Functional Requirement** | Security: Confidentiality and secure session management for authentication.<br/>Performance: Authentication responses within acceptable latency so login feels responsive.<br/>Usability: Clear error messages and accessible login flows. |

---

## 2. REGISTER

| Field | Description |
|-------|-------------|
| **Use Case Name** | Register |
| **Actor(s)** | User |
| **Brief Description** | A new user creates an account by providing email, password, and basic profile information. |
| **Precondition** | User does not have an existing account. |
| **Postcondition** | New account created and verified or redirected to login. |
| **Main Flow of Events** |
|
| **Actor Action** | **System Response** |
| 1. User navigates to registration page. | |
|  | 8. System validates fields and password strength. |
| 2. User enters email address. | |
|  | 9. System checks email uniqueness. |
| 3. User enters full name. | |
|  | 10. System creates account and sends verification email. |
| 4. User enters password. | |
| 5. User confirms password. | |
| 6. User accepts terms and conditions. | |
| 7. User clicks "Register". | |
| **Alternative Flow** | A1 (Social Registration): Social provider data used to create or link account and log the user in.<br/>A2 (Email Verification): User clicks verification link; system verifies email and activates account. |
| **Exception Flow** | E1 (Email Exists): System shows an error that the email already exists.<br/>E2 (Weak Password): System shows password-strength validation message.<br/>E3 (T&Cs Not Accepted): System blocks registration until terms are accepted. |
| **Functional Requirement** | Email uniqueness, password policy, verification email, secure storage. |
| **Non-Functional Requirement** | Security: Secure storage of credentials and verification tokens.<br/>Performance: Registration completes within a short time and verification emails dispatched promptly.<br/>Privacy: Minimize collected data and follow retention rules. |

---

## 3. MANAGE PET PROFILE

| Field | Description |
|-------|-------------|
| **Use Case Name** | Manage Pet Profile |
| **Actor(s)** | User |
| **Brief Description** | User creates, views, updates pet profiles (info, photos, history). |
| **Precondition** | User is authenticated. |
| **Postcondition** | Pet profile created or updated and visible. |
| **Main Flow of Events** |
|
| **Actor Action** | **System Response** |
| 1. User navigates to "My Pets". | |
|  | 6. System validates required fields. |
| 2. User clicks "Add New Pet". | |
|  | 7. System processes image and stores profile. |
| 3. User enters pet name, species, breed, DOB, weight. | |
|  | 8. System displays confirmation and updates list. |
| 4. User uploads pet photo (optional). | |
| 5. User clicks "Save Pet". | |
| **Alternative Flow** | A1 (Quick Add): Create basic profile without photo.<br/>A2 (Edit Profile): User edits existing profile; system updates fields.<br/>A3 (Bulk Import): User imports CSV; system validates and imports valid rows. |
| **Exception Flow** | E1 (Missing Fields): System prompts user to fill required fields.<br/>E2 (Invalid Data): System rejects invalid DOB or unsupported photo formats/sizes.<br/>E3 (Duplicate): System warns about duplicate pet names and requests confirmation. |
| **Functional Requirement** | CRUD operations, image upload/compression, age calc, health history. |
| **Non-Functional Requirement** | Performance: Fast CRUD operations and image processing.<br/>Storage: Optimize image storage and retention policies.<br/>Security: Access controls for pet data. |

---

## 4. MANAGE ACCOUNT DETAILS

| Field | Description |
|-------|-------------|
| **Use Case Name** | Manage Account Details |
| **Actor(s)** | User |
| **Brief Description** | User views/updates personal account info and preferences. |
| **Precondition** | User is authenticated. |
| **Postcondition** | Account updated; confirmations sent for sensitive changes. |
| **Main Flow of Events** |
|
| **Actor Action** | **System Response** |
| 1. User opens Account Settings. | |
|  | 5. System validates inputs. |
| 2. User edits profile fields (name, phone, address). | |
|  | 6. System updates records and sends confirmation. |
| 3. User selects language or preferences. | |
| 4. User clicks "Save Changes". | |
| **Alternative Flow** | A1 (Email Change): System verifies the new email before applying change.<br/>A2 (Password Change): System validates current password before updating.<br/>A3 (Enable 2FA): System provisions and verifies two-factor authentication. |
| **Exception Flow** | E1 (Invalid Contact): System rejects invalid phone/email formats.<br/>E2 (Bad Current Password): System shows an error when the current password is incorrect.<br/>E3 (Address Validation Fail): System requests corrected address details. |
| **Functional Requirement** | Update profile, validation, audit log, 2FA support. |
| **Non-Functional Requirement** | Security: Protect sensitive changes with verification and audit logging.<br/>Performance: Updates applied promptly.<br/>Usability: Clear guidance during sensitive operations. |

---

## 5. AI SKIN DISEASE IDENTIFIER

| Field | Description |
|-------|-------------|
| **Use Case Name** | AI Skin Disease Identifier |
| **Actor(s)** | User |
| **Brief Description** | User uploads pet skin photo; AI analyzes and returns possible diseases with recommendations. |
| **Precondition** | User authenticated; clear photo available. |
| **Postcondition** | Analysis result shown and saved. |
| **Main Flow of Events** |
|
| **Actor Action** | **System Response** |
| 1. User navigates to Skin Disease Scan. | |
|  | 4. System validates image and sends to AI model. |
| 2. User selects pet and uploads/takes photo. | |
|  | 5. AI returns diagnosis with confidence scores. |
| 3. User clicks "Analyze". | |
|  | 6. System displays results and recommendations and saves record. |
| **Alternative Flow** | A1 (Retake Photo): User retakes photo for better quality.<br/>A2 (Batch Photos): User submits multiple photos for comparison.<br/>A3 (View Details): User views detailed disease info and referral options. |
| **Exception Flow** | E1 (Poor Image): System requests a better-quality photo.<br/>E2 (AI Unavailable): System shows a temporary error and provides retry options.<br/>E3 (Inconclusive): System recommends veterinary consultation when AI confidence is low. |
| **Functional Requirement** | Image handling, AI integration, confidence scores, record storage. |
| **Non-Functional Requirement** | Accuracy: Target model accuracy and confidence thresholds.<br/>Performance: Analysis completes in acceptable time.<br/>Security & Privacy: Handle images securely and respect retention rules. |

---

## 6. AI BREED IDENTIFIER

| Field | Description |
|-------|-------------|
| **Use Case Name** | AI Breed Identifier |
| **Actor(s)** | User |
| **Brief Description** | Identify pet breed from photo and provide breed info. |
| **Precondition** | User authenticated; clear photo available. |
| **Postcondition** | Breed results shown and saved. |
| **Main Flow of Events** |
|
| **Actor Action** | **System Response** |
| 1. User opens Breed Identifier. | |
|  | 4. System validates image and sends to AI model. |
| 2. User uploads/takes photo. | |
|  | 5. AI returns likely breeds with confidence. |
| 3. User clicks "Identify Breed". | |
|  | 6. System displays top matches and breed info; saves record. |
| **Alternative Flow** | A1 (Mixed-Breed): Provide mixed-breed breakdown when applicable.<br/>A2 (Manual Selection): Allow manual selection if AI is unclear.<br/>A3 (Compare): Compare multiple pets for similarity. |
| **Exception Flow** | E1 (No Pet Detected): System requests a clearer photo.<br/>E2 (AI Down): System allows retry or manual identification when AI service is unavailable. |
| **Functional Requirement** | AI integration, breed DB, confidence scores. |
| **Non-Functional Requirement** | Performance: Low-latency identification.<br/>Accuracy: Confidence thresholds for suggestions.<br/>Privacy: Secure handling of images and minimal retention. |

---

## 7. MANAGE SCHEDULE

| Field | Description |
|-------|-------------|
| **Use Case Name** | Manage Schedule |
| **Actor(s)** | User |
| **Brief Description** | Create/view/manage pet healthcare schedules and reminders. |
| **Precondition** | User authenticated; pet(s) registered. |
| **Postcondition** | Events saved and reminders configured. |
| **Main Flow of Events** |
|
| **Actor Action** | **System Response** |
| 1. User opens Calendar/Schedule. | |
|  | 6. System validates fields and saves event. |
| 2. User clicks "Add New Event". | |
|  | 7. System schedules reminders and displays event. |
| 3. User selects pet, event type, date/time. | |
| 4. User sets reminders and notes. | |
| 5. User clicks "Save Event". | |
| **Alternative Flow** | A1 (Recurring): Create recurring events.<br/>A2 (Import): Import events from existing records or files.<br/>A3 (Share): Share calendar with family or caregivers. |
| **Exception Flow** | E1 (Conflict): System warns user about scheduling conflicts.<br/>E2 (Past Date): System rejects scheduling events in the past.<br/>E3 (Missing Location): System requests a location for vet visits. |
| **Functional Requirement** | Event types, calendar views, reminders, conflict detection. |
| **Non-Functional Requirement** | Performance: Calendar loads and queries quickly.<br/>Availability: Reminders delivered reliably. |

---

## 8. HELP & SUPPORT

| Field | Description |
|-------|-------------|
| **Use Case Name** | Help & Support |
| **Actor(s)** | User, Software Agent |
| **Brief Description** | Access FAQs, chatbot, email/phone support and documentation. |
| **Precondition** | User has a question or issue. |
| **Postcondition** | User receives help or a ticket is created. |
| **Main Flow of Events** |
|
| **Actor Action** | **System Response** |
| 1. User clicks Help or ? icon. | |
|  | 4. System returns matching articles or chatbot responses. |
| 2. User searches FAQs or chooses Chat/Email. | |
|  | 5. If escalated, system creates ticket and notifies agent. |
| 3. User reads article or interacts with chatbot. | |
| **Alternative Flow** | A1 (Escalate): Live chat escalates to a human agent.<br/>A2 (Video): Provide video tutorials.<br/>A3 (Forum): Suggest community forum answers.<br/>A4 (Email): Create an email ticket when needed. |
| **Exception Flow** | E1 (No Match): System suggests contacting support when no FAQ match is found.<br/>E2 (Unresolved): Chatbot escalates to a human agent if it cannot resolve the issue.<br/>E3 (Queue): System offers alternative channels when queues are long. |
| **Functional Requirement** | FAQ search, chatbot, ticketing, multilingual support. |
| **Non-Functional Requirement** | Performance: Fast search and chat response times.<br/>SLA: Define support SLAs for escalation. |

---

## 9. MANAGE NOTIFICATION

| Field | Description |
|-------|-------------|
| **Use Case Name** | Manage Notification |
| **Actor(s)** | User, Software Agent |
| **Brief Description** | Send and manage notifications (push, email, SMS); user configures preferences. |
| **Precondition** | User has enabled notifications. |
| **Postcondition** | Notifications delivered and preferences saved. |
| **Main Flow of Events** |
|
| **Actor Action** | **System Response** |
| 1. User opens Notification Settings. | |
|  | 4. System applies preferences and persists them. |
| 2. User configures types, channels, quiet hours. | |
|  | 5. Agent triggers notifications based on events; system queues and delivers them. |
| 3. User saves preferences. | |
| **Alternative Flow** | A1 (Digest): Daily digest aggregation.<br/>A2 (Override): Critical alert override for urgent messages.<br/>A3 (Snooze): Snooze options for notifications. |
| **Exception Flow** | E1 (Delivery Failures): System retries and logs failures.<br/>E2 (Invalid Contact): System requests updated phone/email.<br/>E3 (Unsubscribed): System respects opt-out preferences.<br/>E4 (Rate Limit): System throttles non-critical alerts under load. |
| **Functional Requirement** | Multi-channel notifications, preferences, scheduling, delivery tracking. |
| **Non-Functional Requirement** | Scalability: Handle high notification volumes.<br/>Reliability: Ensure delivery and retry policies.<br/>Compliance: Respect opt-outs and regulations. |

---

## 10. MANAGE ACCOUNT (Admin)

| Field | Description |
|-------|-------------|
| **Use Case Name** | Manage Account |
| **Actor(s)** | Admin |
| **Brief Description** | Admin manages user accounts: view, edit, suspend, delete, roles. |
| **Precondition** | Admin authenticated with privileges. |
| **Postcondition** | Account changes applied and logged. |
| **Main Flow of Events** |
|
| **Actor Action** | **System Response** |
| 1. Admin opens User Management. | |
|  | 5. System validates admin permissions and updates user record. |
| 2. Admin selects a user to view or edit. | |
|  | 6. System logs the action and notifies affected user if necessary. |
| 3. Admin modifies user details or role. | |
| 4. Admin clicks Save/Confirm. | |
| **Alternative Flow** | A1 (Suspend): Suspend account and notify user.<br/>A2 (Soft Delete): Archive data for soft-deletion workflows.<br/>A3 (Restore): Restore archived accounts.<br/>A4 (Bulk Actions): Apply bulk actions to multiple users. |
| **Exception Flow** | E1 (No Permission): System blocks actions for insufficient admin permissions.<br/>E2 (Not Found): System reports when a user is not found.<br/>E3 (DB Error): System logs DB failures and reports errors. |
| **Functional Requirement** | RBAC, audit log, account lifecycle operations. |
| **Non-Functional Requirement** | Logging: Maintain audit trails for admin actions.<br/>Retention: Follow data retention policies.<br/>Security: Strong access controls and monitoring. |

---

## 11. MANAGE ANALYSIS RECORDS (Admin)

| Field | Description |
|-------|-------------|
| **Use Case Name** | Manage Analysis Records |
| **Actor(s)** | Admin |
| **Brief Description** | Admin reviews and manages AI analysis records, verifies or corrects results. |
| **Precondition** | Admin authenticated; records exist. |
| **Postcondition** | Records verified/updated and corrections logged. |
| **Main Flow of Events** |
|
| **Actor Action** | **System Response** |
| 1. Admin opens Analysis Records. | |
|  | 5. System updates record status, logs correction, and queues correction for AI retraining. |
| 2. Admin filters/selects records to inspect. | |
| 3. Admin reviews AI result and user feedback. | |
| 4. Admin verifies or corrects diagnosis and saves. | |
| **Alternative Flow** | A1 (Accuracy Report): Generate model accuracy reports.<br/>A2 (Flag): Flag records for expert review.<br/>A3 (Bulk Verify): Bulk verification for similar records. |
| **Exception Flow** | E1 (Conflicting Feedback): Escalate to a consultant for resolution.<br/>E2 (Missing Image): Mark record for archive if source image is missing.<br/>E3 (AI Unavailable): Hold records pending model availability. |
| **Functional Requirement** | Display AI output, correction logging, reporting, retraining pipeline. |
| **Non-Functional Requirement** | Performance: Fast query and reporting for large record sets.<br/>Compliance: Maintain audit logs for corrections and retraining. |

---

## 12. REVIEW USER FEEDBACK (Admin)

| Field | Description |
|-------|-------------|
| **Use Case Name** | Review User Feedback |
| **Actor(s)** | Admin |
| **Brief Description** | Admin reviews and responds to feedback, creates tickets, and monitors trends. |
| **Precondition** | Admin authenticated; feedback exists. |
| **Postcondition** | Feedback addressed or converted into action items. |
| **Main Flow of Events** |
|
| **Actor Action** | **System Response** |
| 1. Admin opens Feedback Dashboard. | |
|  | 5. System notifies user and updates feedback status. |
| 2. Admin filters/sorts feedback. | |
| 3. Admin reviews selected item and responds or assigns. | |
| 4. Admin sends response or creates ticket. | |
| **Alternative Flow** | A1 (Dev Ticket): Create a development ticket from feedback.<br/>A2 (Merge): Merge duplicate feedback items.<br/>A3 (Escalate): Public response or escalate to management when needed. |
| **Exception Flow** | E1 (Abusive Content): Flag for moderator review.<br/>E2 (Account Deleted): Retain feedback for context even if account is deleted.<br/>E3 (No Action): Record rationale when no action is possible. |
| **Functional Requirement** | Categorization, response, ticketing, analytics. |
| **Non-Functional Requirement** | Performance: Dashboard loads and filters quickly.<br/>Retention: Store feedback per retention policy. |

---

## 13. MANAGE FAQ (Admin)

| Field | Description |
|-------|-------------|
| **Use Case Name** | Manage FAQ |
| **Actor(s)** | Admin |
| **Brief Description** | Admin creates, edits, publishes, and organizes FAQ articles. |
| **Precondition** | Admin authenticated. |
| **Postcondition** | FAQ content published and searchable. |
| **Main Flow of Events** |
|
| **Actor Action** | **System Response** |
| 1. Admin opens FAQ Management. | |
|  | 5. System validates content, indexes article, and publishes it. |
| 2. Admin clicks Create New Article and enters title, category, content. | |
|  | 6. System records analytics for article views and ratings. |
| 3. Admin sets visibility and keywords. | |
| 4. Admin clicks Publish. | |
| **Alternative Flow** | A1 (Bulk Import): Bulk import FAQs from files or sources.<br/>A2 (Versioning): Use versioning and rollback for edits.<br/>A3 (Translation): Schedule translations for multi-language support.<br/>A4 (Analytics): Drive updates from analytics insights. |
| **Exception Flow** | E1 (Duplicate): System warns and suggests merging duplicate content.<br/>E2 (Missing Fields): System blocks publishing until required fields are provided.<br/>E3 (Formatting Errors): System shows preview and highlights formatting issues. |
| **Functional Requirement** | Article management, search indexing, versioning, multi-language support. |
| **Non-Functional Requirement** | Performance: Fast indexing and search.<br/>SEO & Accessibility: Support SEO-friendly markup and accessible content. |

---

# Summary Table - Use Case Overview

| # | Use Case | Actor(s) | Type | Priority |
|---|----------|---------|------|----------|
| 1 | Login | User, Admin | Authentication | Critical |
| 2 | Register | User | Authentication | Critical |
| 3 | Manage Pet Profile | User | Core Feature | High |
| 4 | Manage Account Details | User | Account Mgmt | High |
| 5 | AI Skin Disease Identifier | User | AI Feature | Critical |
| 6 | AI Breed Identifier | User | AI Feature | High |
| 7 | Manage Schedule | User | Core Feature | High |
| 8 | Help & Support | User, Software Agent | Support | Medium |
| 9 | Manage Notification | User, Software Agent | System | High |
| 10 | Manage Account | Admin | Admin Feature | High |
| 11 | Manage Analysis Records | Admin | Admin Feature | High |
| 12 | Review User Feedback | Admin | Admin Feature | Medium |
| 13 | Manage FAQ | Admin | Admin Feature | Medium |

---

**Document Version:** 3.1  
**Last Updated:** December 13, 2025  
**Created For:** FYP - Pet Health Monitoring System

**Format Notes:** Main Flow now uses a two-column layout with `Actor Action` (left) and `System Response` (right); system responses are placed on separate right-column rows as requested.
