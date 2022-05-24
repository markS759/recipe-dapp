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


// delete
// edit
// change price

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
    mapping (address => uint256[]) internal RecipesBought;

    // events
    event RecipeAdded(address indexed owner, string title, uint256 price, uint256 recipe_index);
    event RecipePriceChanged(address indexed owner, uint256 recipe_index, uint256 newprice);
    event RecipeSold(address indexed buyer, address seller, uint256 recipe_index);

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
        emit RecipeAdded(msg.sender, _title, _price, recipesLength);
        recipesLength++;
    }


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

     function changeRecipePrice(uint _index, uint _price) public {
        require(msg.sender == recipes[_index].owner, "Only the owner can change the price");
        recipes[_index].price = _price;
        emit RecipePriceChanged(msg.sender, _index, _price);
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
        // added recipe list that the msg.sender bought to a mapping
        RecipesBought[msg.sender].push(_index);
        emit RecipeSold(msg.sender, recipes[_index].owner, _index);
    }
    
    function getRecipesLength() public view returns (uint) {
        return (recipesLength);
    }

    // only get index of those recipes that I bought
    function getMyRecipe() public view returns (uint256[] memory) {
        return RecipesBought[msg.sender];
    }
}
