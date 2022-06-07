// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}



contract RecipeDaap {

    uint internal recipesLength = 0;
    uint256 internal recipesId = 0;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    struct Recipe {
        address payable owner;
         uint recipeId;
        string title;
        string description;
        string image;
        uint price;
        bool forSale;
       
    }

    mapping (uint => Recipe) internal recipes;


// this function will add a new recipe to the block-chain
    function addRecipe(
        string memory _title,
        string memory _description,
        string memory _image,  
        uint _price

    ) public {
        
        recipes[recipesLength] = Recipe(
            payable(msg.sender),
            recipesId,
            _title,
            _description,
            _image,
            _price,
            true
        );
        recipesLength++;
        recipesId++;
    }

// this function will get a recipe from the block-chain
    function getRecipe(uint _index) public view returns (
        address payable,
        uint256,
        string memory, 
        string memory, 
        string memory, 
        uint,
        bool
    ) {
        return (
            recipes[_index].owner,
             recipes[_index].recipeId,
            recipes[_index].title, 
            recipes[_index].description, 
            recipes[_index].image, 
            recipes[_index].price,
            recipes[_index].forSale
        );
    }
//edit an existing recipe in the block-chain 
  function editRecipe(
      uint _index, 
      string memory _title, 
      string memory _description, 
      string memory _image,
      uint _price
      ) public {
    require(msg.sender == recipes[_index].owner, "you cannot edit this recipe");
    recipes[_index].title = _title;
    recipes[_index].description = _description;
    recipes[_index].image = _image;
    recipes[_index].price = _price;
}


// change the price of a recipe in the block-chain
     function changeRecipePrice(uint _index, uint _price) external {
        require(msg.sender == recipes[_index].owner, "Only the owner can change the price");
        recipes[_index].price = _price;
    }

     // toggle forsale
      function toggleForsale(uint _index) external{
        require(msg.sender == recipes[_index].owner, "Only admin");
        recipes[_index].forSale = !recipes[_index].forSale;
    }

    
    // delete a recipe from the mapping
      function deleteRecipe(uint _index) external {
	        require(msg.sender == recipes[_index].owner, "you cannot delete this recipe");         
            recipes[_index] = recipes[recipesLength - 1];// replace the index to delete with the last valid recipe item
            delete recipes[recipesLength - 1]; // reset the last valid recipe item to the default value
            recipesLength--; // reduce the total books count
	    }
        
    
    // buy a recipe by paying in cUSD
    function buyRecipe(uint _index) public payable  {
        require(recipes[_index].forSale == true, "This item is not for sale");
        require(
          IERC20Token(cUsdTokenAddress).transferFrom(
            msg.sender,
            recipes[_index].owner,
            recipes[_index].price
          ),
          "Transfer failed."
        );
    }

 // get the length of the recipe mapping   
    function getRecipesLength() public view returns (uint) {
        return (recipesLength);
    }
}