-- Create the Users table to store user information.
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    Username VARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the Contacts table to store user contacts.
CREATE TABLE Contacts (
    ContactID SERIAL PRIMARY KEY,
    UserID INT REFERENCES Users(UserID),
    Name VARCHAR(100),
    Email VARCHAR(255) NOT NULL,
    Phone VARCHAR(20),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the Emails table to store email messages.
CREATE TABLE Emails (
    EmailID SERIAL PRIMARY KEY,
    SenderID INT REFERENCES Users(UserID),
    RecipientID INT REFERENCES Users(UserID),
    Subject VARCHAR(255),
    Content TEXT,
    AttachmentPath VARCHAR(255),
    SentAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsRead BOOLEAN DEFAULT FALSE,
    IsStarred BOOLEAN DEFAULT FALSE,
    IsImportant BOOLEAN DEFAULT FALSE
);

-- Create a table to represent the labels or folders for organizing emails.
CREATE TABLE Labels (
    LabelID SERIAL PRIMARY KEY,
    UserID INT REFERENCES Users(UserID),
    LabelName VARCHAR(50) NOT NULL
);

-- Create a junction table to associate labels with emails.
CREATE TABLE EmailLabels (
    EmailLabelID SERIAL PRIMARY KEY,
    EmailID INT REFERENCES Emails(EmailID),
    LabelID INT REFERENCES Labels(LabelID)
);

-- Create a table to represent spam emails.
CREATE TABLE SpamEmails (
    SpamEmailID SERIAL PRIMARY KEY,
    EmailID INT REFERENCES Emails(EmailID),
    ReportedByUserID INT REFERENCES Users(UserID)
);

-- Create a table to store user settings.
CREATE TABLE UserSettings (
    SettingID SERIAL PRIMARY KEY,
    UserID INT REFERENCES Users(UserID),
    Signature TEXT,
    NotificationPreferences JSONB,
    DisplayOptions JSONB
);

-- Create a table to represent mobile devices used to access the application.
CREATE TABLE MobileDevices (
    DeviceID SERIAL PRIMARY KEY,
    UserID INT REFERENCES Users(UserID),
    DeviceName VARCHAR(100),
    DeviceType VARCHAR(50),
    LastAccessed TIMESTAMP
);

-- Create indexes for performance optimization if needed.
CREATE INDEX idx_sender_id ON Emails(SenderID);
CREATE INDEX idx_recipient_id ON Emails(RecipientID);
CREATE INDEX idx_label_id ON EmailLabels(LabelID);
