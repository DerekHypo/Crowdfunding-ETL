CREATE TABLE "campaign" (
    "cf_id" int NOT NULL,
    "contact_id" int NOT NULL,
    "company_name" varchar(100) NOT NULL,
    "description" text NOT NULL,
    "goal" numeric(10,2) NOT NULL,
    "pledged" numeric(10,2) NOT NULL,
    "outcome" varchar(50) NOT NULL,
    "backers_count" int NOT NULL,
    "country" varchar(10) NOT NULL,
    "currency" varchar(10) NOT NULL,
    "launch_date" date NOT NULL,
    "end_date" date NOT NULL,
    "category_id" varchar(10) NOT NULL,
    "subcategory_id" varchar(10) NOT NULL,
    CONSTRAINT "pk_campaign" PRIMARY KEY (
        "cf_id"
     )
);

CREATE TABLE "category" (
    "category_id" varchar(10) NOT NULL,
    "category_name" varchar(50) NOT NULL,
    CONSTRAINT "pk_category" PRIMARY KEY (
        "category_id"
     )
);

CREATE TABLE "subcategory" (
    "subcategory_id" varchar(10) NOT NULL,
    "subcategory_name" varchar(50) NOT NULL,
    CONSTRAINT "pk_subcategory" PRIMARY KEY (
        "subcategory_id"
     )
);

CREATE TABLE "contacts" (
    "contact_id" int NOT NULL,
    "first_name" varchar(50) NOT NULL,
    "last_name" varchar(50) NOT NULL,
    "email" varchar(100) NOT NULL,
    CONSTRAINT "pk_contacts" PRIMARY KEY (
        "contact_id"
     )
);


ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_contact_id" FOREIGN KEY("contact_id")
REFERENCES "contacts" ("contact_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_category_id" FOREIGN KEY("category_id")
REFERENCES "category" ("category_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_subcategory_id" FOREIGN KEY("subcategory_id")
REFERENCES "subcategory" ("subcategory_id");

CREATE TABLE backers (
	backer_id varchar(10) NOT NULL,
	cf_id int NOT NULL,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	email varchar(100) NOT NULL,
	CONSTRAINT pk_backers PRIMARY KEY (backer_id)
);
ALTER TABLE backers ADD CONSTRAINT fk_backers_cf_id FOREIGN KEY (cf_id)
REFERENCES campaign (cf_id);

SELECT * FROM backers;

SELECT cf_id, backers_count
INTO backers_by_cf_id
FROM campaign
WHERE (outcome = 'live')
GROUP BY cf_id
ORDER BY backers_count DESC;

SELECT * FROM backers_by_cf_id;

SELECT co.first_name,
	co.last_name,
	co.email,
	(ca.goal - ca.pledged) AS "Remaining Goal Amount"
	INTO email_contacts_remaining_goal_amount
FROM campaign AS ca
	LEFT JOIN contacts AS co
	ON co.contact_id = ca.contact_id
WHERE (ca.outcome = 'live')
ORDER BY "Remaining Goal Amount" DESC;

SELECT * FROM email_contacts_remaining_goal_amount;
Drop table email_contacts_remaining_goal_amount

SELECT co.first_name,
	co.last_name,
	co.email,
	(ca.goal - ca.pledged) AS "Remaining Goal Amount"
INTO email_contacts_remaining_goal_amount
FROM campaign AS ca
	LEFT JOIN contacts AS co
	ON co.contact_id = ca.contact_id
WHERE (ca.outcome = 'live')
ORDER BY "Remaining Goal Amount" DESC;

SELECT * FROM email_contacts_remaining_goal_amount;

SELECT ba.email,
	ba.first_name,
	ba.last_name,
	ca.cf_id,
	ca.company_name,
	ca.description,
	ca.end_date,
	(ca.goal - ca.pledged) AS "Left of Goal"
INTO email_backers_remaining_goal_amount
FROM backers AS ba
	LEFT JOIN campaign AS ca
	ON ca.cf_id = ba.cf_id
WHERE (ca.outcome = 'live')
ORDER BY ba.last_name, ba.email ASC;

SELECT * FROM email_backers_remaining_goal_amount;