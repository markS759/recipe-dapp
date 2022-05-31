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
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    struct Recipe {
        address payable owner;
        string title;
        string description;
        string image;
        uint price;
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
            _title,
            _description,
            _image,
            _price
        );
        recipesLength++;
    }

// this function will get a recipe from the block-chain
    function getRecipe(uint _index) public view returns (
        address payable,
        string memory, 
        string memory, 
        string memory, 
        uint 
    ) {
        return (
            recipes[_index].owner,
            recipes[_index].title, 
            recipes[_index].description, 
            recipes[_index].image, 
            recipes[_index].price
        );
    }
// this function will edit an existing recipe in the block-chain 
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

     function changeRecipePrice(uint _index, uint _price) public {
        require(msg.sender == recipes[_index].owner, "Only the owner can change the price");
        recipes[_index].price = _price;
    }
    

    function deleteRecipe(uint _index) external{
        require(msg.sender == recipes[_index].owner, "you cannot delete this recipe");
        delete recipes[_index];
    }
    
    
    function buyRecipe(uint _index) public payable  {
        require(
          IERC20Token(cUsdTokenAddress).transferFrom(
            msg.sender,
            recipes[_index].owner,
            recipes[_index].price
          ),
          "Transfer failed."
        );
    }
    
    function getRecipesLength() public view returns (uint) {
        return (recipesLength);
    }
}