
import './App.css';
import { AddRecipe } from './comp/Addrecipe';
import Recipes from './comp/Recipes';
import { NavigationBar } from './comp/NavigationBar';
import { useState, useEffect, useCallback } from "react";



import Web3 from "web3";
import { newKitFromWeb3 } from "@celo/contractkit";
import BigNumber from "bignumber.js";


import recipe from "./contracts/recipe.abi.json";
import IERC from "./contracts/IERC.abi.json";





const ERC20_DECIMALS = 18;



const contractAddress = "0x33F7a9d78B656b5CDacD9A8f5AaaB78e95DeFeEF";
const cUSDContractAddress = "0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1";



function App() {
  const [contract, setcontract] = useState(null);
  const [address, setAddress] = useState(null);
  const [kit, setKit] = useState(null);
  const [cUSDBalance, setcUSDBalance] = useState(0);
  const [recipes, setRecipe] = useState([]);
 


  const connectToWallet = async () => {
    if (window.celo) {
      try {
        await window.celo.enable();
        const web3 = new Web3(window.celo);
        let kit = newKitFromWeb3(web3);

        const accounts = await kit.web3.eth.getAccounts();
        const user_address = accounts[0];

        kit.defaultAccount = user_address;

        await setAddress(user_address);
        await setKit(kit);
      } catch (error) {
        console.log(error);
      }
    } else {
      alert("Error Occurred");
    }
  };

  const getBalance = useCallback(async () => {
    try {
      const balance = await kit.getTotalBalance(address);
      const USDBalance = balance.cUSD.shiftedBy(-ERC20_DECIMALS).toFixed(2);

      const contract = new kit.web3.eth.Contract(recipe, contractAddress);
      setcontract(contract);
      setcUSDBalance(USDBalance);
    } catch (error) {
      console.log(error);
    }
  }, [address, kit]);


  


  const getRecipes = useCallback(async () => {
    const recipesLength = await contract.methods.getRecipesLength().call();
    const recipes = [];
    for (let index = 0; index < recipesLength; index++) {
      let _recipes = new Promise(async (resolve, reject) => {
      let recipe = await contract.methods.getRecipe(index).call();

        resolve({
          index: index,
          owner: recipe[0],
          title: recipe[1],
          description: recipe[2],
          image: recipe[3],
          price: recipe[4],    
        });
      });
      recipes.push(_recipes);
    }


    const _recipes = await Promise.all(recipes);
    setRecipe(_recipes);
  }, [contract]);


  const addRecipe = async (
    _title,
    _description,
    _image,
    _price
  ) => {
    try {
      await contract.methods
        .addRecipe(_title, _description, _image, _price)
        .send({ from: address });
      getRecipes();
    } catch (error) {
      alert(error);
    }
  };




        const BuyRecipe = async (_index) => {
          try {
            const cUSDContract = new kit.web3.eth.Contract(IERC, cUSDContractAddress);
            await cUSDContract.methods
              .approve(contractAddress, recipe[_index].price)
              .send({ from: address });
            await contract.methods.buyRecipe(_index).send({ from: address });
            getRecipes();
            getBalance();
            alert("you have successfully bought the recipe");
          } catch (error) {
            alert(error);
          }};

          const changePrice = async (_index, _price) => {
            try {
              await contract.methods.changeRecipePrice(_index, _price).send({ from: address });
              getRecipes();
              alert("you have successfully changed the recipe price");
            } catch (error) {
              alert(error);
            }};

    

  useEffect(() => {
    connectToWallet();
  }, []);

  useEffect(() => {
    if (kit && address) {
      getBalance();
    }
  }, [kit, address, getBalance]);

  useEffect(() => {
    if (contract) {
      getRecipes();
    }
  }, [contract, getRecipes]);
  return (
    <div className="App">
      <NavigationBar cUSDBalance={cUSDBalance} />
      <AddRecipe addRecipe={addRecipe}/>
      <Recipes  buyRecipe={BuyRecipe} walletAddress={address} recipes={recipes} changePrice={changePrice}/>
    </div>
  );
}

export default App;
