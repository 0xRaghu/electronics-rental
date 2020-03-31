const AppUser = artifacts.require('AppUser');

let appUser;
    beforeEach(async () => {
        appUser = await AppUser.deployed();
    });

contract('AppUser', (accounts) => {

    it ('Register user details', async () =>{
        console.log(appUser.address);
        assert(appUser.address !== '');
    });

    it ('check if the account used to deploy the contract is the ContractOwner', async () =>{
        const contractOwner = await appUser.ContractOwner.call();
        console.log(contractOwner);
        assert.equal(accounts[0], contractOwner);
    });

    it ('Check the User registration using the required details', async () =>{
        await appUser.Register(["Ram","1234abcd","1234",true,true,false,0],{
            from: accounts[1], gas: '1000000'
        }); // Rentor
        await appUser.Register(["Kiran","1234abcd","1234",true,false,true,0],{
            from : accounts[2],gas: '1000000'
        }); // Rentee 1
        await appUser.Register(["Keshav","1234abcd","1234",true,false,true,0],{
            from : accounts[3],gas: '1000000'
        }); // Rentee 2
        await appUser.Register(["Kumar","1234abcd","1234",true,true,true,0],{
            from : accounts[4],gas: '1000000' 
        }); // Rentee and Rentor

        const details = await appUser.UserD.call(accounts[1]);
        assert.equal(details.Rentor,true);
        assert.equal(details.Rentee,false);
        assert.equal(details.NoOfProducts,0);

        const details1 = await appUser.UserD.call(accounts[2]);
        assert.equal(details1.Rentee,true);
        assert.equal(details1.Rentor,false);
        assert.equal(details1.NoOfProducts,0);

        const details2 = await appUser.UserD.call(accounts[4]);
        assert.equal(details2.Rentee,true);
        assert.equal(details2.Rentor,true);
        assert.equal(details2.NoOfProducts,0);
   }); 

   it('make sure user is KYC compliant', async () => {
        try {
            await appUser.Register(["Ram","1234abcd","1234",false,false,false,0],{
            from: accounts[1], gas: '1000000'
            });
            assert(false); 
        } catch (err){
            assert(err);
            // console.log(err);
        }
    });

    it('Atleast should select one role', async () => {
        try {
            await appUser.Register(["Ram","1234abcd","1234",false,false,false,0],{
            from: accounts[1], gas: '1000000'
            });
            assert(false); 
        } catch (err){
            assert(err);
            // console.log(err);
        }
    });

    it('ContractOwner cant register as App User', async () => {
        try {
            await appUser.Register(["Ram","1234abcd","1234",true,true,false,0],{
            from: accounts[0], gas: '1000000'
            });
            assert(false); 
        } catch (err){
            assert(err);
            // console.log(err);
        }
    });

    it('Product added by Rentor with 0.05 Commission', async () => {
        await appUser.AddProduct(["Samsung TV","1234abcd","1","2",0,"0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000",0,false,false],{
            value: 50000000000000000, 
            from: accounts[1],
            gas: '1000000'
        });  
           
    });

    it('Product added by Rentor with less Commission', async () => {
        try {
            await appUser.AddProduct(["Samsung TV","1234abcd","1","2",0,"0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000",0,false,false],{
                value: 40000000000000000, 
                from: accounts[1],
                gas: '1000000'
                });
                assert(false); 
            } catch (err){
                assert(err);
                // console.log(err);
            }
        });
    it('Product added by Rentor with more Commission', async () => {
        try {
            await appUser.AddProduct(["Samsung TV","1234abcd","1","2",0,"0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000",0,false,false],{
                value: 60000000000000000, 
                from: accounts[1],
                gas: '1000000'
                });
                assert(false); 
                } catch (err){
                    assert(err);
                    // console.log(err);  
            }
        }); 
    it('Rentee trying to add product', async () => {
        try {
            await appUser.AddProduct(["Samsung TV","1234abcd","1","2",0,"0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000",0,false,false],{
                value: 50000000000000000, 
                from: accounts[2],
                gas: '1000000'
                });
                assert(false); 
            } catch (err){
                assert(err);
                // console.log(err); 
            }
    });

    it('Product added by Rentor with 0.05 Commission', async () => {
        await appUser.AddProduct(["Samsung TV","1234abcd","1","2",0,"0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000",0,false,false],{
            value: 50000000000000000, 
            from: accounts[1],
            gas: '1000000'
        });  

        // const addProduct = await appUser.ProductID(0).call();
        // console.log(addProduct);
        //assert (addProduct.Deposit == (2* addProduct.MonthlyRental));
           
    });

     }); 