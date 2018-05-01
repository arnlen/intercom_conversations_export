# INTERCOM CONVERSATIONS EXPORTER

## Required

Based on this tuto: https://developerblog.intercom.com/a-beginners-guide-to-exporting-intercom-conversations-with-the-conversations-api-d7bb1c24983c

## Usage

```
ruby run.rb
```

## Examples

Console:

```
$ ruby run.rb
Writing output to /Users/arnaudlenglet/dev/panda_intercom_extract/conversation_exports/1525179886_panda_intercom.export
>>> --- Script started @ 2018-05-01 15:04:46 +0200
RATE LIMIT:
Exporting conversation 1 of 300
Exporting conversation 2 of 300
Exporting conversation 3 of 300
Exporting conversation 4 of 300
Exporting conversation 5 of 300
Exporting conversation 6 of 300
Exporting conversation 7 of 300
Exporting conversation 8 of 300
Exporting conversation 9 of 300
Exporting conversation 10 of 300
Exporting conversation 11 of 300
Exporting conversation 12 of 300
Exporting conversation 13 of 300
Exporting conversation 14 of 300
Exporting conversation 15 of 300
Exporting conversation 16 of 300
Exporting conversation 17 of 300
Exporting conversation 18 of 300
Exporting conversation 19 of 300
Exporting conversation 20 of 300
PAGINATION: page 1 of 15
RATE LIMIT: 79
Exporting conversation 21 of 300
Exporting conversation 22 of 300

...

```

Output file:

```
------------- ------------- ------------- -------------
PANDA Intercom export archive script
Started on: 2018-05-01 15:04:46 +0200
By: Arnaud Lenglet (@arnlen)
------------- ------------- ------------- ------------- ------------- -------------


Exporting conversation 1 of 300


------------- ------------- ------------- -------------
------------- ------------- CONVERSATION 16076369077 START ------------- -------------


CONVERSATION ID: 16076369077
NUM PARTS: 0


------------- ------------- CONVERSATION 16076369077 END ------------- -------------
------------- ------------- ------------- ------------- ------------- -------------


Exporting conversation 2 of 300


------------- ------------- ------------- -------------
------------- ------------- CONVERSATION 15993610078 START ------------- -------------


CONVERSATION ID: 15993610078
NUM PARTS: 8

<-------- CONVERSATION PART 1 OF 8 -------->

PART TYPE: comment
PART BODY:
Hello Laure, 

Merci beaucoup pour ton message. Je suis Jeremy, en charge de la communication chez PANDA guide.

...
```

## Known issue

Exportation fails on the last page, due to pagination issue. Didn't dig into this.