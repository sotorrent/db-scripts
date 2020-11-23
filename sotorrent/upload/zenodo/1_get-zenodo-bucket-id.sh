#!/bin/bash

# retrieve Zenodo bucket id

ZENODO_TOKEN="" # update this
DEPOSIT_ID="4287411" # update this
curl "https://zenodo.org/api/deposit/depositions/$DEPOSIT_ID?access_token=$ZENODO_TOKEN" | grep -Eo '"links":{"download":"https://zenodo\.org/api/files/[^/]+'
