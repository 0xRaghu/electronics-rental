# Ethereum-Project

Electros4All:  
Idea is to create a Blockchain based DApp platform, where anyone can list their electronics appliances and anyone can rent it without any third party involved. This app handles all the Tx on its own , without any Admin involvement.
Similar kind of applications are in market and below are the issues faced  in traditional system :
•	The third party is involved , which slows down process time each step of the app flow.
•	In case of faulty product or issue with the product , User has to raise the support ticket and wait for resolution after speaking with both rentor and rentee.
•	Possible data leakage which is the threat exits in the centralized data system.
•	Applications have downtimes like maintenance , code upgrade , third party services server are down etc.
•	App could be hack able in traditional systems , which could lead in data breach and money loss
•	Cant maintain the anonymity in the traditional system , one has to provide all the sensitive data of his/her to prove his authenticity.
Possible problems solved using this Dapp :
•	No third party involved , direct P2P communication, which speeds up the process flow
•	Any issues with the product or payment all are solved by direct users who are involved.
•	As the data is stored in public decentralized system , the user data is kept secured than traditional systems
•	Distributed ledger keeps track of all the Tx made on the platform , which adds the immutable feature to the data.
•	No downtime 
•	No worry about the security aspects of the app and user will have the full authority of their data.
•	Anonymity is maintained throughout the app , so users no longer required to reveal their identity for authenticity.
Project Description :
Code written : Solidity (Coded & Tested on Remix IDE/VisualStudioCode)
Test script written : JavaScript
Test suite used : Truffle (Migrate & Deploy)
Deployed on – Rinkeby Ethereum Testnet – Infura node
Security Analysis : SmartCheck


Users involved :
•	Rentor - App user who lists his product into the platform for rental
•	Rentee - App user who can rent the product listed in the platform

Functions :
•	Constructor – To set the contract owner
•	Register – Rentee / Rentor / Rentee and Rentor
•	AddProduct – Rentor only can add product with its details , 0.05 commission to the contract owner
•	RentProduct – Rentee only can rent product , twice the MR as deposit and 0.05 commission to the contract
•	Delivered – Mark the product has been delivered and the Rental start time recorded. Only by Rentee
•	ReturnOnSameDay – If the product is faulty or found different from what have been mention , Rentee can return the product on the same day and the deposit + MR + commission are returned to Rentee immediately
•	MRPayment – Only Rentee , to pay monthly rental value directly to the product owner
•	ReturnProduct – Only by Rentee , to return the product. Gets back the deposit alone.
•	ReclaimProduct – Only rentor , to confirm that the Rentee had sent the product back and incase the MR was not paid , he can recall the product and get 1 MR rent as penalty from Rentee’s deposit which is in contract and remaining deposit is sent back to rentee.
•	Get_Contract_Balance : To check the value which the contract holds
•	Get_Balance : Used to get the balance of the given address.
