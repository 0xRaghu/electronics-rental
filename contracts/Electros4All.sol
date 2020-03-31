pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;
contract AppUser {
    
    struct User {
        string Name;
        string Address;
        uint PhoneNumber;
        bool kyc;
        bool Rentor ;
        bool Rentee;
        uint NoOfProducts ;
    }
    
    struct Product {
        string ProductName;
        string ProductDescription;
        uint MonthlyRental;
        uint Deposit;
        uint ID;
        address payable POwner;
        address payable renterAddress;
        uint start_time;
        bool status;
        bool isDelivered;
    }
    mapping(address=>User) public UserD;
    mapping(uint=>Product) public PD;
    
    address payable public ContractOwner;
    uint public ProductID;
    uint private Commission = 50000000000000000;

    constructor() public {
        ContractOwner = msg.sender;
    }
    
    function Register (User memory user1) public {
        require(msg.sender!=ContractOwner,"ContractOwner cant be a Rentor or Rentee");
        require((user1.Rentee || user1.Rentor),'Please select atleast one role');
        require(user1.kyc, 'User should be KYC Complaint');
        UserD[msg.sender] = user1;
    }
    
    function AddProduct (Product memory Product1) public payable {
        User memory user = UserD[msg.sender];
        require(user.Rentor && user.NoOfProducts <= 10, 'Rentor is not adding the product or User is trying to add more than 10 products');
        require(msg.value == Commission,'Rentor required to pay 0.05 commission to add each product to the contract');
        require(Product1.Deposit == Product1.MonthlyRental*2,'Deposit should always be twice the MonthlyRental value');
        ContractOwner.transfer(msg.value);
        Product1.ID = ProductID;
        Product1.POwner = msg.sender;
        PD[Product1.ID] = Product1;
        UserD[msg.sender].NoOfProducts++;
        ProductID++;
    }
    
    function RentProduct(uint pid) public payable {
        require(UserD[msg.sender].Rentee == true,'Only rentee can access this function');
        require(msg.value - PD[pid].MonthlyRental*10**18 - Commission  == PD[pid].Deposit*10**18, 'Required to Pay Deposit + MonthlyRental + 0.05 Commission');
        //50000000000000000 - commission to ContractOwner
        require(msg.value - (PD[pid].Deposit*10**18) - Commission == PD[pid].MonthlyRental*10**18, 'Enter valid MonthlyRental value');
        require(PD[pid].status == false, 'Product is rented already');
        PD[pid].status = true;
        PD[pid].renterAddress = msg.sender;
        // event to notify rentor to send the product to rentee
    }
    
    function Delivered(uint delivery) public  {
        require(UserD[msg.sender].Rentee == true, 'Only Rentee can access this function to set the Delivery Status');
        require(PD[delivery].renterAddress == msg.sender,'This Rentee doesnt have this product rented');
        require(PD[delivery].isDelivered == false,'You have marked to return the product/Already Delivered/Rented by someother user');
        PD[delivery].isDelivered = true;
        PD[delivery].POwner.transfer(PD[delivery].MonthlyRental * (10**18)); //transfer of MR to Rentor
        ContractOwner.transfer(Commission); // transfer of commission to ContractOwner
        UserD[msg.sender].NoOfProducts++;
        PD[delivery].start_time = now;

    }

    function MRpayment(uint pid) public payable {
        require(UserD[msg.sender].Rentee == true,'Only Rentee can make payment');
        require(PD[pid].renterAddress == msg.sender,'This Rentee doesnt have this product rented');
        require(msg.value == PD[pid].MonthlyRental*10**18,'Value not equal to the MonthlyRental value set');
        require(now <= PD[pid].start_time + (3600 * 24 * 31),'Payment gateway closed , MonthlyRental will be cut from Deposit');
        require(PD[pid].isDelivered == true,'You have marked to return the product');
        PD[pid].POwner.transfer(msg.value);
        PD[pid].start_time = now;
    }
    
    function ReturnProduct(uint pid) public {
        require(UserD[msg.sender].Rentee == true,'Only Rentee can place the Return order');
        require(PD[pid].renterAddress == msg.sender,'This Rentee doesnt have this product rented');
        require(PD[pid].isDelivered == true,'You have marked to return the product or not yet rented');
        require(now <= PD[pid].start_time + (3600 * 24 * 31),'Payment gateway closed , MonthlyRental will be cut from Deposit');
        PD[pid].isDelivered = false;
    }
    
    function ReturnOnSameDay(uint pid) public payable {
        require(UserD[msg.sender].Rentee == true,'Only Rentee can place the Return order');
        require(PD[pid].renterAddress == msg.sender,'This Rentee doesnt have this product rented');
        require(PD[pid].isDelivered == false,'You have rented this product');
        require(PD[pid].start_time == 0,'Product is Delivered and Rental started');
        PD[pid].renterAddress.transfer((PD[pid].Deposit*10**18 + (PD[pid].MonthlyRental)*10**18) + Commission);
        PD[pid].renterAddress = 0x0000000000000000000000000000000000000000;
        PD[pid].status = false;
    }
    
    function ReclaimProduct(uint pid) public payable {
        require(UserD[msg.sender].Rentor == true,'Only Rentor can access Reclaim Product');
        require(PD[pid].POwner == msg.sender, 'This Rentor is not the Owner of this Product');
        require(PD[pid].status == true,'This Product have not been rented yet');
        require(PD[pid].start_time != 0,'This product is not delivered to Rentee yet');
        if(PD[pid].isDelivered == false) {
            PD[pid].renterAddress.transfer(PD[pid].Deposit*10**18);
        } else if(( PD[pid].isDelivered && now > PD[pid].start_time + (3600 * 24 * 31)) ) {
            PD[pid].POwner.transfer(PD[pid].MonthlyRental*10**18);
            PD[pid].renterAddress.transfer(PD[pid].Deposit*10**18-PD[pid].MonthlyRental*10**18);
         }
         PD[pid].renterAddress = 0x0000000000000000000000000000000000000000;
            PD[pid].status = false;
            PD[pid].start_time = 0;
    }
    
    function Get_Contract_Balance() public view returns(uint){
        return address(this).balance;
    }
    
    function Get_Balance(address user) public view returns(uint){
        return user.balance;
    }
    
//     receive() external payable  //fallback function
//     {
      
//     }
   
  //selfdestruct function
    function kill() public {
    require (msg.sender == ContractOwner,"ContractOwner only can access selfdestruct feature");
    selfdestruct(ContractOwner);
    }

}



// function DefaulterList() public returns (address[] memory) {
    //     require(UserD[msg.sender].Rentor == true,'Only Rentor can access this function');
    //     // address [] memory defaulterList;
    //     for(uint i = 0 ; i < ProductID; i++) {
    //         if(PD[i].POwner == msg.sender) {
    //             if(now >= PD[i].start_time + (3600 * 24 * 31)) {
    //                 defaulterList[i] = ((PD[i].renterAddress));
    //             }
    //         }
    //     }
    //     return defaulterList;
    // }
    // // Event - Rentor to view the defaulterList
    
    // function ReturnersList() public returns (address[] memory) {
    //     require(UserD[msg.sender].Rentor == true,'Only Rentor can access this function');
    //     //address [] memory returnersList;
    //     for(uint i = 0 ; i < ProductID; i++) {
    //         if(PD[i].POwner == msg.sender) {
    //             if(now <= PD[i].start_time + (3600 * 24 * 31) && PD[i].isDelivered == false) {
    //                 returnersList[i] = ((PD[i].renterAddress));
    //             }
    //         }
    //     }
    //    return returnersList;
    //}
    // Event - Rentor to view the ReturnersList